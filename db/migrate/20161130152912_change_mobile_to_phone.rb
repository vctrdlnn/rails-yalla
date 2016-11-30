class ChangeMobileToPhone < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :mobile, :phone
  end
end
