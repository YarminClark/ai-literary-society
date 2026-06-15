def poem_drafting(
    prompt: str,
    poet_context: dict,
    idea: str
) -> str:

    return (
        f"Draft poem based on "
        f"{idea} for "
        f"{poet_context['name']}"
    )