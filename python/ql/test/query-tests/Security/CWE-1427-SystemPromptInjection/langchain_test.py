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


@app.route("/langchain-create-agent")
def get_input_langchain_create_agent():
    from langchain.agents import create_agent

    persona = request.args.get("persona")

    create_agent("gpt-4.1", system_prompt="Talk like a " + persona)  # $ Alert[py/system-prompt-injection]


@app.route("/langchain-tool")
def get_input_langchain_tool():
    from langchain_core.tools import Tool, StructuredTool, tool

    persona = request.args.get("persona")

    Tool(
        "lookup",
        lambda x: x,
        "Talk like a " + persona,  # $ Alert[py/system-prompt-injection]
    )

    Tool.from_function(
        lambda x: x,
        "lookup",
        "Talk like a " + persona,  # $ Alert[py/system-prompt-injection]
    )

    StructuredTool(
        name="lookup",
        description="Talk like a " + persona,  # $ Alert[py/system-prompt-injection]
    )

    StructuredTool.from_function(
        lambda x: x,
        name="lookup",
        description="Talk like a " + persona,  # $ Alert[py/system-prompt-injection]
    )

    @tool(description="Talk like a " + persona)  # $ Alert[py/system-prompt-injection]
    def lookup(arg: str) -> str:
        return arg
