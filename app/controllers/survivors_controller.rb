class SurvivorsController < ApplicationController

  def create
    survivor = Survivor.new(survivor_params)
    if survivor.save
      render json: {success: true, id: survivor.id}
    else
      render json: {success: false, errors: survivor.errors}
    end
  end

  def update_last_location
    survivor = Survivor.find(params[:id])

    survivor.reset_location

    if survivor.update(update_last_location_params)
      render json: {success: true}
    else
      render json: {success: false, errors: survivor.errors}
    end
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :last_location_lat, :last_location_lon)
  end

  def update_last_location_params
    params.require(:survivor).permit(:last_location_lat, :last_location_lon)
  end

end