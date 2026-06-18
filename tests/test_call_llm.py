from components.call_llm import call_llm

def test_call_llm():
    print(call_llm(provider="test", model="test", prompt="Write a poem about the ocean", context="As a beat poet."))
