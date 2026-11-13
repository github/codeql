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
        ]  # $ Alert[py/user-prompt-injection]
    )

    other_messages = request.json  # tainted list of messages
    result3 = Runner.run_sync(
        agent,
        [{"role": "system", "content": "hi"}] + other_messages  # $ Alert[py/user-prompt-injection]
    )

    result4 = Runner.run_sync(
        agent,
        [{"role": "system", "content": "hi"}, {"role": "user", "content": query}] + other_messages  # $ Alert[py/user-prompt-injection]
    )

    print(result1, result2, result3, result4)
