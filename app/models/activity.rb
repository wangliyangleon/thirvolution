class Activity < ApplicationRecord
  has_many :finish_records
  has_many :users, through: :finish_records
  has_many :daily_finish_records
  has_many :users, through: :daily_finish_records
  has_many :participation_records
  has_many :users, through: :participation_records

  before_save :default_values
  def default_values
    self.participate_count ||= 0
    self.finish_count ||= 0
    self.finish_day_count ||= 0
  end
end
