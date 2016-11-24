class CreateMainCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :main_categories do |t|
      t.string :title
      t.string :icon
      t.string :color

      t.timestamps
    end
  end
end
