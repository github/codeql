const express = require("express");
const { ChatOpenAI } = require("@langchain/openai");
const { HumanMessage, SystemMessage } = require("@langchain/core/messages");
const { createAgent } = require("langchain");

const app = express();

app.get("/test", async (req, res) => {
  const persona = req.query.persona; // $ Source
  const query = req.query.query;

  const chatModel = new ChatOpenAI({ model: "gpt-4" });

  // === SystemMessage (SHOULD ALERT) ===

  const sysMsg1 = new SystemMessage("Talk like a " + persona); // $ Alert[js/system-prompt-injection]

  const sysMsg2 = new SystemMessage({
    content: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === createAgent with systemPrompt (SHOULD ALERT) ===

  const agent = createAgent({
    systemPrompt: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === Barrier test: user role content in shared array (SHOULD NOT ALERT) ===
  // When user input goes into a HumanMessage alongside a SystemMessage,
  // the system prompt query should NOT alert on the HumanMessage content.

  await chatModel.invoke([
    new SystemMessage("You are a helpful assistant"),
    new HumanMessage({ role: "user", content: query }), // OK - user role content is not a system prompt
  ]);

  // Same pattern with raw message objects passed to invoke
  await chatModel.invoke([
    { role: "system", content: "You are a helpful assistant" },
    { role: "user", content: query }, // OK - user role content blocked by barrier
  ]);

  // === Constant comparison sanitizer (SHOULD NOT ALERT) ===

  if (persona === "pirate") {
    const sysMsg3 = new SystemMessage("Talk like a " + persona); // OK - sanitized
  }

  res.send("done");
});
