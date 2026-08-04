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
        system="Talk like " + persona,  # $ Alert[py/prompt-injection]
        messages=[
            {
                "role": "user",
                "content": query,  # $ Alert[py/prompt-injection]
            }
        ],
    )

    response2 = client.messages.stream(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        system="Talk like " + persona,  # $ Alert[py/prompt-injection]
        messages=[
            {
                "role": "user",
                "content": query,  # $ Alert[py/prompt-injection]
            }
        ],
    )

    response3 = await async_client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        system="Talk like " + persona,  # $ Alert[py/prompt-injection]
        messages=[
            {
                "role": "user",
                "content": query,  # $ Alert[py/prompt-injection]
            }
        ],
    )

    response4 = client.beta.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        system="Talk like " + persona,  # $ Alert[py/prompt-injection]
        messages=[
            {
                "role": "user",
                "content": query,  # $ Alert[py/prompt-injection]
            }
        ],
        betas=["prompt-caching-2024-07-31"],
    )

    print(response1, response2, response3, response4)