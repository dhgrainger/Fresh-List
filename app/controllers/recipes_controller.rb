class RecipesController < ApplicationController

  def index
    @recipes = []
    searches = current_user.preferences.map{|x| x[:name]}.uniq
    searches.each do |search|
      @recipes << Recipe.search(search)
    end
    @recipes
  end
end
