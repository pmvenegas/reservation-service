namespace :dump do
  task reservations: :environment do
    Reservation.all.each { |r| puts JSON.pretty_generate(r.as_json) }
  end
end
