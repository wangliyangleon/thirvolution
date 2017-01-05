class ActivitiesController < ApplicationController
  def new
  end

  def create
    @activity = Activity.new(activity_params)

    @activity.save
    redirect_to @activity
  end

  def show
    @activity = Activity.find(params[:id])
  end

  private
    def activity_params
      params.required(:activity).permit(:title)
    end
end
