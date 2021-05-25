class ReservationRequest < ApplicationRecord
  belongs_to :reservation, optional: true

  validates_presence_of :payload
end
