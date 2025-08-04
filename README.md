# API_STOCK_VALUE_DATA_PIPELINE_USING_RDS
This project demonstrates a production-grade data pipeline built using Airflow and Airbyte to extract stock market data from the api_stock_data API available on RapidAPI, store the data in Amazon S3, load it into MySQL (hosted on Amazon RDS or locally), and finally sync the curated data into Amazon Redshift for analytics.

## Architecture
API ➜ Airflow  ➜ RDS (MYSQL) ➜ Airbyte ➜ Redshift

## Tool used
Apache Airflow (Dockerized)
MYSQL RDS – remoprary Data warehouse
Airbyte (Minikube) – ELT sync from RDS to Redshift
Amazon Redshift – Data warehouse
dbeaver - for logging and viewing my into my rds(mysql)

## 1. Stock Data Extraction (API Layer)
Source: api_stock_data from RapidAPI
Process: Data is fetched daily using a scheduled task (via Apache Airflow)

## 2. Staging in MySQL RDS (Temporary Warehouse)
Tool: MySQL RDS acts as an intermediary storage.
Purpose: Provides a structured relational format for raw API data.
Ingestion: Airflow reads the file from api and loads it into a staging table in RDS.

## 3. Airbyte Sync (Minikube Environment)
Tool: Airbyte, deployed on Minikube
Source Connector: MySQL (RDS)
Destination Connector: Amazon Redshift
Function: Airbyte extracts data from MySQL, applies optional normalization, and loads it into Redshift.
Sync Frequency: Scheduled to run automatically (e.g., daily)

## 4. Final Destination – Amazon Redshift
Tool: Redshift serves as the central data warehouse.
Structure: Airbyte automatically creates schemas and tables.
Purpose: Enables querying, dashboarding, and analytics on stock market data.

## DBeaver (Database Access & Validation Tool)
Tool: DBeaver (MYSQL client)
Use Case: Connected to MySQL (RDS) for querying and verifying API-ingested data
Function: Used to explore table structures, run validation queries, and monitor data flow during pipeline execution
Role in Project: Helped debug, log, and visually inspect the data at the RDS (MySQL) layer before syncing to Redshift




