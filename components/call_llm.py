import os

"""
from google import genai
from google.genai import types # pip install google-genai
from openai import OpenAI # pip install openai
"""


def call_llm(provider: str, model: str, prompt: str, context: str = None) -> str:
    """
    Unified function to make LLM text generation calls across Google AI Studio,
    OpenRouter, and GitHub Models.
    
    Parameters:
        provider (str): One of 'google', 'openrouter', or 'github'
        model (str): The specific model identifier string
        prompt (str): The primary instructions or user text
        context (str): System instructions to set the persona/rules (e.g., poetry parameters)
    """
    provider = provider.lower()
    
    try:
        # --- 0. Test Provider ---
        if provider == 'test':
            return f"Test response from {model} with context: {context}\nPrompt was: {prompt}"
        
        # --- 1. GOOGLE AI STUDIO INTERFACE ---
        elif provider == 'google':
            # Uses the modern google-genai SDK
            client = genai.Client() 
            
            # Configure context as a system instruction if provided
            config = None
            if context:
                config = types.GenerateContentConfig(
                    system_instruction=context
                )
            
            response = client.models.generate_content(
                model=model,
                contents=prompt,
                config=config
            )
            return response.text

        # --- 2. OPENROUTER INTERFACE ---
        elif provider == 'openrouter':
            # OpenRouter utilizes the OpenAI client standard pointing to their endpoint
            client = OpenAI(
                base_url="https://openrouter.ai/api/v1",
                api_key=os.environ.get("OPENROUTER_API_KEY")
            )
            
            messages = []
            if context:
                messages.append({"role": "system", "content": context})
            messages.append({"role": "user", "content": prompt})
            
            response = client.chat.completions.create(
                model=model,
                messages=messages,
                # Optional but recommended headers for tracking project on leaderboards
                extra_headers={
                    "HTTP-Referer": "https://localhost:3000", 
                    "X-Title": "Poetry Project"
                }
            )
            return response.choices[0].message.content

        # --- 3. GITHUB MODELS INTERFACE ---
        elif provider == 'github':
            # GitHub Models hosts an OpenAI-compliant endpoint using your GitHub Token
            client = OpenAI(
                base_url="https://azure.com",
                api_key=os.environ.get("GITHUB_TOKEN")
            )
            
            messages = []
            if context:
                messages.append({"role": "system", "content": context})
            messages.append({"role": "user", "content": prompt})
            
            response = client.chat.completions.create(
                model=model,
                messages=messages
            )
            return response.choices[0].message.content

        else:
            raise ValueError(f"Unsupported provider: {provider}")

    except Exception as e:
        return f"Error calling {provider} ({model}): {str(e)}"
