import json
import random

def weekly_prompt():
    # Open and load the JSON file
    with open("data/poetryPrompts.json", "r", encoding="utf-8") as f:
        prompts = json.load(f)  # assumes the file contains a list

    # Pick and return a random member of the list
    return random.choice(prompts)
