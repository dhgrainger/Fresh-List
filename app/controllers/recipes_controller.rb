class RecipesController < ApplicationController

  def index
    @user = current_user
    @recipes = []
    searches = current_user.preferences.map{|x| x[:name]}.uniq
    searches.each do |search|
      @recipes << Recipe.search(search)
    end
    @recipes
  end

  def show
    @recipe = Recipe.find(params["id"])
  end

  def edit
    binding.pry
    @recipe = Recipe.find(params["id"])
  end

  def update_multiple
    params["ids"].each do |id|
      recipe = Recipe.find(id)
      current_user.recipes << recipe
    end
    redirect_to user_path(current_user), notice: "Recipes Saved"
  end



  def private
    params.require(:recipes).permit(:user)
  end
end

