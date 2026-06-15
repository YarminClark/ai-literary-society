# Example of how to use constants in a function
# llm_prompt = constants.POEM_REVIEW_LLM_PROMPT

# Example of how to use call_llm
# call_llm("test", "test-model", llm_prompt, "You are a helpful assistant.")


def poem_review(
    draft: str,
    poet_context: dict
) -> str:

    return (
        f"Review comments for "
        f"{poet_context['name']}"
    )