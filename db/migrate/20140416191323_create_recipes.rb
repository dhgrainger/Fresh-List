class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.string :image, null: false
      t.float :carbs, null: false
      t.float :fats, null: false
      t.float :protein, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
