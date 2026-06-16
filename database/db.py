# db.py

import sqlite3
from pathlib import Path
import os

DB_PATH = Path(__file__).parent.parent / "data" / "poetry.db"

# Ensure the data directory exists
def get_connection():
    conn = sqlite3.connect(DB_PATH)

    conn.row_factory = sqlite3.Row

    return conn

# Initialize the database and create tables if they don't exist
def initialise_database(drop_poems=False, drop_poets=False):

    # Get the directory of the current script (database folder)
    base_dir = os.path.dirname(__file__)
    schema_path = os.path.join(base_dir, "db_schema_seed.sql")

    # Read the SQL file
    with open(schema_path, "r") as f:
        sql_script = f.read()


    conn = get_connection()

    cursor = conn.cursor()

    if drop_poems:
        cursor.execute("""DROP TABLE IF EXISTS poems""")
        conn.commit()
        print("Dropped poems table")

    if drop_poets:
        cursor.execute("""DROP TABLE IF EXISTS poets""")
        conn.commit()
        print("Dropped poets table")

    # Execute the entire script
    cursor.executescript(sql_script)

    cursor.execute("""SELECT COUNT(*) FROM sqlite_master WHERE type='table'""")
    print(f"Database initialized with {cursor.fetchone()[0]} tables.")

    cursor.execute(
        """SELECT 
        'poets' AS table_name, COUNT(*) AS count FROM poets
        UNION ALL
        SELECT 
        'poet_trait_definitions' AS table_name, COUNT(*) AS count FROM poet_trait_definitions
        UNION ALL
        SELECT 'poet_traits' AS table_name, COUNT(*) AS count FROM poet_traits
        UNION ALL
        SELECT 'poet_influences' AS table_name, COUNT(*) AS count FROM poet_influences
        UNION ALL
        SELECT 'poet_relationships' AS table_name, COUNT(*) AS count FROM poet_relationships
        UNION ALL
        SELECT 'poet_events' AS table_name, COUNT(*) AS count FROM poet_events
        UNION ALL
        SELECT 'issues' AS table_name, COUNT(*) AS count FROM issues
        UNION ALL
        SELECT 'poems' AS table_name, COUNT(*) AS count FROM poems
        """)

    print(f"Current row counts:\n{cursor.fetchall()}")

    conn.commit()
    conn.close()
