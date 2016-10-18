class Item < ApplicationRecord

  enum kind: {water: 1, food: 2, medication: 3, ammunition: 4}

  KIND_TRADE_VALUE = {
    water: 4,
    food: 3,
    medication: 2,
    ammunition: 1
  }

  belongs_to :survivor

  validates :kind, :survivor, :quantity, presence: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
end
