class Reservation < ApplicationRecord
  belongs_to :guest
  belongs_to :reservation_request

  validates_presence_of :guest
  validates_presence_of :reservation_request

  validates_presence_of :start_date, :end_date, :adults, :children, :infants, :nights, :guests
  validates_presence_of :payout_amount, :security_amount, :currency, :status, :total_amount

  validates_numericality_of :adults, :children, :infants, :nights, :guests,
                            only_integer: true, greater_than_or_equal_to: 0

  validates_numericality_of :payout_amount, :security_amount, :total_amount,
                            greater_than_or_equal_to: 0
end
