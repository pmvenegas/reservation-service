class ProcessReservationRequest
  def initialize(request)
    @request = request
  end

  def call
    create_reservation(@request)
  end

  private

  # We transform different payload formats into a unified
  # structure. These methods should be extracted into their own
  # services as we support more formats and complexity increases.

  def create_reservation(request)
    payload = request.payload

    reservation = if payload["reservation"]
                    process_format_1(payload["reservation"])
                  else
                    process_format_2(payload)
                  end

    guest = find_or_create_guest(reservation)
    guest.reservations.create!(reservation.merge(reservation_request: request))
  end

  def process_format_1(payload)
    {
      start_date:       payload["start_date"],
      end_date:         payload["end_date"],
      guests:           payload["number_of_guests"],
      adults:           payload["guest_details"]["number_of_adults"],
      children:         payload["guest_details"]["number_of_children"],
      infants:          payload["guest_details"]["number_of_infants"],
      nights:           payload["nights"],
      status:           payload["status_type"],
      currency:         payload["host_currency"],
      payout_amount:    payload["expected_payout_amount"],
      security_amount:  payload["listing_security_price_accurate"],
      total_amount:     payload["total_paid_amount_accurate"],
      guest_details: {
        email:          payload["guest_email"],
        first_name:     payload["guest_first_name"],
        last_name:      payload["guest_last_name"],
        phone_numbers:  payload["guest_phone_numbers"]
      },
      misc: {
        localized_description: payload["guest_details"]["localized_description"],
        guest_id:       payload["guest_id"]
      }
    }
  end

  def process_format_2(payload)
    {
      start_date:       payload["start_date"],
      end_date:         payload["end_date"],
      guests:           payload["guests"],
      adults:           payload["adults"],
      children:         payload["children"],
      infants:          payload["infants"],
      nights:           payload["nights"],
      status:           payload["status"],
      currency:         payload["currency"],
      payout_amount:    payload["payout_price"],
      security_amount:  payload["security_price"],
      total_amount:     payload["total_price"],
      guest_details: {
        email:          payload["guest"]["email"],
        first_name:     payload["guest"]["first_name"],
        last_name:      payload["guest"]["last_name"],
        phone_numbers:  [payload["guest"]["phone"]]
      },
      misc: {
        guest_id:       payload["guest"]["id"]
      }
    }
  end

  # NOTE: this automatically creates a guest record from a reservation
  # if it does not exist.
  def find_or_create_guest(reservation)
    Guest.find_by(email: reservation[:guest_details][:email]) ||
      Guest.create!(reservation[:guest_details])
  end
end
