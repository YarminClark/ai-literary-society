from tests.test_weekly_prompt import test_weekly_prompt
from tests.test_poet_context import test_get_poet_context
from tests.test_idea_generation import test_idea_generation
from tests.test_idea_selection import test_idea_selection

from tests.test_poem_drafting import test_poem_drafting
from tests.test_poem_review import test_poem_review
from tests.test_poem_revision import test_poem_revision
from tests.test_editorial_ranking import test_score_poem

from tests.test_publication import test_publish
from tests.test_memory_update import test_update_memory
from tests.test_call_llm import test_call_llm


test_weekly_prompt()
test_get_poet_context()
test_idea_generation()
test_idea_selection()
test_poem_drafting()
test_poem_review()
test_poem_revision()
test_score_poem()
test_publish()
test_update_memory()
test_call_llm()
