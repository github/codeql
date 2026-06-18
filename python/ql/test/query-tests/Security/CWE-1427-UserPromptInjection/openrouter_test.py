from openrouter import OpenRouter
from flask import Flask, request  # $ Source

app = Flask(__name__)
client = OpenRouter()


@app.route("/openrouter")
def get_input_openrouter():
    query = request.args.get("query")

    completion = client.chat.completions.create(
        model="openai/gpt-4.1",
        messages=[
            {
                "role": "system",
                "content": "You are a helpful assistant.",
            },
            {
                "role": "user",
                "content": query,  # $ Alert[py/user-prompt-injection]
            }
        ]
    )
    print(completion)
