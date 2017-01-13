class ActivitiesController < ApplicationController
  before_filter:authenticate_user!

  def new
  end

  def create
    if !get_current_participation
      @activity = current_user.activities.create(activity_params)
      @activity.participate_count = 1
      begin
        @activity.save
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
    @activity = Activity.find(params[:id])
    @current_participation = get_current_participation
  end

  def index
    @activities = Activity.all
  end

  def participate
    @activity = Activity.find(params[:id])
    if !get_current_participation
      @activity.activity_participations.create(:user => current_user)
      @activity.increment(:participate_count, by = 1)
      begin
        @activity.save
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
    # TODO: Think about a better association for finishes
    @activity = Activity.find(params[:id])
    @participation = get_current_participation
    if @participation
      begin
        @activity.daily_finishes.create(:user => current_user)
        @activity.increment(:finish_day_count, by = 1)
        @day_count = (Time.zone.now - @participation.created_at.beginning_of_day).to_i / 1.day + 1
        @is_last_day = (@day_count == 30)
        if @is_last_day
          @finish_day_count = @activity.daily_finishes(:user => current_user)
              .where(["finish_date > ?", 30.days.ago.to_date]).count
          @is_monthly_finished = (@finish_day_count == 30)
          if @is_monthly_finished
            @activity.monthly_finishes.create(:user => current_user)
            @activity.increment(:finish_count, by = 1)
          end
          #@activity.activity_participations.destroy(@participation.id)
          @activity.transaction do
            @participation.destroy
            @activity.save
          end
          if @is_monthly_finished
            flash[:success] = "Great! You just finished a Thirvolution with #%s!!!" % [@activity.title]
          else
            flash[:success] = "Great! You finished #%s with %d/30! You can do better!!!" % [@activity.title, @finish_day_count]
          end
        else
          @activity.save
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
  def get_current_participation
    current_user.activity_participations.where(["created_at >= ?", 29.days.ago.beginning_of_day]).first
  end
end
