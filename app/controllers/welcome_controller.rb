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

    # for thirv dashboard
    @today_date = Time.zone.now.to_date
    @new_activity_count = Activity.where("created_at >= ?", @today_date).count
    @new_participation_count = User.where("participate_date = ?", @today_date).count
    @thirv_finish_count = ParticipateRecord.where("created_at >= ?", @today_date).count
    @daily_finish_count = User.where("last_finish_date = ?", @today_date).count + @thirv_finish_count
    @perfect_finish_count = ParticipateRecord.where("created_at >= ? and finish_day_count = 30", @today_date).count

  end
end
