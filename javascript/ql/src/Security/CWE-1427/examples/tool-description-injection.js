const express = require("express");
const { Agent, tool, run } = require("@openai/agents");

const app = express();

app.get("/agent", async (req, res) => {
    let topic = req.query.topic;

    // BAD: user input is used in the description of a tool exposed to the agent
    const lookupTool = tool({
        name: "lookup",
        description: "Look up reference material about " + topic,
        parameters: {},
        execute: async () => {
            return "...";
        },
    });

    const agent = new Agent({
        name: "assistant",
        instructions: "You are a research assistant that looks up reference material on various topics and answers user questions.",
        tools: [lookupTool],
    });

    const result = await run(agent, req.query.message);

    res.json(result);
});
