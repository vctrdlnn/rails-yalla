class AddParamsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :mobile, :string
    add_column :users, :photo, :string
    add_column :users, :hometown, :string
  end
end
