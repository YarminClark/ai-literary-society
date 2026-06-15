# constants.py
from typing import Final

# Generation limits
MIN_POEMS: Final[int] = 0
MAX_POEMS: Final[int] = 2
NUMBER_IDEAS: Final[int] = 10

# LLM Prompts
IDEA_GENERATION_LLM_PROMPT: Final[str] = "Can you have a think and come up with ten novel ideas for a poem based on the poetry prompt below?"
IDEA_SELECTION_LLM_PROMPT: Final[str] = "Please select the best ideas for a poem from the list below. Select the most unusual and interesting ideas, but also ones that are likely to be able to be turned into good poems. Please select a maximum of three ideas."
POEM_DRAFTING_LLM_PROMPT: Final[str] = "Please could you draft a poem based on the idea below? It doesn't need to rhyme - it can be in free verse, though rhythm is still important. Write in elevated tone with a wide vocabulary. Think: Faber and Faber quality poetry. Briefness is better than volume. Feel free to change the form slightly, e.g. omit the first all-vowels verse if helpful, or alter the order of the disappearing vowels. Please bring a human element into it, and make up some specifics, e.g. don't say 'clothes', say 'cashmere' or whatever, using specifics stand for generalisations."
POEM_REVIEW_LLM_PROMPT: Final[str] = "Please review the following poem and provide feedback on its strengths and weaknesses, and how it could be improved. This can be about the overall structure and logic, but also about the specific word choices and imagery. Please be as detailed as possible in your feedback, and provide specific suggestions for improvement."
POEM_REVISION_LLM_PROMPT: Final[str] = "Please revise the following poem based on the feedback:"
EDITORIAL_RANKING_LLM_PROMPT: Final[str] = "Please score the following poem on a scale of 1-100, based on its overall quality, originality, and technical execution:"
MEMORY_UPDATE_LLM_PROMPT: Final[str] = "Given the above poem that the poet wrote, please could you derive what information it would be useful to record about the poet, to feed into their developing persona:"
