class ParticipateRecord < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  before_save :default_values
  def default_values
    self.finish_day_count ||= 0
    self.combo_day_count ||= 0
  end
end
