class ItemsAverageBySurvivorReport


  def calculate_items_average
    result = Survivor.not_infected.select('items.kind AS item_kind, SUM(items.quantity) AS total_quantity').
      joins(:items).group('items.kind')

    total_survivors = Survivor.not_infected.count

    items_average_hash = result.map do |data|
      [Item.kinds.key(data.item_kind), data.total_quantity / total_survivors.to_f]
    end.to_h

    fill_empty_item_kind(items_average_hash)

    items_average_hash
  end

  def fill_empty_item_kind(items_average_hash)
    (Item.kinds.keys - items_average_hash.keys).each do |item_kind|
      items_average_hash[item_kind] = 0
    end
  end

end