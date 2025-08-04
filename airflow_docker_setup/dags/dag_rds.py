from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator
from extract_rds import api_stock_data, load_data_rds

# Default DAG arguments
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": datetime(2025, 7, 28),
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    "chiz_rds",  # DAG name
    default_args=default_args,
    description="Fetch stock data and store in RDS",
    schedule_interval=None,  # Run manually or set a schedule
)

# Task 1: Fetch data from API
fetch_data_from_api = PythonOperator(
    task_id="fetch_from_api",
    python_callable=api_stock_data,
    dag=dag,
)

# Task 2: Load data into RDS
load_data_to_rds = PythonOperator(
    task_id="store_stock_data_in_rds",
    python_callable=load_data_rds,
    dag=dag,
)

# Set task dependencies
fetch_data_from_api >> load_data_to_rds
