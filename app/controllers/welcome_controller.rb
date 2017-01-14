class WelcomeController < ApplicationController
  def index
    @day_count = 0
    if current_user
      @is_participated = is_participated(current_user)
      if @is_participated
        @current_activity = Activity.find(current_user.activity_id)
        @is_finished_today = is_finished_today(current_user)
        @day_count = participate_day_count(current_user)
      end
    end
  end
end
