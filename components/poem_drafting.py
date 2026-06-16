# Example of how to use constants in a function
# llm_prompt = constants.POEM_DRAFTING_LLM_PROMPT

# Example of how to use call_llm
# call_llm("test", "test-model", llm_prompt, "You are a helpful assistant.")


def poem_drafting(
    prompt: str,
    poet_context: str,
    idea: str
) -> str:

    return (
        f"Draft poem based on "
        f"{idea} for "
        f"{poet_context}"
    )