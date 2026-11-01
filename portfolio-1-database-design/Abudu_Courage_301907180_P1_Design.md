# Hotel Reservation System — database design

My case study records guests, rooms, reservations, payments.

## Users

- Front-desk staff managing guest stays and room assignments
- Finance staff recording reservation payments
- Managers reviewing occupancy and payment summaries

## Main operations

- Register guests and rooms
- Create and update reservations
- Record one payment per reservation
- Review stays and summarize payments

## Entities

| Entity | Information stored |
| --- | --- |
| guests | People who make hotel reservations. |
| rooms | Rooms available for reservation at the hotel. |
| reservations | A guest's planned stay in a specific room. |
| payments | The single payment record associated with a reservation. |

## guests

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| guest_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| phone | TEXT |  | No |
- Unique key: (email).

## rooms

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| room_id | BIGINT | PK | Yes |
| room_number | TEXT | Unique | Yes |
| room_type | TEXT |  | Yes |
| nightly_rate | NUMERIC(18,2) |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (room_number).

## reservations

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reservation_id | BIGINT | PK | Yes |
| guest_id | BIGINT | FK | Yes |
| room_id | BIGINT | FK | Yes |
| check_in | DATE |  | Yes |
| check_out | DATE |  | Yes |
| status | TEXT |  | Yes |
| total_amount | NUMERIC(18,2) |  | Yes |
- guest_id → guests.guest_id
- room_id → rooms.room_id

## payments

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| reservation_id | BIGINT | FK, Unique | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| paid_at | TIMESTAMPTZ |  | Yes |
| method | TEXT |  | Yes |
- reservation_id → reservations.reservation_id
- Unique key: (reservation_id).

## Relationships and business rules

- Each guest email identifies at most one guest.
- Each room number identifies at most one room in the property.
- Every reservation references an existing guest through guest_id.
- Every reservation references an existing room through room_id.
- A reservation's check_out date must be later than its check_in date.
- Every payment references an existing reservation through reservation_id.
- At most one payment record may be associated with a reservation.

## Assumptions

- Room numbers are unique within this single property.
- Reservation dates are calendar dates, and check-out must be later than check-in.
- A payment record represents the reservation's single recorded payment, not installments.
- Normalization example: use payments as the root because it references reservations; keep reservation attributes in reservations and do not repeat guest or room details in payments.
- Separate benchmark plan: compare filtering reservations by check_in with and without a B-tree index over 50,000 synthetic reservation rows.

