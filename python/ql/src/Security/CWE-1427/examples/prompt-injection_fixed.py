from flask import Flask, request
from openai import OpenAI

app = Flask(__name__)
client = OpenAI()

ALLOWED_PERSONAS = ["pirate", "teacher", "poet"]


@app.get("/chat")
def chat():
    persona = request.args.get("persona")

    # GOOD: user input is validated against a fixed allowlist before use in a prompt
    if persona not in ALLOWED_PERSONAS:
        return {"error": "Invalid persona"}, 400

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
