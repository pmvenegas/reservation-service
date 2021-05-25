# README

# Setup

This application is a relatively standard Rails app running against a PostgreSQL DB (for JSON storage).

# Notes/Caveats

* `Reservation` models attributes common to both formats. Format-specific data is stored in individual reservations as a JSON object called `misc`.

* Guest records are automatically created if they don't exist. Guest lookup is done by email.

* Guest data included in the original request payload is embedded as a JSON object in individual `Reservation` records. This is distinct from data in the corresponding `Guest` record. `Guest` objects are created once, and requests may have different data for the same referenced guest. For one thing, the two formats have different phone number structures.

* This implementation models and stores `ReservationRequest` separately from the actual `Reservation`. This allows us to reprocess raw requests later, should the processing code change.

* Reservation requests are accepted and queued for asynchronous processing. The only validation done at `/reservations` endpoint is for validity of the JSON payload. Acceptance of a request does not guarantee that it is processed.

* This implementation does not guarantee that reservation date ranges for a guest do not overlap, since that's not in the spec. It does however enforce uniqueness on `(guest_id, start_date, end_date)`, so repeating a request will fail to create another reservation.

* Modelling properties is not in scope.