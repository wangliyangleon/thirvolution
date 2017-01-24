class ActivitiesController < ApplicationController
  before_filter:authenticate_user!

  def new
  end

  def create
    if not_participated(current_user)
      @activity = Activity.new(activity_params)
      @activity.participate_count = 1
      current_user.participate_date = Time.zone.now.to_date
      begin
        @activity.transaction do
          @activity.participation_records.create(:user => current_user)
          @activity.save
          current_user.activity_id = @activity.id
          current_user.save
        end
        flash[:success] = "Cool! Let's start Thirvolution TODAY!!!"
        redirect_to @activity
      rescue
        flash[:alert] = "Unknown error :-("
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:alert] = "You cannot participate multiple activities"
      redirect_to activities_url
    end
  end

  def show
    @not_participated = not_participated(current_user)
    @activity = Activity.find(params[:id])
  end

  def index
    @not_participated = not_participated(current_user)
    @activities = Activity.all
  end

  def participate
    @current_activity = Activity.find(params[:id])
    if not_participated(current_user)
      current_user.activity_id = @current_activity.id
      current_user.participate_date = Time.zone.now.to_date
      @current_activity.increment(:participate_count, by = 1)
      begin
        @current_activity.transaction do
          @current_activity.participation_records.create(:user => current_user)
          @current_activity.save
          current_user.save
        end
        flash[:success] = "Cool! Let's start Thirvolution TODAY!!!"
      rescue
        flash[:alert] = "Unknown error :-("
      end
    else
      flash[:alert] =  "You cannot participate multiple activities"
    end
    redirect_back(fallback_location: root_path)
  end

  def finish
    @current_activity = Activity.find(params[:id])
    @participated = is_participated(current_user)
    @finished = is_finished_today(current_user)
    if @participated && !@finished
      begin
        @current_activity.increment(:finish_day_count, by = 1)
        current_user.increment(:finish_day_count, by = 1)
        if (!current_user.last_finish_date.nil?) &&
            (current_user.last_finish_date == 1.days.ago.to_date)
          current_user.increment(:combo_day_count, by = 1)
        else
          current_user.combo_day_count = 1
        end
        current_user.last_finish_date = Time.zone.now.to_date

        @finish_day_count = current_user.finish_day_count
        @day_count = participate_day_count(current_user)
        if @day_count >= 30
          @is_perfectly_finished = (current_user.combo_day_count >= 30)
          if @is_perfectly_finished
            @current_activity.increment(:finish_count, by = 1)
          end
          @current_participation = @current_activity.participation_records
              .find_by(user: current_user, is_finished: false)
          if @current_participation
            @current_participation.finish_day_count = current_user.finish_day_count
            @current_participation.is_finished = true
            @current_participation.finish_time = Time.zone.now
          end

          @current_activity.transaction do
            @current_participation && @current_participation.save
            @current_activity.daily_finish_records.create(:user => current_user)
            # TODO: Clear finish records, do not need any more
            @current_activity.finish_records.create(:user => current_user,
                :finish_day_count => current_user.finish_day_count)
            clear_participation(current_user)
            @current_activity.save
            current_user.save
          end
          if @is_perfectly_finished
            flash[:success] = "Great! You just finished a perfect Thirvolution with #%s!!!" \
                % [@current_activity.title]
          else
            flash[:success] = "Great! You finished #%s with %d/%d days! You can do better!!!" \
                % [@current_activity.title, @finish_day_count, @day_count]
          end
        else
          @current_activity.transaction do
            @current_activity.daily_finish_records.create(:user => current_user)
            @current_activity.save
            current_user.save
          end
          flash[:success] = "Cool! Let's continue tomorrow!!!"
        end
      rescue
        flash[:alert] = "Unknown error :-("
      end
    elsif @finished
      flash[:alert] =  "You have finished today's activity"
    else
      flash[:alert] =  "Please join an activity first"
    end
    redirect_back(fallback_location: root_path)
  end

  private
  def activity_params
    params.required(:activity).permit(:title)
  end
end
