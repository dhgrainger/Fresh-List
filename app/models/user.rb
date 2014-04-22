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
end


