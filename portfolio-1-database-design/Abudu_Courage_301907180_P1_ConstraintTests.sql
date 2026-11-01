-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. guests pk. Expected: pk_guests, SQLSTATE 23505.
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email", "phone")
VALUES (101, 'Jordan Lee', 'jordan.lee@example.test', NULL);

-- 2. guests email unique. Expected: uq_guests_0, SQLSTATE 23505.
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email", "phone")
VALUES (501, 'Jordan Lee', 'avery.morgan@example.test', NULL);

-- 3. guests email not null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email", "phone")
VALUES (502, 'Jordan Lee', NULL, NULL);

-- 4. rooms pk. Expected: pk_rooms, SQLSTATE 23505.
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "nightly_rate", "active")
VALUES (201, '201', 'standard', 150, TRUE);

-- 5. rooms number unique. Expected: uq_rooms_0, SQLSTATE 23505.
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "nightly_rate", "active")
VALUES (503, '101', 'standard', 150, TRUE);

-- 6. reservations pk. Expected: pk_reservations, SQLSTATE 23505.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (301, 101, 201, '2026-08-01', '2026-08-03', 'confirmed', 300);

-- 7. reservations guest fk. Expected: fk_reservations_0, SQLSTATE 23503.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (504, 9901, 201, '2026-08-01', '2026-08-03', 'confirmed', 300);

-- 8. reservations room fk. Expected: fk_reservations_1, SQLSTATE 23503.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (505, 101, 9902, '2026-08-01', '2026-08-03', 'confirmed', 300);

-- 9. reservations invalid dates. Expected: reservation_valid_dates, SQLSTATE 23514.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (506, 101, 201, '2026-08-03', '2026-08-01', 'confirmed', 300);

-- 10. payments pk. Expected: pk_payments, SQLSTATE 23505.
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "method")
VALUES (401, 302, 630, '2026-06-01T14:30:00Z', 'card');

-- 11. payments reservation unique. Expected: uq_payments_0, SQLSTATE 23505.
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "method")
VALUES (507, 301, 290, '2026-05-02T14:30:00Z', 'card');

-- 12. payments reservation fk. Expected: fk_payments_0, SQLSTATE 23503.
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "method")
VALUES (508, 9903, 100, '2026-05-03T14:30:00Z', 'cash');
