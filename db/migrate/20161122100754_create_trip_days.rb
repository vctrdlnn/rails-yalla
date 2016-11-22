class CreateTripDays < ActiveRecord::Migration[5.0]
  def change
    create_table :trip_days do |t|
      t.string :title
      t.date :date
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
