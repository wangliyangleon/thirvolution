class CreateActivityComments < ActiveRecord::Migration[5.0]
  def change
    create_table :activity_comments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :activity, index: true
      t.string :content, null: false
      t.integer :reply_to
      t.timestamps

      t.timestamps
    end
  end
end
