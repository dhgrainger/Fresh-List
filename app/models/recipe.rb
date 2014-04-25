class Recipe < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensistive: false}
  validates :image, presence: true
  validates :carbs, presence: true
  validates :protein, presence: true
  validates :fats, presence: true
  validates :url, presence: true
  # validates recpie,          uniqueness: {
  #                               scope: :user_id,
  #                               message: "That recpie already exists" }
  has_many :user_recipes
  has_many :users, through: :user_recipes, source: :user
  class << self
    def search(search)

      results = all.where('to_tsvector(name) @@ plainto_tsquery(?)', search)

      # if the database doesnt include the search term we are going to query the yummly api
      if results.map {|x| x[:name].downcase.include? search}.include? true
        return results
      else

      # we need to make sure the data is in the right format for the search
        if search.include? ' '
          params = search.split(' ').join('+')
        else
          params = search
        end

      # this next block is going to search recipes and return 10 recipes that match our search
        source = 'http://api.yummly.com/v1/api/recipes?_app_id=d788fb36&_app_key=dee9780de91a8cab61adc0df5a70a3d8&q=' + params + '&requirePictures=true'
        resp = Net::HTTP.get_response(URI.parse(source))
        data = resp.body
        yummly = JSON.parse(data)

      # this next block then queries the yummly api again to get more data including nutritional info from the api for each recipe
        yummly["matches"].each do |yum|

          yumId = yum["id"]
          source = 'http://api.yummly.com/v1/api/recipe/' + yumId + '?_app_id=d788fb36&_app_key=dee9780de91a8cab61adc0df5a70a3d8&'
          resp = Net::HTTP.get_response(URI.parse(source))
          data = resp.body
          info = JSON.parse(data)

          recipe = Recipe.new

          recipe.name = info["attribution"]["text"]
          recipe.image = yum["smallImageUrls"][0]
          recipe.url = 'http://www.yummly.com/recipe/' + yum["id"]

      # this next block returns carbs protein and fats in grams
          info["nutritionEstimates"].each do |attribute|
            if attribute["description"] == 'Carbohydrate, by difference'
              recipe.carbs = attribute["value"]
            end
            if attribute["description"] == 'Protein'
              recipe.protein = attribute["value"]
            end
            if attribute["description"] == 'Total lipid (fat)'
              recipe.fats = attribute["value"]
            end
          end
          recipe.save
        end
         results = all.where('to_tsvector(name) @@ plainto_tsquery(?)', search)
        results
      end
    end
  end
end
