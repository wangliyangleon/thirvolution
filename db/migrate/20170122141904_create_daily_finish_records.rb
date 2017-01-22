class CreateDailyFinishRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_finish_records do |t|
      t.belongs_to :user, index: true
      t.belongs_to :activity, index: true

      t.timestamps
    end
  end
end
