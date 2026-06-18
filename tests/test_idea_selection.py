from components.idea_selection import idea_selection

def test_idea_selection():
    print(idea_selection(
        ideas=["Idea 1", "Idea 2", "Idea 3"],
        poet_context="beat poetry, melancholic tone"
    ))
