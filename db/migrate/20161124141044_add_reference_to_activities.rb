class AddReferenceToActivities < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :main_category, foreign_key: true
  end
end
