from components.idea_generation import idea_generation

def test_idea_generation():
    print(idea_generation(
        prompt="Write a poem about the ocean",
        poet_context={"style": "beat poetry", "tone": "melancholic"}
    ))