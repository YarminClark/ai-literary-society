# Example of how to use constants in a function
# llm_prompt = constants.POEM_REVISION_LLM_PROMPT

# Example of how to use call_llm
# call_llm("test", "test-model", llm_prompt, "You are a helpful assistant.")

def poem_revision(
    draft: str,
    review: str,
    poet_context: dict
) -> str:

    return (
        f"Revised version of "
        f"{draft}"
    )