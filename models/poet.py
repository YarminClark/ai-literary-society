# poet.py

from dataclasses import dataclass


@dataclass
class Poet:
    id: int
    name: str
    age: int
    nationality: str
    first_language: str
    education_level: str
    occupation: str
    location: str
    biography: str
    physical_notes: str
    current_life_notes: str

    def __str__(self):
        return f"Poet(id={self.id}, name='{self.name}', age={self.age}, nationality='{self.nationality}', first_language='{self.first_language}', education_level='{self.education_level}', occupation='{self.occupation}', location='{self.location}', biography='{self.biography}', physical_notes='{self.physical_notes}', current_life_notes='{self.current_life_notes}')"