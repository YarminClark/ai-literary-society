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

def run_weekly_issue():

    # Get the weekly prompt
    prompt = weekly_prompt()
    print(f"Weekly Prompt: {prompt}")

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
        print(f"Poet Context for {poet_context['name']}: {poet_context}")
        
        # Generate ideas for the prompt
        ideas = idea_generation(
            prompt,
            poet_context
        )
        print(f"Ideas for {poet_context['name']}: {ideas}")

        selected_ideas = idea_selection(
            ideas,
            poet_context
        )
        print(f"Selected Ideas for {poet_context['name']}: {selected_ideas}")
   
        for idea in selected_ideas:

            print(f"\nGenerating draft for {poet_context['name']} based on idea: {idea}")
            draft = poem_drafting(
                prompt,
                poet_context,
                idea
            )
            print(f"Draft for {poet_context['name']}: {draft}")
                
            review_comments = poem_review(
                draft,
                poet_context
            )
            print(f"Review for {poet_context['name']}: {review_comments}")
 
            revised_poem = poem_revision(
                draft,
                review_comments,
                poet_context
            )
            print(f"Revision for {poet_context['name']}: {revised_poem}")
        
            poem_score = score_poem(revised_poem)

            create_poem(
                poet_id=poet.id,
                prompt=prompt,
                idea=idea,
                draft=draft,
                review=review_comments,
                revision=revised_poem
            )
            print(f"Number of poems in DB: {count_poems()}")

    """

    publish(rankings)

    memory_update()
    """

run_weekly_issue()
