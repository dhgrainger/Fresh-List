class PreferencesController < ApplicationController
  def new
    @preference = Preference.new
  end

  def create
    inputs = params["preference"]["name"].split(',')
    inputs.each do |input|
      @preference = Preference.new(name: input, user_id: params["user_id"])
      if @preference.save
        flash[:notice] = "Thank you for your input"
      else
        redirect_to :back, notice: "Preference not saved"
      end
    end
    redirect_to recipes_path
  end

end
