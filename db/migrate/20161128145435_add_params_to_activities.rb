class AddParamsToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :source, :string
    add_column :activities, :photo, :string
  end
end
