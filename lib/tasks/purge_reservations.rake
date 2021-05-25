namespace :purge do
  task reservations: :environment do
    Reservation.destroy_all
    puts "Reservations purged"
  end
end
