class CreateMonthlyFinishes < ActiveRecord::Migration[5.0]
  def change
    create_table :monthly_finishes do |t|
      t.belongs_to :user
      t.belongs_to :activity

      t.timestamps
    end
  end
end
