const express = require("express");
const OpenAI = require("openai");

const app = express();
const client = new OpenAI();

app.get("/chat", async (req, res) => {
    let persona = req.query.persona;

    // BAD: user input is used directly in a system-level prompt
    const response = await client.chat.completions.create({
        model: "gpt-4.1",
        messages: [
            {
                role: "system",
                content: "You are a helpful assistant. Act as a " + persona,
            },
            {
                role: "user",
                content: req.query.message,
            },
        ],
    });

    res.json(response);
});