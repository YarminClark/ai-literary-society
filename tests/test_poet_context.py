from components.poet_context import get_poet_context

def test_get_poet_context():
    poet_id = 1  # Assuming this poet exists in the test database
    context = get_poet_context(poet_id)
    print(f"Poet Context: {context}")
