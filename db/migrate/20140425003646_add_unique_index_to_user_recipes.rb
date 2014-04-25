class AddUniqueIndexToUserRecipes < ActiveRecord::Migration
  def up
    add_index :user_recipes, [:user_id, :recipe_id], unique: true
  end

  def down
    remove_index :user_recipes, [:user_id, :recipe_id]
  end
end
