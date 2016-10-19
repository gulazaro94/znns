class TradeItems
  include Interactor

  # params survivor_one: [:id, :items], survivor_two: [:id, :items]
  def call

    validate_survivors_quantity!

    load_and_validate_survivors!

    validate_survivor_items_presence!

    validate_items_total_points!

    trade
  end

  private

  def trade
    ActiveRecord::Base.transaction do
      survivor_one = context.survivors.first
      subtract_given_items(survivor_one[:model], survivor_one[:items])

      survivor_two = context.survivors.last
      subtract_given_items(survivor_two[:model], survivor_two[:items])

      add_received_items(survivor_one[:model], survivor_two[:items])
      add_received_items(survivor_two[:model], survivor_one[:items])
    end
  end

  def add_received_items(survivor, items)
    items.each do |item_kind, item_quantity|
      item = survivor.items.find { |item| item.kind == item_kind.to_s }

      if item
        item.update(quantity: item.quantity + item_quantity.to_i)
      else
        survivor.items.create(kind: item_kind, quantity: item_quantity)
      end
    end
  end

  def subtract_given_items(survivor, items)
    items.each do |item_kind, item_quantity|
      item = survivor.items.find { |item| item.kind == item_kind.to_s }
      item.update(quantity: item.quantity - item_quantity.to_i)
    end
  end

  def load_and_validate_survivors!
    context.survivors.each do |survivor_data|
      survivor_data[:model] = Survivor.find_by(id: survivor_data[:id])

      unless survivor_data[:model]
        context.fail!(error: "Survivor of id #{survivor_data[:id]} does not exist in our database")
      end

      if survivor_data[:model].infected?
        context.fail!(error: "Survivor of id #{survivor_data[:id]} has already been infected and cannot trade anymore.")
      end
    end
  end

  def validate_survivors_quantity!
    if context.survivors.size != 2
      context.fail!(error: 'The trade only can be made between two survivors')
    end
  end

  def validate_survivor_items_presence!
    context.survivors.each do |survivor_data|
      survivor_data[:items].each do |item_kind, item_quantity|
        inventory_quantity = survivor_data[:model].item_quantity_by_kind(item_kind)

        if item_quantity.to_i <= 0
          context.fail!(error: "The #{item_kind} in trade of survivor of id #{survivor_data[:id]} cannot be zero")
        end

        if item_quantity.to_i > inventory_quantity
          error = "The survivor of id #{survivor_data[:id]} does not have enough #{item_kind} to trade." \
            "Inventory: #{inventory_quantity}; In trade: #{item_quantity}"

          context.fail!(error: error)
        end
      end
    end
  end

  def validate_items_total_points!
    total_points = context.survivors.map do |survivor_data|
      Item.sum_items_points(survivor_data[:items])
    end

    if total_points.first != total_points.last
      context.fail!(error: 'Invalid trade! The total points of survivors items does not match.')
    end
  end

end