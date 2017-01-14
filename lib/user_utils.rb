module UserUtils
  def not_participated(user)
    user.activity_id.nil? || user.participate_date.nil?
  end

  def is_participated(user)
    !not_participated(user)
  end

  def clear_participation(user)
    user.activity_id = nil
    user.participate_date = nil
    user.last_finish_date = nil
    user.finish_day_count = 0
    user.combo_day_count = 0
  end

  def participate_day_count(user)
    (Time.zone.now.to_date - user.participate_date).to_i + 1
  end

  def is_finished_today(user)
    (!user.last_finish_date.nil?) && (user.last_finish_date == Time.zone.now.to_date)
  end
end
