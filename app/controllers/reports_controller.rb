class ReportsController < ApplicationController

  def infected_percentage
    percentage = SurvivorsPercentageReport.new(infected: true).calculate_infected_percentage
    render json: {value: percentage}
  end

  def non_infected_percentage
    percentage = SurvivorsPercentageReport.new(infected: false).calculate_infected_percentage
    render json: {value: percentage}
  end

  def items_quantity_average
    items_average = ItemsAverageBySurvivorReport.new.calculate_items_average
    render json: items_average
  end

  def lost_points
    value = LostPointsReport.new.calculate_lost_points
    render json: {value: value}
  end

end