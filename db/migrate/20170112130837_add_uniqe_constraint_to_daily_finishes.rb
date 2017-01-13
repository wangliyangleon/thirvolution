class AddUniqeConstraintToDailyFinishes < ActiveRecord::Migration[5.0]
  def change
    add_index :daily_finishes, [:user_id, :activity_id, :finish_date], :unique => true, :name => 'daily_finish_index'
  end
end
