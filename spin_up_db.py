
from database.db import initialise_database
from database.poet_repository import create_poet
from database.poem_repository import create_poem, delete_all_poems

populate_poets = False
delete_poems_table = False
delete_and_repopulate_poems = False

initialise_database(drop_poems=delete_poems_table)

if populate_poets:
    create_poet("William Shakespeare", 52, "English playwright, widely regarded as the greatest writer in the English language.")
    create_poet("Emily Dickinson", 55, "American poet known for her reclusive life and innovative verse.")
    create_poet("Langston Hughes", 65, "American poet, social activist, and leader of the Harlem Renaissance.")

if delete_and_repopulate_poems:
    delete_all_poems()

    create_poem(
        poet_id=1,
        issue_id=1,
        idea="Focus on mountains and rivers",
        draft="Draft: The hills rise tall...",
        review="Reviewer suggested more vivid imagery",
        revision="Added metaphors and refined rhythm",
        score=8
    )
