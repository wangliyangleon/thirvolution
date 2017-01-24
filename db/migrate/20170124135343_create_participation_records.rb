class CreateParticipationRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :participation_records do |t|
      t.belongs_to :user, index: true
      t.belongs_to :activity, index: true
      t.integer :finish_day_count, null: false, default: 0
      t.boolean :is_finished, index:true, null: false, default: false
      t.datetime :finish_time, default: nil

      t.timestamps
    end
  end
end
