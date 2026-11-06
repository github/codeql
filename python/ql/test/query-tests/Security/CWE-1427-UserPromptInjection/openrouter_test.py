from openrouter import OpenRouter
from flask import Flask, request  # $ Source

app = Flask(__name__)
client = OpenRouter()


@app.route("/openrouter")
def get_input_openrouter():
    query = request.args.get("query")

    completion = client.chat.send(
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

    response = client.responses.send(
        model="openai/gpt-4.1",
        instructions="You are a helpful assistant.",
        input=query,  # $ Alert[py/user-prompt-injection]
    )

    embedding = client.embeddings.generate(
        model="openai/text-embedding-3-small",
        input=query,  # $ Alert[py/user-prompt-injection]
    )

    image = client.images.generate(
        model="openai/dall-e-3",
        prompt=query,  # $ Alert[py/user-prompt-injection]
    )

    video = client.video_generation.generate(
        model="openai/sora-2",
        prompt=query,  # $ Alert[py/user-prompt-injection]
    )

    speech = client.tts.create_speech(
        model="openai/gpt-4o-mini-tts",
        voice="alloy",
        input=query,  # $ Alert[py/user-prompt-injection]
    )
    print(completion, response, embedding, image, video, speech)
