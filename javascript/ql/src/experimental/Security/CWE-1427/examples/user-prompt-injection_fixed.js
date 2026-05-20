const express = require("express");
const OpenAI = require("openai");

const app = express();
const client = new OpenAI();

const ALLOWED_TOPICS = ["science", "history", "technology"];

app.get("/chat", async (req, res) => {
    let topic = req.query.topic;

    // GOOD: user input is validated against a fixed allowlist before use in a prompt
    if (!ALLOWED_TOPICS.includes(topic)) {
        return res.status(400).json({ error: "Invalid topic" });
    }

    const response = await client.chat.completions.create({
        model: "gpt-4.1",
        messages: [
            {
                role: "system",
                content: "You are a helpful assistant that summarizes topics.",
            },
            {
                role: "user",
                content: "Summarize the following topic: " + topic,
            },
        ],
    });

    res.json(response);
});
