require 'rails_helper'

describe SurvivorsController, type: :controller do

  describe '#create' do

    it 'must save survivor with correct parameters' do
      post :create, params: {survivor: attributes_for(:survivor)}

      survivor = Survivor.last
      expect(survivor).to be_present
      attributes_for(:survivor).each do |attribute, value|
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

    it 'must add the survivor items' do
      survivor_attributes = attributes_for(:survivor)
      survivor_attributes[:items] = {
        water: 10,
        food: 130,
        medication: 2,
        ammunition: 0
      }

      post :create, params: {survivor: survivor_attributes}

      survivor = Survivor.last
      expect(survivor.items.count).to eq(4)
      expect(survivor.quantity_of_water).to eq(10)
      expect(survivor.quantity_of_food).to eq(130)
      expect(survivor.quantity_of_medication).to eq(2)
      expect(survivor.quantity_of_ammunition).to eq(0)
    end

  end

  describe '#update_last_location' do

    it 'must update last locations when passing correct parameters' do
      survivor = create :survivor

      patch :update_last_location, params: {id: survivor.id, survivor: {last_location_lat: 13.13, last_location_lon: 45.45}}

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(true)
      expect(survivor.reload.last_location_lat).to eq(13.13)
      expect(survivor.last_location_lon).to eq(45.45)
    end

    it 'must fail if some parameter is invalid' do
      survivor = create :survivor

      patch :update_last_location, params: {id: survivor.id, survivor: {last_location_lat: -1000.123, last_location_lon: nil}}

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(false)
      expect(survivor.last_location_lat).to eq(survivor.reload.last_location_lat)
    end
  end

  describe '#notify_infection' do

    it 'must add to infection_notifications' do
      survivor = create :survivor
      infected = create :survivor

      post :notify_infection, params: {id: survivor.id, infected_id: infected.id}

      expect(survivor.done_infection_notifications.count).to eq(1)
      expect(infected.received_infection_notifications.count).to eq(1)
      expect(infected.reload.infected?).to be_falsey
    end

    it 'must flag as infected after three notifications' do
      infected = create :survivor

      3.times do
        survivor = create :survivor
        post :notify_infection, params: {id: survivor.id, infected_id: infected.id}

        response_hash = JSON.parse(response.body)
        expect(response_hash['success']).to eq(true)
      end

      expect(infected.reload.infected?).to be_truthy
    end

    it 'must fail if same survivor try to notify infected more than once' do
      infected = create :survivor
      survivor = create :survivor

      2.times { post :notify_infection, params: {id: survivor.id, infected_id: infected.id} }

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(false)
    end
  end

  describe '#trade_items' do

    it 'must trade when matching the sum of points' do
      survivor_one = create :survivor, items_attributes: [{kind: :water, quantity: 3}, {kind: :food, quantity: 11}]
      survivor_two = create :survivor, items_attributes: [{kind: :water, quantity: 7}, {kind: :food, quantity: 4}, {kind: :ammunition, quantity: 2}]

      post :trade_items, params: {survivors: [
        {id: survivor_one.id, items: {food: 3}},
        {id: survivor_two.id, items: {water: 2, ammunition: 1}}
      ]}

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(true)

      expect(survivor_one.quantity_of_water).to eq(5)
      expect(survivor_one.quantity_of_food).to eq(8)
      expect(survivor_one.quantity_of_ammunition).to eq(1)

      expect(survivor_two.quantity_of_water).to eq(5)
      expect(survivor_two.quantity_of_food).to eq(7)
      expect(survivor_two.quantity_of_ammunition).to eq(1)
    end

    it 'must fail when the survivor does not have enough items' do
      survivor_one = create :survivor, items_attributes: [{kind: :water, quantity: 3}, {kind: :food, quantity: 2}]
      survivor_two = create :survivor, items_attributes: [{kind: :water, quantity: 7}, {kind: :food, quantity: 4}, {kind: :ammunition, quantity: 2}]

      post :trade_items, params: {survivors: [
        {id: survivor_one.id, items: {food: 3}},
        {id: survivor_two.id, items: {water: 2, ammunition: 1}}
      ]}

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(false)
    end

    it 'must fail when the total points of the items does not match' do
      survivor_one = create :survivor, items_attributes: [{kind: :water, quantity: 3}, {kind: :food, quantity: 11}]
      survivor_two = create :survivor, items_attributes: [{kind: :water, quantity: 7}, {kind: :food, quantity: 4}, {kind: :ammunition, quantity: 2}]

      post :trade_items, params: {survivors: [
        {id: survivor_one.id, items: {food: 3}},
        {id: survivor_two.id, items: {water: 2, ammunition: 2}}
      ]}

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(false)
    end

    it 'must fail if some survivor is infected' do
      survivor_one = create :survivor, :infected, items_attributes: [{kind: :water, quantity: 3}, {kind: :food, quantity: 11}]
      survivor_two = create :survivor, items_attributes: [{kind: :water, quantity: 7}, {kind: :food, quantity: 4}, {kind: :ammunition, quantity: 2}]

      post :trade_items, params: {survivors: [
        {id: survivor_one.id, items: {food: 3}},
        {id: survivor_two.id, items: {water: 2, ammunition: 1}}
      ]}

      response_hash = JSON.parse(response.body)
      expect(response_hash['success']).to eq(false)
    end
  end
end