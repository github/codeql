from agents import Agent, FunctionTool, Runner
from flask import Flask, request  # $ Source

app = Flask(__name__)


@app.route("/agent")
def get_input_agent():
    persona = request.args.get("persona")
    topic = request.args.get("topic")

    tool = FunctionTool(
        name="lookup",
        description="Look up reference material about " + topic,  # $ Alert[py/system-prompt-injection]
        params_json_schema={},
        on_invoke_tool=lambda ctx, args: "...",
    )

    agent = Agent(
        name="Assistant",
        instructions="This prompt is customized for " + persona,  # $ Alert[py/system-prompt-injection]
        handoff_description="Hands off to " + persona,  # $ Alert[py/system-prompt-injection]
        tools=[tool],
    )

    agent_tool = agent.as_tool(
        tool_name="assistant",
        tool_description="Delegates to " + persona,  # $ Alert[py/system-prompt-injection]
    )
    print(agent_tool)

    result = Runner.run_sync(
        agent,
        [
            {
                "role": "system",
                "content": "Behave like " + persona,  # $ Alert[py/system-prompt-injection]
            },
            {
                "role": "user",
                "content": "A user message.",
            }
        ]
    )
    print(result.final_output)
