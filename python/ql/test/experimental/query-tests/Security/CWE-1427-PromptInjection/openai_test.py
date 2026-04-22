from openai import OpenAI, AsyncOpenAI, AzureOpenAI
from flask import Flask, request  # $ Source
app = Flask(__name__)

client = OpenAI()
async_client = AsyncOpenAI()
azure_client = AzureOpenAI()


@app.route("/openai")
async def get_input_openai():
    persona = request.args.get("persona")
    query = request.args.get("query")
    role = request.args.get("role")

    response1 = client.responses.create(
        instructions="Talks like a " + persona,  # $ Alert[py/prompt-injection]
        input=query,  # $ Alert[py/prompt-injection]
    )

    response2 = client.responses.create(
        instructions="Talks like a " + persona,  # $ Alert[py/prompt-injection]
        input=[
            {
                "role": "developer",
                "content": "Talk like a " + persona  # $ Alert[py/prompt-injection]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "input_text",
                        "text": query  # $ Alert[py/prompt-injection]
                    }
                ]
            }
        ]
    )

    response3 = await async_client.responses.create(
        instructions="Talks like a " + persona,  # $ Alert[py/prompt-injection]
        input=query,  # $ Alert[py/prompt-injection]
    )

    async with client.realtime.connect(model="gpt-realtime") as connection:
        await connection.conversation.item.create(
            item={
                "type": "message",
                "role": role,
                "content": [
                    {
                        "type": "input_text",
                        "text": query  # $ Alert[py/prompt-injection]
                    }
                ],
            }
        )

    completion1 = client.chat.completions.create(
        messages=[
            {
                "role": "developer",
                "content": "Talk like a " + persona # $ Alert[py/prompt-injection]
            },
            {
                "role": "user",
                "content": query,  # $ Alert[py/prompt-injection]
            },
            {
                "role": role,
                "content": query,  # $ Alert[py/prompt-injection]
            }
        ]
    )

    completion2 = azure_client.chat.completions.create(
        messages=[
            {
                "role": "developer",
                "content": "Talk like a " + persona  # $ Alert[py/prompt-injection]
            },
            {
                "role": "user",
                "content": query,  # $ Alert[py/prompt-injection]
            }
        ]
    )

    assistant = client.beta.assistants.create(
        name="Test Agent",
        model="gpt-4.1",
        instructions="Talks like a " + persona  # $ Alert[py/prompt-injection]
    )
