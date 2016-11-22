class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.string :title
      t.string :description
      t.string :category
      t.string :city
      t.string :country
      t.float :lat
      t.float :lon
      t.string :photo
      t.boolean :public
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
