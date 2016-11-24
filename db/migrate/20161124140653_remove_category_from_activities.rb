class RemoveCategoryFromActivities < ActiveRecord::Migration[5.0]
  def change
    remove_column :activities, :category
  end
end
