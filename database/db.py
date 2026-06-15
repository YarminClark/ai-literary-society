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
def initialise_database():

    conn = get_connection()

    cursor = conn.cursor()

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

    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS poems
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,

            poet_id INTEGER NOT NULL,

            prompt TEXT,

            idea TEXT,

            draft TEXT,

            review TEXT,

            revision TEXT,

            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

            FOREIGN KEY(poet_id)
                REFERENCES poets(id)
        )
        """
    )

    conn.commit()
    conn.close()

