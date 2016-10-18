class InfectionNotification < ApplicationRecord
  belongs_to :survivor
  belongs_to :infected, class_name: 'Survivor'

  validates :survivor, :infected, presence: true
  validates :infected_id, uniqueness: {scope: :survivor_id}
end
