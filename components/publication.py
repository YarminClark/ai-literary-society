from database.poem_repository import get_poems_by_issue

def publish(issue_id):

    print(f"\n**** Publishing issue {issue_id})... ****")

    # Get all poems for the issue
    poems = get_poems_by_issue(issue_id)

    for poem in poems:
        print(f"Poem Score: {poem.score}")
        print(f"Poem Revision: {poem.revision}")
        print("")
