from openrouter import OpenRouter
from flask import Flask, request  # $ Source

app = Flask(__name__)
client = OpenRouter()


@app.route("/openrouter")
def get_input_openrouter():
    persona = request.args.get("persona")
    query = request.args.get("query")

    completion = client.chat.completions.create(
        model="openai/gpt-4.1",
        messages=[
            {
                "role": "system",
                "content": "Talk like a " + persona,  # $ Alert[py/system-prompt-injection]
            },
            {
                "role": "user",
                "content": query,
            }
        ]
    )
    print(completion)
