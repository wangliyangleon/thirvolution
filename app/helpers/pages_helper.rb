module PagesHelper
  def activity_time_format(date_time)
    if date_time > Time.zone.now.beginning_of_day()
      date_time.strftime("%H:%M")
    else
      date_time.strftime("%-m-%-d")
    end
  end

  def history_time_format(date_time)
    if date_time > Time.zone.now.beginning_of_day()
      date_time.strftime("today at %H:%M")
    elsif date_time > Time.zone.now.advance(days: -1).beginning_of_day()
      date_time.strftime("yesterday at %H:%M")
    elsif date_time > Date.new(Time.zone.now.year, 1, 1)
      date_time.strftime("%-d %b at %H:%M")
    else
      date_time.strftime("%-d %b %Y at %H:%M")
    end
  end

  def comment_time_format(date_time)
    history_time_format(date_time)
  end
end
