class AddAttrToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :google_place_identifier, :string
    add_column :activities, :google_category, :string
  end
end
