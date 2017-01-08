class ActivitiesController < ApplicationController
  before_filter:authenticate_user!

  def new
  end

  def create
    @activity = current_user.activities.create(activity_params)
    @activity.save
    redirect_to @activity
  end

  def show
    @activity = Activity.find(params[:id])
    @participation_count = @activity.activity_participations.count
    @participation = current_user.activity_participations.where(:activity => @activity).first
  end

  def index
    @activities = Activity.all
  end

  def participate
    @activity = Activity.find(params[:id])
    @participation = ActivityParticipation.new(
      :activity => @activity, :user => current_user)
    @participation.save
    redirect_to @activity
  end

  private
    def activity_params
      params.required(:activity).permit(:title)
    end
end
