const express = require("express");
const OpenRouter = require("@openrouter/sdk");
const { OpenRouter: OpenRouterNamed } = require("@openrouter/sdk");
const { callModel } = require("@openrouter/agent");
const { OpenRouter: OpenRouterAgent } = require("@openrouter/agent");

const app = express();
const client = new OpenRouter();
const namedClient = new OpenRouterNamed();

app.get("/test", async (req, res) => {
  const userInput = req.query.userInput;

  // === OpenRouter Client SDK: chat.send ===

  // messages with user role (SHOULD ALERT)
  await client.chat.send({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // messages with user role, content parts (SHOULD ALERT)
  await client.chat.send({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "user",
        content: [
          {
            type: "text",
            text: userInput, // $ Alert[js/user-prompt-injection]
          },
        ],
      },
    ],
  });

  // === OpenRouter Client SDK: chat.completions.create (OpenAI-compatible) ===

  await namedClient.chat.completions.create({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // === OpenRouter Client SDK: embeddings ===

  await client.embeddings.create({
    model: "openai/text-embedding-3-small",
    input: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === OpenRouter Agent SDK: callModel ===

  // input as string (SHOULD ALERT)
  await callModel({
    model: "openai/gpt-4o",
    instructions: "You are a helpful assistant",
    input: userInput, // $ Alert[js/user-prompt-injection]
  });

  // input array with user role (SHOULD ALERT)
  await callModel({
    model: "openai/gpt-4o",
    input: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // messages with user role (SHOULD ALERT)
  await callModel({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // instance form: new OpenRouter().callModel (SHOULD ALERT)
  const agent = new OpenRouterAgent();
  await agent.callModel({
    model: "openai/gpt-4o",
    input: userInput, // $ Alert[js/user-prompt-injection]
  });

  res.send("ok");
});
