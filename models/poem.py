# poem.py

from dataclasses import dataclass


@dataclass
class Poem:

    poet_id: int

    prompt: str

    idea: str

    draft: str

    review: str

    revision: str