import constants.constants as constants
from components.call_llm import call_llm
import random

# Example of how to use constants in a function
# llm_prompt = constants.EDITORIAL_RANKING_LLM_PROMPT

# Example of how to use call_llm
# call_llm("test", "test-model", llm_prompt, "You are a helpful assistant.")

# Might want to add a persona which is ranking these poems in the future. 

def score_poem(
    poem: str
) -> int:

    return (
        random.randint(1, 100)
    )