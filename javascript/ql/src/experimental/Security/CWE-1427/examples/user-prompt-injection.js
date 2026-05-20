const express = require("express");
const OpenAI = require("openai");

const app = express();
const client = new OpenAI();

app.get("/chat", async (req, res) => {
    let topic = req.query.topic;

    // BAD: user input is used directly in a user-role prompt
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
