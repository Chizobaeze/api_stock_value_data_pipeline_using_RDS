import mysql.connector
import pandas as pd
import requests
from airflow.models import Variable


# Fetch stock data from API
def api_stock_data():
    url = "https://apistocks.p.rapidapi.com/daily"
    querystring = {
        "symbol": "AAPL", "dateStart": "2025-06-01", "dateEnd": "2025-07-31"
        }
    headers = {
        "x-rapidapi-key": Variable.get("rapidapi_key"),
        "x-rapidapi-host": "apistocks.p.rapidapi.com",
    }

    response = requests.get(url, headers=headers, params=querystring)
    data = response.json()
    df = pd.DataFrame(data["Results"])

    # Rename columns to match database
    df.rename(
        columns={
            "Date": "date",
            "Open": "open",
            "Close": "close",
            "High": "high",
            "Low": "low",
            "Volume": "volume",
            "AdjClose": "adj_close",
        },
        inplace=True,
    )
    return df


# Load data into MySQL RDS
def load_data_rds():
    df = api_stock_data()
    rds_password = Variable.get("password")
    rds_host = Variable.get("rds_host")

    try:
        conn = mysql.connector.connect(
            host=rds_host,
            user="rds_data",
            password=rds_password,
            database="database_rds",
            port=3306,
        )
    except mysql.connector.Error as err:
        print(f"Could not connect to RDS: {err}")
        raise

    cursor = conn.cursor()

    # Create table if not exists
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS api_stock_data (
            id INT AUTO_INCREMENT PRIMARY KEY,
            date DATE,
            open FLOAT,
            high FLOAT,
            low FLOAT,
            close FLOAT,
            volume BIGINT,
            adj_close FLOAT
        )
    """
    )
    conn.commit()

    # Insert data
    insert_query = """
        INSERT INTO api_stock_data (
            date, open, high, low, close, volume, adj_close
        ) VALUES (%s, %s, %s, %s, %s, %s, %s)
    """

    for _, row in df.iterrows():
        cursor.execute(
            insert_query,
            (
                row["date"],
                row["open"],
                row["high"],
                row["low"],
                row["close"],
                int(row["volume"]),
                row["adj_close"],
            ),
        )

    conn.commit()
    cursor.close()
    conn.close()
    print("Data inserted successfully.")
