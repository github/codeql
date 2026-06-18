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
        instructions="Talks like a " + persona,  # $ Alert[py/system-prompt-injection]
        input=query,
    )

    response2 = client.responses.create(
        instructions="Talks like a " + persona,  # $ Alert[py/system-prompt-injection]
        input=[
            {
                "role": "developer",
                "content": "Talk like a " + persona  # $ Alert[py/system-prompt-injection]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "input_text",
                        "text": query
                    }
                ]
            }
        ]
    )

    completion1 = client.chat.completions.create(
        messages=[
            {
                "role": "developer",
                "content": "Talk like a " + persona  # $ Alert[py/system-prompt-injection]
            },
            {
                "role": "user",
                "content": query,
            },
            {
                "role": role,
                "content": query,
            }
        ]
    )

    completion2 = azure_client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": "Talk like a " + persona  # $ Alert[py/system-prompt-injection]
            },
            {
                "role": "user",
                "content": query,
            }
        ]
    )

    assistant = client.beta.assistants.create(
        name="Test Agent",
        model="gpt-4.1",
        instructions="Talks like a " + persona  # $ Alert[py/system-prompt-injection]
    )
