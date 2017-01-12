class Activity < ApplicationRecord
  has_many :activity_participations
  has_many :users, through: :activity_participations
  has_many :daily_finishes
  has_many :users, through: :daily_finishes
  has_many :monthly_finishes
  has_many :users, through: :monthly_finishes
  before_save :default_values
  def default_values
    self.participate_count ||= 0
    self.finish_count ||= 0
    self.finish_day_count ||= 0
  end
end
