from agents import Agent, Runner
from flask import Flask, request # $ Source=flask
app = Flask(__name__)

@app.route("/parameter-route")
def get_input():
    input = request.args.get("input")

    agent = Agent(name="Assistant", instructions="This prompt is customized for " + input) # $Alert[py/prompt-injection]

    result = Runner.run_sync(agent, "This is a user message.")
    print(result.final_output)
