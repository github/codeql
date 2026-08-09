const express = require("express");
const OpenRouter = require("@openrouter/sdk");
const { OpenRouter: OpenRouterNamed } = require("@openrouter/sdk");
const { callModel, tool } = require("@openrouter/agent");
const { OpenRouter: OpenRouterAgent } = require("@openrouter/agent");

const app = express();
const client = new OpenRouter();
const namedClient = new OpenRouterNamed();

app.get("/test", async (req, res) => {
  const persona = req.query.persona; // $ Source
  const query = req.query.query;

  // === OpenRouter Client SDK: chat.send ===

  // messages with system role (SHOULD ALERT)
  const s1 = await client.chat.send({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "system",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
      {
        role: "user",
        content: query, // OK - user role
      },
    ],
  });

  // messages with developer role (SHOULD ALERT)
  const s2 = await client.chat.send({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "developer",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
    ],
  });

  // messages with content as array of content parts (SHOULD ALERT)
  const s3 = await client.chat.send({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "system",
        content: [
          {
            type: "text",
            text: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
          },
        ],
      },
    ],
  });

  // messages with user role (SHOULD NOT ALERT)
  const s4 = await client.chat.send({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "user",
        content: query, // OK - user role is expected to carry user input
      },
    ],
  });

  // === OpenRouter Client SDK: chat.completions.create (OpenAI-compatible) ===

  // messages with system role (SHOULD ALERT)
  const c1 = await namedClient.chat.completions.create({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "system",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
    ],
  });

  // === OpenRouter Agent SDK: callModel ===

  // instructions: tainted string (SHOULD ALERT)
  const a1 = await callModel({
    model: "openai/gpt-4o",
    instructions: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    input: "Hello",
  });

  // messages with system role (SHOULD ALERT)
  const a2 = await callModel({
    model: "openai/gpt-4o",
    messages: [
      {
        role: "system",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
    ],
  });

  // input array with developer role (SHOULD ALERT)
  const a3 = await callModel({
    model: "openai/gpt-4o",
    input: [
      {
        role: "developer",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
    ],
  });

  // instance form: new OpenRouter().callModel (SHOULD ALERT)
  const agent = new OpenRouterAgent();
  const a4 = await agent.callModel({
    model: "openai/gpt-4o",
    instructions: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    input: "Hello",
  });

  // tool description (SHOULD ALERT)
  const t1 = tool({
    name: "lookup",
    description: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    inputSchema: {},
    execute: async () => { },
  });

  // input array with user role (SHOULD NOT ALERT)
  const a5 = await callModel({
    model: "openai/gpt-4o",
    input: [
      {
        role: "user",
        content: query, // OK - user role
      },
    ],
  });

  res.send("ok");
});
