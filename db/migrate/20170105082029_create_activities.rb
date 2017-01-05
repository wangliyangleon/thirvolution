class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :title, :null => false
      t.integer :participate_count, :null => false, :default => 0
      t.integer :finish_count, :null => false, :default => 0
      t.integer :finish_day_count, :null => false, :default => 0

      t.timestamps
    end
  end
end
