from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
from flask import Flask, request  # $ Source

app = Flask(__name__)


@app.route("/langchain")
def get_input_langchain():
    query = request.args.get("query")

    model = ChatOpenAI(model="gpt-4.1")

    result1 = model.invoke(
        [
            SystemMessage(content="You are a helpful assistant."),
            HumanMessage(content=query),  # $ Alert[py/user-prompt-injection]
        ]
    )

    result2 = model.invoke("Tell me about " + query)  # $ Alert[py/user-prompt-injection]
    print(result1, result2)
