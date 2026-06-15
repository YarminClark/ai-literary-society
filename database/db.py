# db.py

import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).parent.parent / "data" / "poetry.db"

# Ensure the data directory exists
def get_connection():
    conn = sqlite3.connect(DB_PATH)

    conn.row_factory = sqlite3.Row

    return conn

# Initialize the database and create tables if they don't exist
def initialise_database(drop_poems=False):

    conn = get_connection()

    cursor = conn.cursor()


    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS issues
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            prompt TEXT NOT NULL,
            date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        """
    )

    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS poets
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age INTEGER,
            biography TEXT
        )
        """
    )

    if drop_poems:
        cursor.execute("""DROP TABLE IF EXISTS poems""")
        conn.commit()
        print("Dropped poems table")

    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS poems
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            poet_id INTEGER NOT NULL,
            issue_id INTEGER NOT NULL,
            idea TEXT,
            draft TEXT,
            review TEXT,
            revision TEXT,
            score INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY(poet_id)
            REFERENCES poets(id)
        )
        """
    )

    conn.commit()
    conn.close()

