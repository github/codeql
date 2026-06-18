from google import genai
from google.genai import types
from flask import Flask, request  # $ Source

app = Flask(__name__)
client = genai.Client()


@app.route("/gemini")
def get_input_gemini():
    persona = request.args.get("persona")
    query = request.args.get("query")

    response1 = client.models.generate_content(
        model="gemini-2.0-flash",
        contents=[
            {
                "role": "model",
                "parts": [
                    {
                        "text": "I am " + persona  # $ Alert[py/system-prompt-injection]
                    }
                ]
            },
            {
                "role": "user",
                "parts": [
                    {
                        "text": query
                    }
                ]
            }
        ],
        config=types.GenerateContentConfig(
            system_instruction="Talk like " + persona,  # $ Alert[py/system-prompt-injection]
        ),
    )
    print(response1)
