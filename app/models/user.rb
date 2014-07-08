class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: {case_sensistive: false}
  validates :gender, presence: true
  validates :weight, presence: true
  validates :height, presence: true
  validates :activity, presence: true
  validates :goal, presence: true
  validates :age, presence: true

  has_many :preferences
  has_many :user_recipes
  has_many :recipes, through: :user_recipes, source: :recipe

  def bmr
    if gender == "male"
      modifier = 5
    else
      modifier = -161
    end
    bmr = (9.99 * (weight * 0.45)) + (6.25 * (height/0.39)) - (4.92 * age) + modifier
  end

  def activity_multiplier
    case activity
      when "Sedentary"
        cals = (self.bmr * 1.2)
      when "Low Activity"
        cals = (self.bmr * 1.4)
      when "Active"
        cals = (self.bmr * 1.6)
      when "Very Active"
        cals = (self.bmr * 1.8)
    end
    cals
  end

  def goal_multiplier
    case goal
      when "Lose Weight"
        cals = (self.activity_multiplier * 0.85)
      when "Maintain"
        cals = (self.activity_multiplier)
      when "Gain Muscle"
        cals = (self.activity_multiplier * 1.15)
    end
  end

  def carbcals
    cals = (self.goal_multiplier * 0.5).round(0)
  end

  def carbgrams
    grams = (self.carbcals / 4.0).round(0)
  end

  def proteincals
    cals = (self.goal_multiplier * 0.3).round(0)
  end

  def proteingrams
    grams = (self.proteincals / 4.0).round(0)
  end

  def fatcals
    cals = (self.goal_multiplier * 0.2).round(0)
  end

  def fatgrams
    grams = (self.fatcals / 9.0).round(0)
  end

  def find
    ids = self.recipes.pluck(:id)
    array = []
    ids.each do |x|
      array << Recipe.where('id = x')
    end
    array
  end

  def weekly_requirements
    fats = (self.fatgrams * 7)
    protein = (self.proteingrams * 7)
    carbs = (self.carbgrams * 7)
    {fats: fats, protein: protein, carbs: carbs}
  end

  def recipes_total
    your_recipes = self.recipes
    if your_recipes.empty?
      total_fats_grams = 0
      total_protein_grams = 0
      total_carbs_grams = 0
    else
      total_fats_grams = your_recipes.pluck(:fats).inject(:+)
      total_protein_grams = your_recipes.pluck(:protein).inject(:+)
      total_carbs_grams = your_recipes.pluck(:carbs).inject(:+)
    end
    {fats: total_fats_grams, protein: total_protein_grams, carbs: total_carbs_grams}
  end

  def difference
    fats_diff = self.weekly_requirements[:fats] - recipes_total[:fats]
    protein_diff = self.weekly_requirements[:protein] - recipes_total[:protein]
    carbs_diff = self.weekly_requirements[:carbs] - recipes_total[:carbs]
    {fats: fats_diff, protein: protein_diff, carbs: carbs_diff}
  end

  def weekly_recipes(previous_count = nil)
    if !(recipes.count == previous_count)
      previous_count = recipes.count
      if self.difference[:carbs] > 0
        new_recipe = Recipe.where('carbs > protein AND protein > fats').shuffle[0]
        self.recipes << new_recipe if !self.recipes.include?(new_recipe)
        weekly_recipes(previous_count)
      end

      if self.difference[:protein] > 0
        new_recipe = Recipe.where('protein > fats AND protein > carbs').shuffle[0]
        self.recipes << new_recipe if !self.recipes.include?(new_recipe)
        weekly_recipes(previous_count)
      end

      if self.difference[:fats] > 0
        new_recipe = Recipe.where('fats > protein AND fats > carbs').shuffle[0]
        self.recipes << new_recipe if !self.recipes.include?(new_recipe)
        weekly_recipes(previous_count)
      end
    end
    difference
  end
    #if none of the values have been met
  #   if fats_diff > 0 && protein_diff > 0 && carbs_diff > 0

  #     # Need fat the most followed by protein then carbs
  #     if fats_diff > protein_diff && protein_diff > carbs_diff

  #       self.recipes << Recipe.where('fats > protein AND protein > carbs').limit
  #       (2)
  #       weekly_recipes
  #     end

  #     #Need fat the most followed by carbs then protein
  #     if fats_diff > carbs_diff && carbs_diff > protein_diff

  #       self.recipes << Recipe.where('fats > carbs AND carbs > protein').limit(2)
  #       weekly_recipes
  #     end

  #     #Need protein the most followed by carbs then fats
  #     if protein_diff > carbs_diff && carbs_diff > fats_diff

  #       self.recipes << Recipe.where('protein > carbs AND carbs > fats').limit(2)
  #       weekly_recipes
  #     end

  #     #Need protein the most followed by fats then carbs
  #     if protein_diff > fats_diff && fats_diff > carbs_diff

  #       self.recipes << Recipe.where('protein > fats AND fats > carbs').limit(2)
  #       weekly_recipes
  #     end

  #     #Need carbs the most followed by fats then protein
  #     if carbs_diff > fats_diff && fats_diff > protein_diff

  #       self.recipes << Recipe.where('carbs > fats AND fats > protein').limit(2)
  #       weekly_recipes
  #     end

  #     #Need carbs the most followed by protein then carbs
  #     if carbs_diff > protein_diff && protein_diff > fats_diff

  #       self.recipes << Recipe.where('carbs > protein AND protein > fats').limit(2)
  #       weekly_recipes
  #     end
  #   end

  #   # if only the protein value has been met
  #   if fats_diff > 0 && carbs_diff > 0 && protein_diff <= 0
  #     if carbs_diff > fats_diff
  #       self.recipes << Recipe.where('fats > carbs AND protein < 1').limit(2)
  #       weekly_recipes
  #     end

  #     if carbs_diff > fats_diff
  #       self.recipes << Recipe.where('carbs > fats AND protein < 1').limit(2)
  #       weekly_recipes
  #     end
  #   end
  #   #if only the carbs value has been met
  #   if fats_diff > 0 && protein_diff > 0 && carbs_diff <= 0
  #     if fats_diff > protein_diff
  #       self.recipes << Recipe.where('fats > protein AND carbs < 1').limit(2)
  #       weekly_recipes
  #     end

  #     if protein_diff > fats_diff
  #       self.recipes << Recipe.where('protein > fats AND carbs < 1').limit(2)
  #       weekly_recipes
  #     end
  #   end

  #   # if only the fats value has been met
  #   if protein_diff > 0 && carbs_diff > 0 && fats_diff <= 0
  #     if protein_diff > carbs_diff
  #       self.recipes << Recipe.where('protein > carbs AND fats < 1').limit(2)

  #       weekly_recipes
  #     end

  #     if carbs_diff > protein_diff
  #       self.recipes << Recipe.where('carbs > protein AND fats < 1').limit(2)
  #       weekly_recipes
  #     end
  #   end

  #   # if the carbs and protein values have been met
  #   if fats_diff > 0 && carbs_diff <= 0 && protein_diff <= 0
  #     self.recipes << Recipe.where('fats > 30 AND protein < 1 AND fats < 1').limit(2)
  #     weekly_recipes
  #   end

  #   # if the carbs and fats values have been met
  #   if protein_diff > 0 && carbs_diff <= 0 && fats_diff <= 0
  #     self.recipes << Recipe.where('protein > 30 AND carbs < 1 AND fats < 1').limit(2)
  #     weekly_recipes
  #   end

  #   #if the fats and proteins values have been met
  #   if carbs_diff > 0 && fats_diff <= 0 && protein_diff <= 0
  #     self.recipes << Recipe.where('carbs > 30 AND protein < 1 AND fats < 1').limit(2)
  #     weekly_recipes
  #   end
  #  {carbs_diff: carbs_diff, protein_diff: protein_diff, fats_diff: fats_diff}
  # end
end


