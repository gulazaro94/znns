class SurvivorsController < ApplicationController

  def create
    survivor = Survivor.new(survivor_params)
    if survivor.save
      render json: {success: true, id: survivor.id}
    else
      render json: {success: false, errors: survivor.errors}
    end
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :last_location_lat, :last_location_lon)
  end

end