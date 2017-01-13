class ActivitiesController < ApplicationController
  before_filter:authenticate_user!

  def new
  end

  def create
    if not_participated
      @activity = Activity.new(activity_params)
      @activity.participate_count = 1
      current_user.participate_date = Time.zone.now.to_date
      begin
        @activity.transaction do
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
    @not_participated = not_participated
    @activity = Activity.find(params[:id])
  end

  def index
    @activities = Activity.all
  end

  def participate
    @current_activity = Activity.find(params[:id])
    if not_participated
      current_user.activity_id = @current_activity.id
      current_user.participate_date = Time.zone.now.to_date
      @current_activity.increment(:participate_count, by = 1)
      begin
        @current_activity.transaction do
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
    if is_participated
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
        @day_count = (Time.zone.now.to_date - current_user.participate_date).to_i + 1
        if @day_count >= 30
          @is_monthly_finished = (current_user.combo_day_count >= 30)
          if @is_monthly_finished
            @current_activity.increment(:finish_count, by = 1)
          end
          @current_activity.transaction do
            @current_activity.participate_records.create(:user => current_user,
                :finish_day_count => current_user.finish_day_count)
            current_user.activity_id = nil
            current_user.participate_date = nil
            current_user.last_finish_date = nil
            current_user.finish_day_count = 0
            current_user.combo_day_count = 0
            @current_activity.save
            current_user.save
          end
          if @is_monthly_finished
            flash[:success] = "Great! You just finished a Thirvolution with #%s!!!" \
                % [@current_activity.title]
          else
            flash[:success] = "Great! You finished #%s with %d/%d! You can do better!!!" \
                % [@current_activity.title, @finish_day_count, @day_count]
          end
        else
          @current_activity.transaction do
            @current_activity.save
            current_user.save
          end
          flash[:success] = "Cool! Let's continue tomorrow!!!"
        end
      rescue
        flash[:alert] = "Unknown error :-("
      end
    else
      flash[:alert] =  "Please join an activity first"
    end
    redirect_back(fallback_location: root_path)
  end

  private
  def activity_params
    params.required(:activity).permit(:title)
  end

  private
  def not_participated
    current_user.activity_id.nil? || current_user.participate_date.nil?
  end

  private
  def is_participated
    !not_participated
  end
end
