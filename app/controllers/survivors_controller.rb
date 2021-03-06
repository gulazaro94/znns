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

  def notify_infection
    survivor = Survivor.find(params[:id])
    infected = Survivor.find(params[:infected_id])

    result = NotifyInfection.call(survivor: survivor, infected: infected)

    if result.success?
      render json: {success: true}
    else
      render json: {success: false, errors: result.error}
    end
  end

  def trade_items
    result = TradeItems.call(trade_items_params)

    if result.success?
      render json: {success: true}
    else
      render json: {success: false, error: result.error}
    end
  end

  private

  def survivor_params
    survivor_attributes = params.require(:survivor).permit(:name, :age, :gender, :last_location_lat, :last_location_lon, items: Item.kinds.keys)
    format_items_attributes(survivor_attributes)
  end

  def format_items_attributes(survivor_attributes)
    items = survivor_attributes.delete(:items)
    return survivor_attributes unless items
    items_attributes = []
    items.each do |kind, quantity|
      items_attributes << {kind: kind, quantity: quantity}
    end

    survivor_attributes.merge(items_attributes: items_attributes)
  end

  def update_last_location_params
    params.require(:survivor).permit(:last_location_lat, :last_location_lon)
  end

  def trade_items_params
    params.permit(survivors: [:id, items: Item.kinds.keys])
  end

end