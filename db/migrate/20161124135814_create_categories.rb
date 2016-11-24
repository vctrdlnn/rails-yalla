class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.string :google_title
      t.references :main_category, foreign_key: true

      t.timestamps
    end
  end
end
