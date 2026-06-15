# poem.py

from dataclasses import dataclass


@dataclass
class Poem:

    poet_id: int

    issue_id: int

    idea: str

    draft: str

    review: str

    revision: str

    score: int