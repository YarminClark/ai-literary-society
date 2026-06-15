# poem_repository.py

from database.db import get_connection
from models.poem import Poem

# Create a new poem and return its ID
def create_poem(
poet_id: int,
prompt: str,
idea: str,
draft: str,
review: str,
revision: str
) -> int:
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO poems
        (
            poet_id,
            prompt,
            idea,
            draft,
            review,
            revision
        )
        VALUES
        (
            ?,
            ?,
            ?,
            ?,
            ?,
            ?
        )
        """,
        (
            poet_id,
            prompt,
            idea,
            draft,
            review,
            revision
        )
    )

    poem_id = cursor.lastrowid

    conn.commit()
    conn.close()

    return poem_id

# Retrieve a poem by its ID
def get_poem(
poem_id: int
):

    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM poems
        WHERE id = ?
        """,
        (poem_id,)
    )

    poem = cursor.fetchone()

    conn.close()

    return row_to_poem(poem)


# Retrieve all poems for a given poet, ordered by creation date (newest first)
def get_poems_for_poet(
poet_id: int
):
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM poems
        WHERE poet_id = ?
        ORDER BY created_at DESC
        """,
        (poet_id,)
    )

    poems = cursor.fetchall()

    conn.close()

    return [row_to_poem(row) for row in poems]

# Convert a database row to a Poem object
def row_to_poem(row):
    return Poem(
        poet_id = row["poet_id"],
        prompt = row["prompt"],
        idea = row["idea"],
        draft = row["draft"],
        review = row["review"],
        revision = row["revision"]
    )


# Retrieve all poems, ordered by creation date (newest first)
def get_all_poems():
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM poems
        ORDER BY created_at DESC
        """
    )

    #poems = cursor.fetchall()
    row = cursor.fetchall()

    conn.close()

    #return poems
    return [row_to_poem(row) for row in rows]

# Delete a poem by its ID
def delete_poem(
poem_id: int
):
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        DELETE FROM poems
        WHERE id = ?
        """,
        (poem_id,)
    )

    conn.commit()
    conn.close()

# Function to count the total number of poems in the database
def count_poems():
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT COUNT(*)
        FROM poems
        """
    )

    count = cursor.fetchone()[0]

    conn.close()

    return count