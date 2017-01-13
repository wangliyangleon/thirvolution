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
        redirect_to(:back)
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
      @participation = ActivityParticipation.new(
        :activity => @activity, :user => current_user)
      @activity.increment(:participate_count, by = 1)
      begin
        @participation.save
        @activity.save
        flash[:success] = "Cool! Let's start Thirvolution TODAY!!!"
      rescue
        flash[:alert] = "Unknown error :-("
      end
    else
      flash[:alert] =  "You cannot participate multiple activities"
    end
    redirect_to(:back)
  end

  def finish
    @activity = Activity.find(params[:id])
    if get_current_participation
      @daily_finish = DailyFinish.new(
        :activity => @activity, :user => current_user, :finish_date => Time.zone.now.to_date)
      @activity.increment(:finish_day_count, by = 1)
      # TODO: Check monthly finish
      begin
        @daily_finish.save
        @activity.save
        flash[:success] = "Cool! Let's continue tomorrow!!!"
      rescue
        flash[:alert] = "Unknown error :-("
      end
    else
      flash[:alert] =  "Please join an activity first"
    end
    redirect_to(:back)
  end

  private
  def activity_params
    params.required(:activity).permit(:title)
  end

  private
  def get_current_participation
    current_user.activity_participations.where(["created_at >= ?", 30.days.ago]).first
  end
end
