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

  def get_history_activities(user)
    history_activities = Array.new
    # 1, get activity participations
    participations = user.participation_records
    for participate in participations
      activity = participate.activity
      history_activities.push(HistoryActivity.new(
          "Participated #" + activity.title,
          participate.created_at,
          activity))
    end
    # 2, get acitivty daily finishes
    daily_finishes = user.daily_finish_records
    for daily_finish in daily_finishes
      activity = daily_finish.activity
      history_activities.push(HistoryActivity.new(
          "Finished #" + activity.title + " on " + daily_finish.created_at.strftime("%-d %b"),
          daily_finish.created_at,
          activity))
    end

    # 3, get Thirvolution finishes
    thirv_finishes = user.participation_records.where(is_finished: true)
    for thirv_finish in thirv_finishes
      activity = thirv_finish.activity
      history_activities.push(HistoryActivity.new(
          "Thirvolution finished! #" + activity.title,
          thirv_finish.finish_time,
          activity))
    end

    history_activities.sort {|a,b| b.time <=> a.time}
  end
end
