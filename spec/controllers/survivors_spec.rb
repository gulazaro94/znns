require 'rails_helper'

describe SurvivorsController, type: :controller do

  describe '#create' do

    it 'must save survivor with correct parameters' do
      survivor_attributes = {
        name: 'Gustavo',
        age: 35,
        gender: 'male',
        last_location_lat: -22.224859,
        last_location_lon: -49.962380
      }

      post :create, params: {survivor: survivor_attributes}
      survivor = Survivor.last
      expect(survivor).to be_present
      survivor_attributes.each do |attribute, value|
        expect(survivor.send(attribute)).to eq(value)
      end
      expect(JSON.parse(response.body)['success']).to eq(true)
    end

    it 'must fail and respond with error' do
      survivor_attributes = {
        name: 'Gustavo',
        last_location_lon: -49.962380
      }

      post :create, params: {survivor: survivor_attributes}

      expect(Survivor.count).to eq(0)
      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(false)
    end
  end
end