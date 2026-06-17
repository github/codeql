const express = require("express");
const { Agent, run, Runner, tool } = require("@openai/agents");
const { z } = require("zod");

const app = express();

app.get("/agents", async (req, res) => {
  const persona = req.query.persona; // $ Source
  const query = req.query.query;

  // === Agent constructor: instructions as string ===

  // SHOULD ALERT
  const agent1 = new Agent({
    name: "Assistant",
    instructions: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === Agent constructor: instructions as lambda ===

  // SHOULD ALERT
  const agent2 = new Agent({
    name: "Dynamic",
    instructions: (runContext) => {
      return "Talk like a " + persona; // $ Alert[js/system-prompt-injection]
    },
  });

  // SHOULD ALERT (async lambda)
  const agent3 = new Agent({
    name: "AsyncDynamic",
    instructions: async (runContext) => {
      return "Talk like a " + persona;
    }, // $ Alert[js/system-prompt-injection]
  });

  // === Agent constructor: handoffDescription ===

  // SHOULD ALERT
  const agent4 = new Agent({
    name: "Specialist",
    instructions: "Help with refunds",
    handoffDescription: "Handles " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === agent.asTool(): toolDescription ===

  // SHOULD ALERT
  agent1.asTool({
    toolName: "helper",
    toolDescription: "Ask about " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === tool(): description ===

  // SHOULD ALERT
  const myTool = tool({
    name: "lookup",
    description: "Look up info about " + persona, // $ Alert[js/system-prompt-injection]
    parameters: z.object({ query: z.string() }),
    execute: async ({ query }) => "result",
  });

  // === run() with string input ===

  // SHOULD NOT ALERT - string input to run() is a user prompt, not system prompt
  const r1 = await run(agent1, query); // OK - user prompt sink

  // === run() with array input: system role ===

  // SHOULD ALERT
  const r2 = await run(agent1, [
    { role: "system", content: "Talk like a " + persona }, // $ Alert[js/system-prompt-injection]
    { role: "user", content: query },
  ]);

  // === run() with array input: developer role ===

  // SHOULD ALERT
  const r3 = await run(agent1, [
    { role: "developer", content: "Talk like a " + persona }, // $ Alert[js/system-prompt-injection]
  ]);

  // === run() with array input: user role ===

  // SHOULD NOT ALERT
  const r4 = await run(agent1, [
    { role: "user", content: query }, // OK - user role
  ]);

  // === Runner instance: run() with system role ===

  // SHOULD ALERT
  const runner = new Runner();
  const r5 = await runner.run(agent1, [
    { role: "system", content: "Talk like a " + persona }, // $ Alert[js/system-prompt-injection]
  ]);

  // === Sanitizer: constant comparison ===

  // SHOULD NOT ALERT
  if (persona === "pirate") {
    const agent5 = new Agent({
      name: "Pirate",
      instructions: "Talk like a " + persona, // OK - sanitized by constant check
    });
  }

  res.send("done");
});
