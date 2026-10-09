from flask import Flask, request
from openai import OpenAI

app = Flask(__name__)
client = OpenAI()


@app.get("/chat")
def chat():
    topic = request.args.get("topic")

    # BAD: user input is used directly in a user-role prompt
    response = client.chat.completions.create(
        model="gpt-4.1",
        messages=[
            {
                "role": "system",
                "content": "You are a helpful assistant that summarizes topics.",
            },
            {
                "role": "user",
                "content": "Summarize the following topic: " + topic,
            },
        ],
    )

    return response
