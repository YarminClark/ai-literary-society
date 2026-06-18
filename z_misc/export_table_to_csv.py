import sqlite3
import csv
from database.db import get_connection


def export_table_to_csv(table_name: str, csv_path: str):
    """
    Export a SQLite table to a CSV file.

    Parameters:
        table_name (str): Name of the table to export.
        csv_path (str): Path to the output CSV file (without file name).
    """
    csv_path = f"{csv_path}\\{table_name}.csv"

    try:
        # Connect to the SQLite database
        conn = get_connection()
        cursor = conn.cursor()

        # Fetch all rows from the table
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()

        # Get column names
        column_names = [description[0] for description in cursor.description]

        # Write to CSV
        with open(csv_path, mode="w", newline="", encoding="utf-8") as csv_file:
            writer = csv.writer(csv_file)
            writer.writerow(column_names)  # Write header
            writer.writerows(rows)         # Write data

        print(f"Table '{table_name}' exported successfully to {csv_path}")

    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
    finally:
        if conn:
            conn.close()
