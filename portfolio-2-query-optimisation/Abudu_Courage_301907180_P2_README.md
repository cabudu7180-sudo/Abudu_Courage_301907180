# Hotel Reservation System — SQL queries

## 1. Show related reservations, guests, rooms records (up to 20).

```sql
SELECT t0."reservation_id" AS "reservations_reservation_id",
       t0."check_in" AS "reservations_check_in",
       t1."guest_id" AS "guests_guest_id",
       t1."full_name" AS "guests_full_name",
       t2."room_id" AS "rooms_room_id",
       t2."room_number" AS "rooms_room_number"
FROM portfolio."reservations" t0
JOIN portfolio."guests" t1 ON t0."guest_id" = t1."guest_id"
JOIN portfolio."rooms" t2 ON t0."room_id" = t2."room_id"
ORDER BY t0."reservation_id", t1."guest_id", t2."room_id"
LIMIT 20;
```

| reservations_reservation_id | reservations_check_in | guests_guest_id | guests_full_name | rooms_room_id | rooms_room_number |
| --- | --- | --- | --- | --- | --- |
| 301 | 2026-06-10 | 101 | Avery Morgan | 201 | 101 |
| 302 | 2026-07-01 | 102 | Riley Chen | 202 | 102 |

## 2. Find reservations records where check_in matches "2026-06-10" (up to 20).

```sql
SELECT * FROM portfolio."reservations"
WHERE "check_in" IS NOT DISTINCT FROM '2026-06-10'
ORDER BY "reservation_id"
LIMIT 20;
```

| reservation_id | guest_id | room_id | check_in | check_out | status | total_amount |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026-06-10 | 2026-06-12 | confirmed | 290 |

## 3. Count payments records for each reservation_id (up to 20 groups).

```sql
SELECT "reservation_id", count(*) AS record_count
FROM portfolio."payments"
GROUP BY "reservation_id"
ORDER BY record_count DESC, "reservation_id" NULLS LAST
LIMIT 20;
```

| reservation_id | record_count |
| --- | --- |
| 301 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.036 | 4.691, 2.015, 2.036 | Sort → Seq Scan | 274 |
| After index | 0.296 | 0.301, 0.296, 0.293 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.036 ms to 0.296 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=4.644..4.648 rows=50 loops=1)
  Seq Scan on reservations (actual time=0.031..4.577 rows=50 loops=1)
Planning Time: 1.577 ms
Execution Time: 4.691 ms
```

### Before index, run 2

```text
Sort (actual time=1.987..1.99 rows=50 loops=1)
  Seq Scan on reservations (actual time=0.018..1.946 rows=50 loops=1)
Planning Time: 0.35 ms
Execution Time: 2.015 ms
```

### Before index, run 3

```text
Sort (actual time=2.006..2.009 rows=50 loops=1)
  Seq Scan on reservations (actual time=0.019..1.965 rows=50 loops=1)
Planning Time: 0.367 ms
Execution Time: 2.036 ms
```

### After index, run 1

```text
Sort (actual time=0.25..0.253 rows=50 loops=1)
  Bitmap Heap Scan on reservations (actual time=0.035..0.207 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=50 loops=1)
Planning Time: 0.604 ms
Execution Time: 0.301 ms
```

### After index, run 2

```text
Sort (actual time=0.245..0.248 rows=50 loops=1)
  Bitmap Heap Scan on reservations (actual time=0.034..0.206 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.589 ms
Execution Time: 0.296 ms
```

### After index, run 3

```text
Sort (actual time=0.244..0.247 rows=50 loops=1)
  Bitmap Heap Scan on reservations (actual time=0.033..0.205 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=50 loops=1)
Planning Time: 0.598 ms
Execution Time: 0.293 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Abudu_Courage_301907180_P2_Queries.sql, then Abudu_Courage_301907180_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Abudu_Courage_301907180_P2_QueryResults.png) · [Index comparison](screenshots/Abudu_Courage_301907180_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

