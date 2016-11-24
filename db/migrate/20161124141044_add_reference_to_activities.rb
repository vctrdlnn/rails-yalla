class AddReferenceToActivities < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :category, foreign_key: true
  end
end
