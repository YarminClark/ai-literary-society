# poet.py

from dataclasses import dataclass


@dataclass
class Poet:
    id: int
    name: str
    age: int
    biography: str