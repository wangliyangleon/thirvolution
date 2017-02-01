module PagesHelper
  def activity_time_format(date_time)
    if date_time > Time.zone.now.beginning_of_day()
      date_time.strftime("%H:%M")
    else
      date_time.strftime("%-m-%-d")
    end
  end
end
