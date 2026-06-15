# poem.py

from dataclasses import dataclass


@dataclass
class Issue:

    id: int

    prompt: str

    date: str
