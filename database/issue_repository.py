from database.db import get_connection
from models.issues import Issue

def create_issue(
prompt: str
) -> int:

    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO issues
        (
            prompt
        )
        VALUES
        (
            ?
        )
        """,
        (prompt,)
    )

    conn.commit()
    issue_id = cursor.lastrowid
    conn.close()

    return issue_id

def get_issue(issue_id: int) -> Issue:
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM issues
        WHERE id = ?
        """,
        (issue_id,)
    )

    row = cursor.fetchone()

    conn.close()

    if row:
        return Issue(id=row[0], prompt=row[1], date=row[2])
    else:
        return None
    
def get_latest_issue() -> Issue:
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM issues
        ORDER BY date DESC
        LIMIT 1
        """
    )

    row = cursor.fetchone()

    conn.close()

    if row:
        return Issue(id=row[0], prompt=row[1], date=row[2])
    else:
        return None
