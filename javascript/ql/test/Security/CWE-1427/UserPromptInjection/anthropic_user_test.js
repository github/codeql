const express = require("express");
const Anthropic = require("@anthropic-ai/sdk");

const app = express();
const client = new Anthropic();

app.get("/test", async (req, res) => {
  const userInput = req.query.userInput;

  // === User role message (SHOULD ALERT) ===

  await client.messages.create({
    model: "claude-sonnet-4-20250514",
    max_tokens: 1024,
    messages: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // === Beta messages (SHOULD ALERT) ===

  await client.beta.messages.create({
    model: "claude-sonnet-4-20250514",
    max_tokens: 1024,
    messages: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // === Constant comparison sanitizer (SHOULD NOT ALERT) ===

  const userInput2 = req.query.userInput2;
  if (userInput2 === "hello") {
    await client.messages.create({
      model: "claude-sonnet-4-20250514",
      max_tokens: 1024,
      messages: [
        {
          role: "user",
          content: userInput2, // OK - sanitized by constant comparison
        },
      ],
    });
  }

  res.send("done");
});
