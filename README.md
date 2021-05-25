# README

## Setup

This application is a relatively standard Rails app running against a PostgreSQL DB (for JSON storage). This needs PostgreSQL to be running on `localhost:5432`, with a user called `postgres` and an empty password.

To set up and run (in development mode):

```
bundle

rails db:setup

rails server
```


## Testing

Sample data using the two formats is included as `payload1.json` and `payload2.json`. This lets us test with `curl` as follows (from app root):

```
curl -H "Content-Type: application/json" -d @`pwd`/payload1.json localhost:3000/reservations
curl -H "Content-Type: application/json" -d @`pwd`/payload2.json localhost:3000/reservations
```

Rake tasks are provided to inspect the records created and purge them:

```
rake dump:reservations
rake purge:reservations
```

## rspec

A spec is included for the `ProcessReservationRequest` service, which does the bulk of the work.
```
rspec -fd
```


## Notes/Caveats

* `Reservation` models attributes common to both formats. Format-specific data is stored in individual reservations as a JSON object called `misc`.

* Guest records are automatically created if they don't exist. Guest lookup is done by email.

* Guest data included in the original request payload is embedded as a JSON object in individual `Reservation` records. This is distinct from data in the corresponding `Guest` record. `Guest` objects are created once, and requests may have different data for the same referenced guest. For one thing, the two formats have different phone number structures.

* This implementation models and stores `ReservationRequest` separately from the actual `Reservation`. This allows us to reprocess raw requests later, should the processing code change.

* Reservation requests are accepted and queued for asynchronous processing. The only validation done at the `/reservations` endpoint is for validity of the JSON payload. Acceptance of a request does not guarantee that it is processed.

* This implementation does not enforce non-overlapping that reservation date ranges for a guest as it is not in scope. It does however enforce uniqueness on `(guest_id, start_date, end_date)`, so repeating a request will fail to create another reservation.

* Modelling properties is not in scope.