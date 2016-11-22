class ChangeDefaultForPublicInTrips < ActiveRecord::Migration[5.0]
  def change
    change_column :trips, :public, :boolean, :default => true
  end
end
