from flask import Flask, request
from agents import Agent, FunctionTool, Runner

app = Flask(__name__)


@app.get("/agent")
def agent_route():
    topic = request.args.get("topic")

    # BAD: user input is used in the description of a tool exposed to the agent
    lookup_tool = FunctionTool(
        name="lookup",
        description="Look up reference material about " + topic,
        params_json_schema={},
        on_invoke_tool=lambda ctx, args: "...",
    )

    agent = Agent(
        name="assistant",
        instructions="You are a research assistant that looks up reference material on various topics and answers user questions.",
        tools=[lookup_tool],
    )

    result = Runner.run_sync(agent, request.args.get("message"))

    return result.final_output
