class ActivitiesController < ApplicationController
  before_filter:authenticate_user!

  def new
  end

  def create
    @activity = current_user.activities.create(activity_params)
    if @activity.save
      flash[:success] = "Activity created!"
      redirect_to @activity
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def index
    @activities = Activity.all
  end

  private
    def activity_params
      params.required(:activity).permit(:title)
    end
end
