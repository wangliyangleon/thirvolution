class ActivitiesController < ApplicationController
  before_filter:authenticate_user!

  def new
  end

  def create
    if !get_current_participation
      @activity = current_user.activities.create(activity_params)
      @activity.save
      redirect_to @activity
    else
      flash[:alert] =  "You cannot participate multiple activities"
      redirect_to activities_url
    end
  end

  def show
    @activity = Activity.find(params[:id])
    @participation_count = @activity.activity_participations.count
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
      @participation.save
    else
      flash[:alert] =  "You cannot participate multiple activities"
    end
    redirect_to @activity
  end

  private
    def activity_params
      params.required(:activity).permit(:title)
    end

    def get_current_participation
      current_user.activity_participations.where(["created_at >= ?", 30.days.ago]).first
    end
end
