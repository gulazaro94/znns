class LostPointsReport

  def calculate_lost_points
    result = Survivor.infected.select('items.kind AS item_kind, SUM(items.quantity) AS total_quantity').
      joins(:items).group('items.kind')

    result.sum do |data|
      item_kind = Item.kinds.key(data.item_kind).to_sym
      Item::KIND_TRADE_VALUE[item_kind] * data.total_quantity
    end
  end

end