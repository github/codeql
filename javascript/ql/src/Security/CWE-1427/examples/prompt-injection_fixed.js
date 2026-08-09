const express = require("express");
const OpenAI = require("openai");

const app = express();
const client = new OpenAI();

const ALLOWED_PERSONAS = ["pirate", "teacher", "poet"];

app.get("/chat", async (req, res) => {
    let persona = req.query.persona;

    // GOOD: user input is validated against a fixed allowlist before use in a prompt
    if (!ALLOWED_PERSONAS.includes(persona)) {
        return res.status(400).json({ error: "Invalid persona" });
    }

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
