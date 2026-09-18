from anthropic import Anthropic
from flask import Flask, request  # $ Source

app = Flask(__name__)
client = Anthropic()


@app.route("/anthropic")
def get_input_anthropic():
    persona = request.args.get("persona")
    query = request.args.get("query")

    response1 = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=256,
        system="Talk like " + persona,
        messages=[
            {
                "role": "user",
                "content": query,  # $ Alert[py/user-prompt-injection]
            }
        ],
    )
    print(response1)

    response2 = client.completions.create(
        model="claude-2.1",
        max_tokens_to_sample=256,
        prompt="\n\nHuman: " + query + "\n\nAssistant:",  # $ Alert[py/user-prompt-injection]
    )
    print(response2)
