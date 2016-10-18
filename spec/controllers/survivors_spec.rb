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

      post :create, params: {survivor: survivor_attributes}, format: :json

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

  describe '#update_last_location' do

    it 'must update last locations when passing correct parameters' do
      survivor = create :survivor

      patch :update_last_location, params: {id: survivor.id, survivor: {last_location_lat: 13.13, last_location_lon: 45.45}}, format: :json

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(true)
      expect(survivor.reload.last_location_lat).to eq(13.13)
      expect(survivor.last_location_lon).to eq(45.45)
    end

    it 'must fail if some parameter is invalid' do
      survivor = create :survivor

      patch :update_last_location, params: {id: survivor.id, survivor: {last_location_lat: -1000.123, last_location_lon: nil}}, format: :json

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(false)
      expect(survivor.last_location_lat).to eq(survivor.reload.last_location_lat)
    end
  end
end