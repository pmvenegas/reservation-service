require 'rails_helper'

RSpec.describe ProcessReservationRequest do
  let(:payload_1) do
    JSON.parse <<~END
    {
      "reservation": {
        "start_date": "2020-03-12",
        "end_date": "2020-03-16",
        "expected_payout_amount": "3800.00",
        "guest_details": {
          "localized_description": "4 guests",
          "number_of_adults": 2,
          "number_of_children": 2,
          "number_of_infants": 0
        },
        "guest_email": "wayne_woodbridge@bnb.com",
        "guest_first_name": "Wayne",
        "guest_id": 1,
        "guest_last_name": "Woodbridge",
        "guest_phone_numbers": [
          "639123456789",
          "639123456789"
        ],
        "listing_security_price_accurate": "500.00",
        "host_currency": "AUD",
        "nights": 4,
        "number_of_guests": 4,
        "status_type": "accepted",
        "total_paid_amount_accurate": "4500.00"
      }
    }
    END
  end

  let(:payload_2) do
    JSON.parse <<~END
    {
      "start_date": "2020-03-12",
      "end_date": "2020-03-16",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "id": 1,
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "639123456789",
        "email": "wayne_woodbridge@bnb.com"
      },
      "currency": "AUD",
      "payout_price": "3800.00",
      "security_price": "500",
      "total_price": "4500.00"
    }
    END
  end
  let(:guest_email) { "wayne_woodbridge@bnb.com" }

  let(:expected_values) do
    {
      start_date: Date.new(2020, 3, 12),
      end_date: Date.new(2020, 3, 16),
      nights: 4,
      guests: 4,
      adults: 2,
      children: 2,
      infants: 0,
      status: "accepted",
      currency: "AUD",
      payout_amount: 3800.00,
      security_amount: 500.00,
      total_amount: 4500.00
    }
  end

  shared_examples "you would expect" do
    before do
      described_class.new(request).call
    end

    let(:reservation) { Reservation.first }

    it "creates the reservation correctly" do
      expected_values.each do |field, value|
        expect(reservation.send(field)).to eq value
      end
    end

    it "creates a record for a new guest" do
      expect(Guest.first.email).to eq guest_email
    end

    it "associates the reservation with the right guest" do
      expect(reservation.guest.email).to eq guest_email
    end

    it "associates the reservation with the original request" do
      expect(reservation.reservation_request).to eq request
    end
  end

  context "when processing a request in format 1" do
    let(:request) { ReservationRequest.create!(payload: payload_1) }
    it_behaves_like "you would expect"
  end

  context "when processing a request in format 2" do
    let(:request) { ReservationRequest.create!(payload: payload_2) }
    it_behaves_like "you would expect"
  end
end
