class Activity < ApplicationRecord
  has_many :activity_participations
  has_many :users, through: :activity_participations
  before_save :default_values
  def default_values
    self.participate_count ||= 0
    self.finish_count ||= 0
    self.finish_day_count ||= 0
  end
end
