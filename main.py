from components.weekly_prompt import weekly_prompt
from components.poet_context import get_poet_context
from components.idea_generation import idea_generation
from components.idea_selection import idea_selection

from components.poem_drafting import poem_drafting
from components.poem_review import poem_review
from components.poem_revision import poem_revision  
from components.editorial_ranking import score_poem

from components.publication import publish
from components.memory_update import update_memory

from database.poem_repository import create_poem, count_poems
from database.poet_repository import get_all_poets
from database.issue_repository import create_issue, get_latest_issue

def run_weekly_issue():
    # Create a new issue
    prompt = weekly_prompt()

    create_issue(prompt)
    issue_id = get_latest_issue().id
    print(f"Generated Issue: {issue_id}. Weekly Prompt: {prompt}")

    # Get all poets
    #poets = [{"id": 1, "name": "Day Mountain"}]  # Mocked poet list for testing
    poets = get_all_poets()
    #print(f"Poets: {[poet['name'] for poet in poets]}")
    print(f"Poets: {[poet.name for poet in poets]}")

    # Generate the poems for each poet at a time
    for poet in poets:

        # Get the information we need about the poet
        #poet_context = get_poet_context(poet["id"])
        poet_context = get_poet_context(poet.id)
        print(f"Poet Context {poet_context}")
        
        # Generate ideas for the prompt
        ideas = idea_generation(
            prompt,
            poet_context
        )
        print(f"Ideas for {poet.name}: {ideas}")

        selected_ideas = idea_selection(
            ideas,
            poet_context
        )
        print(f"Selected Ideas for {poet.name}: {selected_ideas}")
   
        for idea in selected_ideas:

            print(f"\nGenerating draft for {poet.name} based on idea: {idea}")
            draft = poem_drafting(
                prompt,
                poet_context,
                idea
            )
            print(f"Draft for {poet.name}: {draft}")
                
            review_comments = poem_review(
                draft,
                poet_context
            )
            print(f"Review for {poet.name}: {review_comments}")
 
            revised_poem = poem_revision(
                draft,
                review_comments,
                poet_context
            )
            print(f"Revision for {poet.name}: {revised_poem}")
        
            poem_score = score_poem(revised_poem)

            create_poem(
                poet_id=poet.id,
                issue_id=issue_id,
                idea=idea,
                draft=draft,
                review=review_comments,
                revision=revised_poem,
                score=poem_score
            )
            print(f"Number of poems in DB: {count_poems()}")

    # After all poems are generated, we can rank them and publish the issue
    publish(issue_id)

    """
    memory_update()
    """

run_weekly_issue()
