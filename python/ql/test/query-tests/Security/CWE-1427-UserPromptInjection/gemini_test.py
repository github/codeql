from google import genai
from google.genai import types
from flask import Flask, request  # $ Source

app = Flask(__name__)
client = genai.Client()


@app.route("/gemini")
def get_input_gemini():
    query = request.args.get("query")

    response1 = client.models.generate_content(
        model="gemini-2.0-flash",
        contents=query,  # $ Alert[py/user-prompt-injection]
    )

    response2 = client.models.generate_content(
        model="gemini-2.0-flash",
        contents=[
            {
                "role": "user",
                "parts": [
                    {
                        "text": query  # $ Alert[py/user-prompt-injection]
                    }
                ]
            }
        ],
    )

    chat = client.chats.create(model="gemini-2.0-flash")
    response3 = chat.send_message("Tell me about " + query)  # $ Alert[py/user-prompt-injection]

    response4 = client.models.edit_image(
        model="imagen-3.0-capability-001",
        prompt=query,  # $ Alert[py/user-prompt-injection]
    )

    cache = client.caches.create(
        model="gemini-2.0-flash",
        config=types.CreateCachedContentConfig(
            contents=query,  # $ Alert[py/user-prompt-injection]
        ),
    )
    print(response1, response2, response3, response4, cache)
