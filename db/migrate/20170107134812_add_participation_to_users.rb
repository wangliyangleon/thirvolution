class AddParticipationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :activity, index: true, foreign_key: true
    add_column :users, :finish_day_count, :integer, null: false, default: 0
    add_column :users, :combo_day_count, :integer, null: false, default: 0
    add_column :users, :participate_date, :date
    add_column :users, :last_finish_date, :date
  end
end
