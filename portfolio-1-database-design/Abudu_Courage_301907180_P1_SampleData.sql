-- Fictional sample records for Hotel Reservation System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email", "phone") VALUES (101, 'Avery Morgan', 'avery.morgan@example.test', '+1-555-0101');
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email", "phone") VALUES (102, 'Riley Chen', 'riley.chen@example.test', NULL);
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "nightly_rate", "active") VALUES (201, '101', 'standard', 145, TRUE);
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "nightly_rate", "active") VALUES (202, '102', 'deluxe', 210, TRUE);
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount") VALUES (301, 101, 201, '2026-06-10', '2026-06-12', 'confirmed', 290);
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount") VALUES (302, 102, 202, '2026-07-01', '2026-07-04', 'confirmed', 630);
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "method") VALUES (401, 301, 290, '2026-05-01T14:30:00Z', 'card');
COMMIT;
