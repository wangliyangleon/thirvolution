class AddUniqeConstraintToActivityParticipation < ActiveRecord::Migration[5.0]
  def change
    add_index :activity_participations, [:user_id, :activity_id], :unique => true
  end
end
