#!/bin/bash

dropdb -U "$POSTGRES_USER" "$POSTGRES_DB"
createdb -U "$POSTGRES_USER" -E UTF-8 "$POSTGRES_DB"
pg_restore -U "$POSTGRES_USER" \
           -d "$POSTGRES_DB" \
           --no-owner \
           --no-privileges \
           /data/traffic_stops_nc_2018_01_08.dump
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "VACUUM ANALYZE;"

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE VIEW analysis_view AS (
SELECT
  s.agency_description AS agency,
  CASE s.purpose
    WHEN 1 THEN 'Speed Limit Violation'
    WHEN 2 THEN 'Stop Light/Sign Violation'
    WHEN 3 THEN 'Driving While Impaired'
    WHEN 4 THEN 'Safe Movement Violation'
    WHEN 5 THEN 'Vehicle Equipment Violation'
    WHEN 6 THEN 'Vehicle Regulatory Violation'
    WHEN 7 THEN 'Seat Belt Violation'
    WHEN 8 THEN 'Investigation'
    WHEN 9 THEN 'Other Motor Vehicle Violation'
    WHEN 10 THEN 'Checkpoint'
  END AS purpose,
  CASE p.gender
    WHEN 'M' THEN 'Male'
    WHEN 'F' THEN 'Female'
  END AS driver_gender,
  p.age AS driver_age,
  CASE p.ethnicity
    WHEN 'N' THEN 'Non-Hispanic'
    WHEN 'H' THEN 'Hispanic'
  END AS driver_ethnicity,
  CASE p.race
    WHEN 'A' THEN 'Asian'
    WHEN 'B' THEN 'Black'
    WHEN 'I' THEN 'Native American'
    WHEN 'U' THEN 'Other'
    WHEN 'W' THEN 'White'
  END AS driver_race,
  se.search_id IS NOT NULL AS driver_searched
FROM
  nc_stop s
    JOIN nc_person p USING (stop_id)
    LEFT JOIN nc_search se USING (stop_id, person_id)
WHERE
  s.date BETWEEN '2016-01-01 00:00' AND '2016-01-08 00:00'
  AND p.type = 'D'
);"
