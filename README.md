# API_STOCK_VALUE_DATA_PIPELINE_USING_RDS
This project demonstrates a production-grade data pipeline built using Airflow and Airbyte to extract stock market data from the api_stock_data API available on RapidAPI, store the data in Amazon S3, load it into MySQL (hosted on Amazon RDS or locally), and finally sync the curated data into Amazon Redshift for analytics.

## Architecture
API ➜ Airflow  ➜ RDS (MYSQL) ➜ Airbyte ➜ Redshift

## Tool used
### 1.Apache Airflow (Dockerized)
### 2. MYSQL RDS – Temoprary Data warehouse
### 3. Airbyte (Minikube) – ELT sync from RDS to Redshift
### 4. Amazon Redshift – Data warehouse
### 5. dbeaver - for logging and viewing my into my rds(mysql)

## 1. Stock Data Extraction (API Layer)
Every day, Airflow runs a scheduled job that connects to the stock API on RapidAPI. It pulls fresh stock market data and prepares it for the next steps in the pipeline.
## 2. Staging in MySQL RDS (Temporary Warehouse)
I used MySQL on Amazon RDS as a temporary place to store the raw data from the stock API.
Airflow collects the data from the API and loads it into a staging table in MySQL.
This step gives the data a proper structure (rows and columns) before sending it to Redshift.
![image text](https://github.com/Chizobaeze/api_stock_value_data_pipeline_using_RDS/blob/2a434f82e14d250a8784e8bdab652b25adb4010c/rds_screenshot/for%20rds%202.PNG)

## 3. Airbyte Sync (Minikube Environment)
Airbyte is a tool that I ran on Minikube (a local Kubernetes environment). It helps move data from MySQL (hosted on Amazon RDS) to Amazon Redshift. Once new data is stored in MySQL (coming from the API), Airbyte connects to it, checks for updates, and sends the data to Redshift.

## 4. Final Destination – Amazon Redshift
Redshift is the main storage where all the final data lives. After Airbyte moves the stock data from MySQL, it automatically creates the right tables and folders (schemas) inside Redshift. This setup makes it easy to run queries, build dashboards, and analyze stock market trends using tools like SQL or BI platforms. It acts like the final stop where all clean and organized data is kept for reporting.

## DBeaver (Database Access & Validation Tool)
I used DBeaver to connect to MySQL RDS and check the data loaded from the API.
It helped me view tables, run quick checks, and make sure everything looked good before sending the data to Redshift.
![image text](https://github.com/Chizobaeze/api_stock_value_data_pipeline_using_RDS/blob/6d4c6d6c8235e152705dd7a0084802f26532f724/rds_screenshot/dbeaver%20rds.PNG))



