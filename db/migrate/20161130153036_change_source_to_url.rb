class ChangeSourceToUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :activities, :source, :url
  end
end
