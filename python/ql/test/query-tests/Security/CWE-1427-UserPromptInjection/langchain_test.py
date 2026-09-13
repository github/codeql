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


@app.route("/langchain-providers")
def get_input_langchain_providers():
    from langchain_fireworks import ChatFireworks
    from langchain_together import ChatTogether
    from langchain_xai import ChatXAI
    from langchain.chat_models import init_chat_model

    query = request.args.get("query")

    ChatFireworks().invoke(query)  # $ Alert[py/user-prompt-injection]
    ChatTogether().invoke(query)  # $ Alert[py/user-prompt-injection]
    ChatXAI().invoke(query)  # $ Alert[py/user-prompt-injection]
    init_chat_model("gpt-4.1").invoke(query)  # $ Alert[py/user-prompt-injection]

    model = ChatOpenAI(model="gpt-4.1")
    model.generate([[query]])  # $ Alert[py/user-prompt-injection]


@app.route("/langchain-prompts")
def get_input_langchain_prompts():
    from langchain_core.prompts import PromptTemplate

    query = request.args.get("query")

    template = PromptTemplate(template="Answer: {question}", input_variables=["question"])
    template.format(question=query)  # $ Alert[py/user-prompt-injection]


@app.route("/langchain-chains")
def get_input_langchain_chains():
    from langchain.chains import LLMChain
    from langchain.agents import AgentExecutor, create_agent

    query = request.args.get("query")

    chain = LLMChain()
    chain.invoke({"input": query})  # $ Alert[py/user-prompt-injection]
    chain.run(query)  # $ Alert[py/user-prompt-injection]

    executor = AgentExecutor()
    executor.invoke({"input": query})  # $ Alert[py/user-prompt-injection]

    agent = create_agent("gpt-4.1")
    agent.invoke({"messages": [{"role": "user", "content": query}]})  # $ Alert[py/user-prompt-injection]
