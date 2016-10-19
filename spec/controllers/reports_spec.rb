require 'rails_helper'

describe ReportsController do

  describe '#infected_percentage' do

    it 'must return the correct percentage of infected survivors' do
      6.times { create :survivor }
      2.times { create :survivor, :infected }

      get :infected_percentage

      response_hash = JSON.parse(response.body)
      expect(response_hash['value']).to eq(25)
    end
  end

  describe '#non_infected_percentage' do

    it 'must return the correct percentage of non-infected' do
      5.times { create :survivor }
      3.times { create :survivor, :infected }

      get :non_infected_percentage

      response_hash = JSON.parse(response.body)
      expect(response_hash['value']).to eq(62.5)
    end
  end

  describe '#items_quantity_average' do

    it 'must return the correct average of items quantity by survivor' do
      create :survivor, items_attributes: [{kind: :water, quantity: 30}, {kind: :food, quantity: 55}]
      create :survivor, items_attributes: [{kind: :water, quantity: 10}, {kind: :food, quantity: 20}]
      create :survivor, items_attributes: [{kind: :medication, quantity: 3}, {kind: :food, quantity: 5}]
      create :survivor, :infected, items_attributes: [{kind: :water, quantity: 555}, {kind: :food, quantity: 633}]

      get :items_quantity_average

      response_hash = JSON.parse(response.body)
      expect(response_hash['water']).to eq(40 / 3.0)
      expect(response_hash['food']).to eq(80 / 3.0)
      expect(response_hash['medication']).to eq(1)
      expect(response_hash['ammunition']).to eq(0)

    end
  end

  describe '#lost_points' do

    it 'must return the correct sum of points lost because of infected survivors', :focus do
      create :survivor, :infected, items_attributes: [{kind: :water, quantity: 30}, {kind: :food, quantity: 55}]
      create :survivor, items_attributes: [{kind: :water, quantity: 10}, {kind: :food, quantity: 20}]
      create :survivor, :infected, items_attributes: [{kind: :medication, quantity: 3}, {kind: :food, quantity: 5}]
      create :survivor, :infected, items_attributes: [{kind: :water, quantity: 555}, {kind: :food, quantity: 633}]

      get :lost_points

      total_points = (585 * 4) + (693 * 3) + (3 * 2)
      response_hash = JSON.parse(response.body)
      expect(response_hash['value']).to eq(total_points)
    end
  end
end