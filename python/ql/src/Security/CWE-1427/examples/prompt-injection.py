from flask import Flask, request
from openai import OpenAI

app = Flask(__name__)
client = OpenAI()


@app.get("/chat")
def chat():
    persona = request.args.get("persona")

    # BAD: user input is used directly in a system-level prompt
    response = client.chat.completions.create(
        model="gpt-4.1",
        messages=[
            {
                "role": "system",
                "content": "You are a helpful assistant. Act as a " + persona,
            },
            {
                "role": "user",
                "content": request.args.get("message"),
            },
        ],
    )

    return response
