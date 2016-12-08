class AddParentToActivities < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :parent, index: true
  end
end
