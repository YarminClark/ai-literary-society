# Example of how to use constants in a function
# llm_prompt = constants.IDEA_GENERATION_LLM_PROMPT

# Example of how to use call_llm
# call_llm("test", "test-model", llm_prompt, "You are a helpful assistant.")


def idea_generation(
    prompt: str,
    poet_context: dict
) -> list[str]:

    return [
        f"Idea 1 for {prompt}",
        f"Idea 2 for {prompt}",
        f"Idea 3 for {prompt}"
    ]