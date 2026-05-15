const express = require("express");
const OpenAI = require("openai");
const { AzureOpenAI } = require("openai");
const {
  GuardrailsOpenAI,
  GuardrailsAzureOpenAI,
} = require("@openai/guardrails");
const { Agent, run, Runner } = require("@openai/agents");

const app = express();
const client = new OpenAI();
const azureClient = new AzureOpenAI();

app.get("/test", async (req, res) => {
  const userInput = req.query.userInput;

  // === Bare OpenAI client: user prompt sinks (SHOULD ALERT) ===

  // responses.create input as string
  await client.responses.create({
    model: "gpt-4.1",
    instructions: "You are a helpful assistant",
    input: userInput, // $ Alert[js/user-prompt-injection]
  });

  // responses.create input as array with user role
  await client.responses.create({
    model: "gpt-4.1",
    input: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // chat.completions.create with user role
  await client.chat.completions.create({
    model: "gpt-4.1",
    messages: [
      {
        role: "user",
        content: userInput, // $ Alert[js/user-prompt-injection]
      },
    ],
  });

  // chat.completions.create with user role content parts
  await client.chat.completions.create({
    model: "gpt-4.1",
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

  // Legacy completions API
  await client.completions.create({
    model: "gpt-3.5-turbo-instruct",
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  // Images API
  await client.images.generate({
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  await client.images.edit({
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  // Audio API
  await client.audio.transcriptions.create({
    file: "audio.mp3",
    model: "whisper-1",
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  await client.audio.translations.create({
    file: "audio.mp3",
    model: "whisper-1",
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  // beta.threads.messages.create with user role
  await client.beta.threads.messages.create("thread_123", {
    role: "user",
    content: userInput, // $ Alert[js/user-prompt-injection]
  });

  // Azure client (SHOULD ALERT)
  await azureClient.responses.create({
    model: "gpt-4.1",
    input: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === GuardrailsOpenAI client: user prompt sinks (SHOULD NOT ALERT) ===

  const guardedClient = await GuardrailsOpenAI.create({
    version: 1,
    input: { guardrails: [{ name: "prompt_injection_detection" }] },
  });

  // Guarded client — responses.create input as string (OK)
  await guardedClient.responses.create({
    model: "gpt-4.1",
    input: userInput, // OK - guarded client with input guardrails
  });

  // Guarded client — chat.completions.create with user role (OK)
  await guardedClient.chat.completions.create({
    model: "gpt-4.1",
    messages: [
      {
        role: "user",
        content: userInput, // OK - guarded client with input guardrails
      },
    ],
  });

  // Guarded Azure client (OK)
  const guardedAzure = await GuardrailsAzureOpenAI.create({
    version: 1,
    pre_flight: { guardrails: [{ name: "prompt_injection_detection" }] },
  });

  await guardedAzure.responses.create({
    model: "gpt-4.1",
    input: userInput, // OK - guarded Azure client with pre_flight guardrails
  });

  // === Unprotected GuardrailsOpenAI: no input guardrails (SHOULD ALERT) ===

  const unprotected = await GuardrailsOpenAI.create({
    version: 1,
    output: { guardrails: [{ name: "moderation" }] },
  });

  await unprotected.responses.create({
    model: "gpt-4.1",
    input: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === Constant comparison sanitizer (SHOULD NOT ALERT) ===

  const userInput3 = req.query.userInput3;
  if (userInput3 === "hello") {
    await client.responses.create({
      model: "gpt-4.1",
      input: userInput3, // OK - sanitized by constant comparison
    });
  }

  // === System/developer role messages should NOT be user prompt sinks ===

  // These are system prompt injection sinks, not user prompt sinks
  await client.responses.create({
    model: "gpt-4.1",
    input: [
      {
        role: "system",
        content: userInput, // OK for user-prompt-injection (this is a system prompt sink)
      },
    ],
  });

  await client.chat.completions.create({
    model: "gpt-4.1",
    messages: [
      {
        role: "developer",
        content: userInput, // OK for user-prompt-injection (this is a system prompt sink)
      },
    ],
  });

  // === Agent SDK: run() user prompt sinks (SHOULD ALERT) ===

  const agent = new Agent({
    name: "Assistant",
    instructions: "You are a helpful assistant",
  });

  // run() with string input (user prompt)
  await run(agent, userInput); // $ Alert[js/user-prompt-injection]

  // run() with user-role array message
  await run(agent, [
    { role: "user", content: userInput }, // $ Alert[js/user-prompt-injection]
  ]);

  // Runner instance with string input
  const runner = new Runner();
  await runner.run(agent, userInput); // $ Alert[js/user-prompt-injection]

  // Runner instance with user-role array message
  await runner.run(agent, [
    { role: "user", content: userInput }, // $ Alert[js/user-prompt-injection]
  ]);

  // === Agent SDK: system/developer role in run() (SHOULD NOT ALERT for user-prompt) ===

  await run(agent, [
    { role: "system", content: userInput }, // OK for user-prompt-injection (system prompt sink)
  ]);

  await run(agent, [
    { role: "developer", content: userInput }, // OK for user-prompt-injection (system prompt sink)
  ]);

  res.send("done");
});
