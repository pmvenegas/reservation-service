class ReservationsController < ApplicationController
  def create
    payload = JSON.parse(request.raw_post)

    # Save the request, queue a processor, and return
    ProcessReservationRequestJob.perform_later(ReservationRequest.create!(payload: payload))
  end
end
