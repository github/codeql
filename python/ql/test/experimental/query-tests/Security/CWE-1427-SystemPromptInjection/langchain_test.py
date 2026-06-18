from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
from flask import Flask, request  # $ Source

app = Flask(__name__)


@app.route("/langchain")
def get_input_langchain():
    persona = request.args.get("persona")
    query = request.args.get("query")

    model = ChatOpenAI(model="gpt-4.1")

    result = model.invoke(
        [
            SystemMessage(content="Talk like a " + persona),  # $ Alert[py/system-prompt-injection]
            HumanMessage(content=query),
        ]
    )
    print(result)
