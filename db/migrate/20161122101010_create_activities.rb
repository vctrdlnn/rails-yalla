class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :title
      t.string :description
      t.string :category
      t.string :establishment
      t.string :city
      t.string :address
      t.float :lon
      t.float :lat
      t.integer :index
      t.references :trip, foreign_key: true
      t.references :trip_day, foreign_key: true

      t.timestamps
    end
  end
end
