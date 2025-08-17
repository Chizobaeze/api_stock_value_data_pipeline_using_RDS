# API_STOCK_VALUE_DATA_PIPELINE_USING_RDS

This project demonstrates a **production-grade data pipeline** built using **Apache Airflow** and **Airbyte**. The pipeline extracts stock market data from the `api_stock_data` API (hosted on RapidAPI), stores it temporarily in **MySQL (Amazon RDS)**, and then syncs it into **Amazon Redshift** for analytics and reporting.

---

## Architecture

API ➜ Airflow  ➜ RDS (MYSQL) ➜ Airbyte ➜ Redshift


---

##  Tools Used

| Tool          | Purpose                                                                 |
|---------------|-------------------------------------------------------------------------|
| **Apache Airflow** (Docker) | Orchestrates daily ETL jobs using DAGs                                 |
| **MySQL RDS**              | Temporary staging area for structured API data            |
| **Airbyte (Minikube)**     | ELT tool to sync from RDS (MySQL) to Redshift             |
| **Amazon Redshift**        | Final data warehouse for analytics and BI                 |
| **DBeaver**                | GUI tool for managing and validating data in MySQL RDS    |

---

##  Pipeline Stages

### 1️ Stock Data Extraction (API Layer)

- Airflow schedules a daily task that pulls stock market data from the `api_stock_data` API on **RapidAPI**.
- The extracted data is structured and prepared for loading into MySQL.

---

### 2️⃣ Staging in MySQL RDS (Temporary Warehouse)

- Airflow loads the structured API data into a **staging table** in **MySQL** hosted on **Amazon RDS**.
- This step normalizes the raw JSON and transforms it into relational format (rows + columns).

![MySQL RDS Screenshot](https://github.com/Chizobaeze/api_stock_value_data_pipeline_using_RDS/blob/2a434f82e14d250a8784e8bdab652b25adb4010c/rds_screenshot/for%20rds%202.PNG)

---

### 3️⃣ Airbyte Sync (Minikube Environment)

- **Airbyte**, running inside a **Minikube** cluster, connects to the MySQL RDS instance.
- It detects new or updated records and syncs the data into **Amazon Redshift**.
- The sync is automatic and schema-aware.

---

### 4️⃣ Final Destination – Amazon Redshift

- Redshift serves as the **analytics layer**.
- After syncing, tables and schemas are auto-generated.
- This setup enables:
  - SQL-based querying
  - Dashboard integration
  - Time-series and trend analysis for stock data
![airbyte sql to redshift](https://github.com/Chizobaeze/api_stock_value_data_pipeline_using_RDS/blob/ac64b60c8a04fd9dcbb59ca1ab9682bdb93fdf65/rds_screenshot/airbyte(mysql-redshift)4.0.PNG)
---

### 🔍 DBeaver (Data Validation)

- DBeaver connects to the MySQL RDS instance.
- Used to validate data structure and quality before syncing to Redshift.

![DBeaver MySQL Screenshot](https://github.com/Chizobaeze/api_stock_value_data_pipeline_using_RDS/blob/6d4c6d6c8235e152705dd7a0084802f26532f724/rds_screenshot/dbeaver%20rds.PNG)

---

## 📌 Summary

| Component        | Description                              |
|------------------|------------------------------------------|
| Data Source      | RapidAPI – `api_stock_data`              |
| Staging Layer    | MySQL on Amazon RDS                      |
| Transformation   | Performed during ingestion via Airflow   |
| Sync Tool        | Airbyte (MySQL ➜ Redshift)               |
| Final Warehouse  | Amazon Redshift                          |
| Monitoring Tool  | DBeaver                                  |

---




