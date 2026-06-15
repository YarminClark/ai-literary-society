from database.db import get_connection

# Create a new poet and return the poet's ID
def create_poet(
name: str,
age: int,
biography: str
) -> int:

    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO poets
        (
            name,
            age,
            biography
        )
        VALUES
        (
            ?,
            ?,
            ?
        )
        """,
        (
            name,
            age,
            biography
        )
    )

    poet_id = cursor.lastrowid

    conn.commit()
    conn.close()

    return poet_id

# Get a poet by ID
def get_poet(
poet_id: int
):

    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM poets
        WHERE id = ?
        """,
        (poet_id,)
    )

    poet = cursor.fetchone()

    conn.close()

    return poet

# Get all poets, ordered by name
def get_all_poets():

    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM poets
        ORDER BY name
        """
    )

    poets = cursor.fetchall()

    conn.close()

    return poets

# Update a poet's information
def update_poet(
poet_id: int,
name: str,
age: int,
biography: str
):

    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        UPDATE poets
        SET
            name = ?,
            age = ?,
            biography = ?
        WHERE id = ?
        """,
        (
            name,
            age,
            biography,
            poet_id
        )
    )

    conn.commit()
    conn.close()

def delete_poet(
poet_id: int
):

    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        DELETE FROM poets
        WHERE id = ?
        """,
        (poet_id,)
    )

    conn.commit()
    conn.close()