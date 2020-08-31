#!/bin/bash

export TEST_DB_NAME="hawq_feature_test_db"
psql -d postgres -c "create database $TEST_DB_NAME;"
export PGDATABASE=$TEST_DB_NAME
psql -c  "alter database $TEST_DB_NAME set lc_messages to 'C';"
psql -c "alter database $TEST_DB_NAME set lc_monetary to 'C';"
psql -c  "alter database $TEST_DB_NAME set lc_numeric to 'C';"
psql -c  "alter database $TEST_DB_NAME set lc_time to 'C';"
psql -c "alter database $TEST_DB_NAME set timezone_abbreviations to 'Default';"
psql -c  "alter database $TEST_DB_NAME set timezone to 'PST8PDT';"
psql -c  "alter database $TEST_DB_NAME set datestyle to 'postgres,MDY';"
