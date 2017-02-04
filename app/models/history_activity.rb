class HistoryActivity
  def initialize (message, time, item = nil)
    @message = message
    @time = time
    @item = item
  end

  def message
    @message
  end

  def time
    @time
  end

  def item
    @item
  end
end
