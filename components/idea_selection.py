# Example of how to use constants in a function
# llm_prompt = constants.IDEA_SELECTION_LLM_PROMPT

# Example of how to use call_llm
# call_llm("test", "test-model", llm_prompt, "You are a helpful assistant.")

def idea_selection(
    ideas: list[str],
    poet_context: dict
) -> list[str]:

    return ideas[:1]