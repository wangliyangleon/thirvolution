class WelcomeController < ApplicationController
  def index
    @day_count = 0
    if current_user
      @is_participated = !(current_user.activity_id.nil? || current_user.participate_date.nil?)
      if @is_participated
        @current_activity = Activity.find(current_user.activity_id)
        @is_finished_today = (!current_user.last_finish_date.nil?) &&
            (current_user.last_finish_date == Time.zone.now.to_date)
        @day_count = (Time.zone.now.to_date - current_user.participate_date).to_i + 1
      end
    end
  end
end
