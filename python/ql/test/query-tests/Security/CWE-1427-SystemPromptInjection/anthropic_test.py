from anthropic import Anthropic, AsyncAnthropic
from flask import Flask, request  # $ Source

app = Flask(__name__)
client = Anthropic()
async_client = AsyncAnthropic()


@app.route("/anthropic")
async def get_input_anthropic():
    persona = request.args.get("persona")
    query = request.args.get("query")

    response1 = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        system="Talk like " + persona,  # $ Alert[py/system-prompt-injection]
        messages=[
            {
                "role": "assistant",
                "content": "I am " + persona,  # $ Alert[py/system-prompt-injection]
            },
            {
                "role": "user",
                "content": query,
            }
        ],
    )

    response2 = client.messages.stream(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        system="Talk like " + persona,  # $ Alert[py/system-prompt-injection]
        messages=[
            {
                "role": "user",
                "content": query,
            }
        ],
    )

    response3 = client.beta.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        system="Talk like " + persona,  # $ Alert[py/system-prompt-injection]
        messages=[
            {
                "role": "user",
                "content": query,
            }
        ],
    )

    agent = client.beta.agents.create(
        model="claude-sonnet-4-20250514",
        name="assistant",
        system="Talk like " + persona,  # $ Alert[py/system-prompt-injection]
    )

    client.beta.agents.update(
        agent_id=agent.id,
        version=1,
        system="Talk like " + persona,  # $ Alert[py/system-prompt-injection]
    )

    tool_response = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        messages=[{"role": "user", "content": query}],
        tools=[
            {
                "name": "lookup",
                "description": "Talk like " + persona,  # $ Alert[py/system-prompt-injection]
                "input_schema": {"type": "object", "properties": {}},
            }
        ],
    )

    print(response1, response2, response3, tool_response)
