class CreateFinishRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :finish_records do |t|
      t.belongs_to :user, index: true
      t.belongs_to :activity, index: true
      t.integer :finish_day_count, null: false

      t.timestamps
    end
  end
end
