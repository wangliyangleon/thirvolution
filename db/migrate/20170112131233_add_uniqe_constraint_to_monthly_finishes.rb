class AddUniqeConstraintToMonthlyFinishes < ActiveRecord::Migration[5.0]
  def change
    add_index :monthly_finishes, [:user_id, :activity_id, :finish_date], :unique => true, :name => 'monthly_finish_index'
  end
end
