class Activity < ApplicationRecord
  has_many :participate_records
  has_many :users, through: :participate_records

  before_save :default_values
  def default_values
    self.participate_count ||= 0
    self.finish_count ||= 0
    self.finish_day_count ||= 0
  end
end
