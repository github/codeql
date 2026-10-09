from flask import Flask, request
from agents import Agent, FunctionTool, Runner

app = Flask(__name__)

ALLOWED_TOPICS = ["science", "history", "geography"]


@app.get("/agent")
def agent_route():
    # GOOD: the tool description contains a fixed allowlist of permitted topics
    # and no user input
    lookup_tool = FunctionTool(
        name="lookup",
        description="Look up reference material about one of the following topics: "
        + ", ".join(ALLOWED_TOPICS),
        params_json_schema={},
        on_invoke_tool=lambda ctx, args: "...",
    )

    agent = Agent(
        name="assistant",
        instructions="You are a research assistant that looks up reference material on various topics and answers user questions.",
        tools=[lookup_tool],
    )

    result = Runner.run_sync(
        agent,
        [
            # GOOD: the user-controlled topic is passed as part of the user input, so the
            # model treats it as user content rather than as a trusted instruction.
            {
                "role": "user",
                "content": "The question: " + request.args.get("message"),
            }
        ],
    )

    return result.final_output
