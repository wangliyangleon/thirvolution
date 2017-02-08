class Activity < ApplicationRecord
  has_many :daily_finish_records
  has_many :users, through: :daily_finish_records
  has_many :participation_records
  has_many :users, through: :participation_records
  has_many :activity_comments
  has_many :users, through: :activity_comments

  before_save :default_values
  def default_values
    self.participate_count ||= 0
    self.finish_count ||= 0
    self.finish_day_count ||= 0
  end

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      all
    end
  end

  validates :title,
    :length => {
      :maximum => 128
    }

end
