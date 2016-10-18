class SurvivorsController < ApplicationController

  def create
    survivor = Survivor.new(survivor_params)
    survivor.save
    render json: survivor
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :last_location_lat, :last_location_lon)
  end

end