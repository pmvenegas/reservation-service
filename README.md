# README

This is a demo web application that implements an endpoint that accepts reservation requests in different JSON formats for storage.

## Setup

This application is a relatively standard Rails app running against a PostgreSQL DB (for JSON storage). This needs PostgreSQL to be running on `localhost:5432`, with a user called `postgres` and an empty password.

To set up and run (in development mode):

```
bundle

rails db:setup

rails server
```

This sets up the endpoint at `http://localhost:3000/reservations`.

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

* This implementation models and stores `ReservationRequest` separately from the actual `Reservation`. This provides the flexibility to reprocess requests later, should processing requirements change or implementation issues be found.

* Reservation requests are accepted and queued for asynchronous processing, so the endpoint is lightweight and any complex processing does not affect performance. The only validation done at the `/reservations` endpoint is for validity of the JSON payload. Acceptance of a request does not guarantee that it is processed.

* `Reservation` models attributes common to both formats. Format-specific data is stored in individual reservations as a JSON object called `misc`.

* Guest records are automatically created if they don't exist. Guest lookup is done by email.

* Guest data from the request is embedded as a JSON object in individual `Reservation` records for easy direct access. `Guest` objects are created once, but reservations may have different data for the referenced guest. For one thing, the two formats have different phone number structures.

* This implementation does not enforce non-overlapping reservation date ranges for a guest. It does however enforce uniqueness on `(guest_id, start_date, end_date)`, so repeating a request will fail to create another reservation. Error reporting beyond logging is not implemented.

* As this is a proof of concept, DB updates are intentionally called with `!`, so errors are immediately obvious and can be dealt with.

* Modelling exclusivity of reservations for properties would be a nice challenge, but not in scope.