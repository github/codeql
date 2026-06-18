from openai import OpenAI, AsyncOpenAI, AzureOpenAI
from flask import Flask, request  # $ Source
app = Flask(__name__)

client = OpenAI()


@app.route("/openai")
async def get_input_openai():
    persona = request.args.get("persona")
    query = request.args.get("query")
    role = request.args.get("role")

    response1 = client.responses.create(
        instructions="Talks like a " + persona,
        input=query,  # $ Alert[py/user-prompt-injection]
    )

    response2 = client.responses.create(
        input=[
            {
                "role": "developer",
                "content": "Talk like a " + persona
            },
            {
                "role": "user",
                "content": query,  # $ Alert[py/user-prompt-injection]
            }
        ]
    )

    completion1 = client.chat.completions.create(
        messages=[
            {
                "role": "developer",
                "content": "Talk like a " + persona
            },
            {
                "role": "user",
                "content": query,  # $ Alert[py/user-prompt-injection]
            },
            {
                "role": role,
                "content": query,  # $ Alert[py/user-prompt-injection]
            }
        ]
    )

    completion2 = client.completions.create(
        model="gpt-3.5-turbo-instruct",
        prompt="Summarize: " + query,  # $ Alert[py/user-prompt-injection]
    )

    image = client.images.generate(
        prompt="A picture of " + query,  # $ Alert[py/user-prompt-injection]
    )
