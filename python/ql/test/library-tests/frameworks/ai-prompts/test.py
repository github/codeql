from openai import OpenAI
from agents import Agent, Runner
from anthropic import Anthropic
from google import genai
from google.genai import types
from openrouter import OpenRouter
from langchain_core.messages import SystemMessage, HumanMessage

openai = OpenAI()
openai.chat.completions.create(
    model="gpt-4.1",
    messages=[
        {"role": "system", "content": "OpenAI system"},
        {"role": "user", "content": "OpenAI user"},
    ],
)
openai.responses.create(model="gpt-4.1", instructions="Response system", input="Response user")

agent = Agent(name="Assistant", instructions="Agent system")
Runner.run_sync(
    agent,
    [
        {"role": "developer", "content": "Runner system"},
        {"role": "user", "content": "Runner user"},
    ],
)

anthropic = Anthropic()
anthropic.messages.create(
    model="claude-sonnet-4-20250514",
    max_tokens=256,
    system="Anthropic system",
    messages=[
        {"role": "assistant", "content": "Anthropic assistant"},
        {"role": "user", "content": "Anthropic user"},
    ],
)

gemini = genai.Client()
gemini.models.generate_content(
    model="gemini-2.0-flash",
    config=types.GenerateContentConfig(system_instruction="Gemini system"),
    contents=[
        {"role": "model", "parts": [{"text": "Gemini model"}]},
        {"role": "user", "parts": [{"text": "Gemini user"}]},
    ],
)

router = OpenRouter()
router.chat.send(
    model="openai/gpt-4.1",
    messages=[
        {"role": "system", "content": "OpenRouter system"},
        {"role": "user", "content": "OpenRouter user"},
    ],
)

SystemMessage(content="LangChain system")
HumanMessage(content="LangChain user")
