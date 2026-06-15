
from database.db import initialise_database
from database.poet_repository import create_poet
from database.poem_repository import create_poem

initialise_database()

create_poet("William Shakespeare", 52, "English playwright, widely regarded as the greatest writer in the English language.")
create_poet("Emily Dickinson", 55, "American poet known for her reclusive life and innovative verse.")
create_poet("Langston Hughes", 65, "American poet, social activist, and leader of the Harlem Renaissance.")

create_poem(
    poet_id=1,
    prompt="Write a sonnet about nature",
    idea="Focus on mountains and rivers",
    draft="Draft: The hills rise tall...",
    review="Reviewer suggested more vivid imagery",
    revision="Added metaphors and refined rhythm"
)
