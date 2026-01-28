from agents import Agent, Runner
from flask import Flask, request # $ Source
app = Flask(__name__)

@app.route("/parameter-route")
def get_input1():
    input = request.args.get("input")

    agent = Agent(name="Assistant", instructions="This prompt is customized for " + input) # $Alert[py/prompt-injection]

    result = Runner.run_sync(agent, "This is a user message.")
    print(result.final_output)


@app.route("/parameter-route")
def get_input2():
    input = request.args.get("input")

    agent = Agent(name="Assistant", instructions="This prompt is not customized.")
    result = Runner.run_sync(
        agent=agent,
        input=[
            {
                "role": "user",
                "content": input, # $Alert[py/prompt-injection]
            }
        ] 
    )

    result2 = Runner.run_sync(
        agent,
        [
            {
                "role": "user",
                "content": input, # $Alert[py/prompt-injection]
            }
        ] 
    )
