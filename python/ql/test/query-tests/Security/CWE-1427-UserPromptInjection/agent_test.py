from agents import Agent, Runner
from flask import Flask, request  # $ Source

app = Flask(__name__)


@app.route("/agent")
def get_input_agent():
    query = request.args.get("query")

    agent = Agent(name="Assistant", instructions="A fixed prompt.")

    result1 = Runner.run_sync(agent, query)  # $ Alert[py/user-prompt-injection]

    result2 = Runner.run_sync(
        agent=agent,
        input=[
            {
                "role": "user",
                "content": query,  # $ Alert[py/user-prompt-injection]
            }
        ]
    )
    print(result1, result2)
