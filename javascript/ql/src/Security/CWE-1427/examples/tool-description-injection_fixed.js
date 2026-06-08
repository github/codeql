const express = require("express");
const { z } = require("zod");
const { Agent, tool, run } = require("@openai/agents");

const app = express();

const ALLOWED_TOPICS = ["science", "history", "geography"];

app.get("/agent", async (req, res) => {
    let topic = req.query.topic;

    // GOOD: the tool description contains a fixed allowlist of permitted topics
    // and no user input, and the parameter is restricted to that allowlist
    const lookupTool = tool({
        name: "lookup",
        description:
            "Look up reference material about one of the following topics: " +
            ALLOWED_TOPICS.join(", "),
        parameters: z.object({
            topic: z.enum(ALLOWED_TOPICS),
        }),
        execute: async ({ topic }) => {
            if (!ALLOWED_TOPICS.includes(topic)) {
                throw new Error(`Unknown topic: ${topic}`);
            }

            return lookupReferenceMaterial(topic);
        },
    });

    const agent = new Agent({
        name: "assistant",
        instructions: "You are a research assistant that looks up reference material on various topics and answers user questions.",
        tools: [lookupTool],
    });
    const result = await run(agent, [
        // GOOD: the user-controlled topic is passed as part of the user input, so the model treats it as user content rather than as a trusted instruction.
        {
            role: "user",
            content: `The question: ${req.query.message}`,
        },
    ]);

    res.json(result);
});
