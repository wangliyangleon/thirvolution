class WelcomeController < ApplicationController
  def index
    if current_user
      @current_participation = get_current_participation
      @finished_today = is_finished_today
      if @current_participation
        @current_activity = @current_participation.activity
        @day_count = (Time.zone.now - @current_participation.created_at.beginning_of_day).to_i / 1.day + 1
      else
        @day_count = 0
      end
    end
  end

  private
  def get_current_participation
    current_user.activity_participations.where(["created_at >= ?", 29.days.ago.beginning_of_day]).first
  end

  def is_finished_today
    current_user.daily_finishes.where(["created_at >= ?", Time.zone.now.beginning_of_day]).first
  end
end
