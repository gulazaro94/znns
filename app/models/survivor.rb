class Survivor < ApplicationRecord

  enum gender: {male: true, female: false}

  MAX_ALLOWED_AGE = 122

  has_many :items, inverse_of: :survivor
  has_many :done_infection_notifications, class_name: 'InfectionNotification', foreign_key: :survivor_id
  has_many :received_infection_notifications, class_name: 'InfectionNotification', foreign_key: :infected_id

  accepts_nested_attributes_for :items

  validates :name, :age, :gender, :last_location_lat, :last_location_lon, presence: true
  validates :name, length: {maximum: 150}
  validates :age, numericality: {greater_than: 0, less_than: MAX_ALLOWED_AGE}
  validates :last_location_lat, numericality: {greater_than: -86, less_than: 86}
  validates :last_location_lon, numericality: {greater_than: -181, less_than: 181}

  def reset_location
    self.last_location_lat = nil
    self.last_location_lon = nil
  end

end
