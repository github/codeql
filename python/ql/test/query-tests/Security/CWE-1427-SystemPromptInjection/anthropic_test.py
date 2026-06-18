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

    print(response1, response2, response3)
