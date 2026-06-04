const express = require("express");
const OpenAI = require("openai");
const { AzureOpenAI } = require("openai");
const { Agent, run, Runner, tool } = require("@openai/agents");

const app = express();
const client = new OpenAI();
const azureClient = new AzureOpenAI();

app.get("/test", async (req, res) => {
  const persona = req.query.persona;
  const query = req.query.query;

  // === OpenAI Responses API ===

  // instructions: tainted string (SHOULD ALERT)
  const r1 = await client.responses.create({
    model: "gpt-4.1",
    instructions: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    input: "Hello",
  });

  // input as array with system role (SHOULD ALERT)
  const r2 = await client.responses.create({
    model: "gpt-4.1",
    input: [
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

  // input as array with developer role (SHOULD ALERT)
  const r3 = await client.responses.create({
    model: "gpt-4.1",
    input: [
      {
        role: "developer",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
    ],
  });

  // input as array with user role (SHOULD NOT ALERT)
  const r4 = await client.responses.create({
    model: "gpt-4.1",
    input: [
      {
        role: "user",
        content: query, // OK - user role is expected to carry user input
      },
    ],
  });

  // === Chat Completions API ===

  // messages with system role (SHOULD ALERT)
  const c1 = await client.chat.completions.create({
    model: "gpt-4.1",
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
  const c2 = await client.chat.completions.create({
    model: "gpt-4.1",
    messages: [
      {
        role: "developer",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
    ],
  });

  // messages with content as array of content parts (SHOULD ALERT)
  const c3 = await client.chat.completions.create({
    model: "gpt-4.1",
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

  // Azure client (SHOULD ALERT)
  const c4 = await azureClient.chat.completions.create({
    model: "gpt-4.1",
    messages: [
      {
        role: "developer",
        content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
      },
    ],
  });

  // === Legacy Completions API ===

  // prompt (SHOULD ALERT)
  const l1 = await client.completions.create({
    model: "gpt-3.5-turbo-instruct",
    prompt: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === Images API ===

  // images.generate (SHOULD ALERT)
  const i1 = await client.images.generate({
    prompt: "Draw a picture of " + persona, // $ Alert[js/system-prompt-injection]
  });

  // images.edit (SHOULD ALERT)
  const i2 = await client.images.edit({
    prompt: "Edit to look like " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === Assistants API (beta) ===

  // assistants.create (SHOULD ALERT)
  const a1 = await client.beta.assistants.create({
    name: "Test Agent",
    model: "gpt-4.1",
    instructions: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // assistants.update (SHOULD ALERT)
  await client.beta.assistants.update("asst_123", {
    instructions: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // threads.runs.create (SHOULD ALERT)
  const tr1 = await client.beta.threads.runs.create("thread_123", {
    assistant_id: "asst_123",
    instructions: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // threads.runs.create with additional_instructions (SHOULD ALERT)
  const tr2 = await client.beta.threads.runs.create("thread_123", {
    assistant_id: "asst_123",
    additional_instructions: "Also talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // threads.messages.create with system role (SHOULD ALERT)
  await client.beta.threads.messages.create("thread_123", {
    role: "system",
    content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // threads.messages.create with user role (SHOULD NOT ALERT)
  await client.beta.threads.messages.create("thread_123", {
    role: "user",
    content: query, // OK - user role
  });

  // === Audio API ===

  // audio.transcriptions.create (SHOULD ALERT)
  const at1 = await client.audio.transcriptions.create({
    file: "audio.mp3",
    model: "whisper-1",
    prompt: "Transcribe about " + persona, // $ Alert[js/system-prompt-injection]
  });

  // audio.translations.create (SHOULD ALERT)
  const atl1 = await client.audio.translations.create({
    file: "audio.mp3",
    model: "whisper-1",
    prompt: "Translate about " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === Object assigned to variable first ===

  // Should still be caught via data flow
  const opts = { instructions: "Talk like a " + persona }; // $ Alert[js/system-prompt-injection]
  const r5 = await client.responses.create(opts);

  // === Sanitizer: constant comparison ===

  // Should NOT alert - guarded by constant comparison
  if (persona === "pirate") {
    const r6 = await client.responses.create({
      model: "gpt-4.1",
      instructions: "Talk like a " + persona, // OK - sanitized by constant check
      input: "Hello",
    });
  }

  res.send("done");
});
