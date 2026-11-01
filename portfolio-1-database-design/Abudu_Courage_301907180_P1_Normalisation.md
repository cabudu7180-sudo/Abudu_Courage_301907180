# Hotel Reservation System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| reservation_id | payments records (list) |
| --- | --- |
| 301 | [401] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| payments.payment_id | payments.reservation_id | payments.method | reservations.reservation_id | reservations.guest_id | reservations.room_id | reservations.status | guests.guest_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | card | 301 | 101 | 201 | confirmed | 101 |

Key: payment_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## payments_example

| payments.payment_id | payments.reservation_id | payments.method | reservations.reservation_id | reservations.guest_id | reservations.room_id | reservations.status | guests.guest_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | card | 301 | 101 | 201 | confirmed | 101 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## guests

| guest_id | full_name | email | phone |
| --- | --- | --- | --- |
| 101 | Avery Morgan | avery.morgan@example.test | +1-555-0101 |
| 102 | Riley Chen | riley.chen@example.test | NULL |

## rooms

| room_id | room_number | room_type | nightly_rate | active |
| --- | --- | --- | --- | --- |
| 201 | 101 | standard | 145 | true |
| 202 | 102 | deluxe | 210 | true |

## reservations

| reservation_id | guest_id | room_id | check_in | check_out | status | total_amount |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026-06-10 | 2026-06-12 | confirmed | 290 |
| 302 | 102 | 202 | 2026-07-01 | 2026-07-04 | confirmed | 630 |

## payments

| payment_id | reservation_id | amount | paid_at | method |
| --- | --- | --- | --- | --- |
| 401 | 301 | 290 | 2026-05-01T14:30:00+00:00 | card |

## Dependencies

- guests: (guest_id) → full_name, email, phone
- rooms: (room_id) → room_number, room_type, nightly_rate, active
- reservations: (reservation_id) → guest_id, room_id, check_in, check_out, status, total_amount
- payments: (payment_id) → reservation_id, amount, paid_at, method

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
