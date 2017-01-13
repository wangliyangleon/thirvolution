class DailyFinish < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  before_save :default_values
  def default_values
    self.finish_date ||= Time.zone.now.to_date
  end
end
