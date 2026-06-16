from database.poet_repository import get_poet

def get_poet_context(poet_id):

    poet = get_poet(poet_id)

    return f"{poet.name} ({poet.age}): {poet.biography}"
