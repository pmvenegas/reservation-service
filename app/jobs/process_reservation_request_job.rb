class ProcessReservationRequestJob < ApplicationJob
  def perform(request)
    ProcessReservationRequest.new(request).call
  end
end
