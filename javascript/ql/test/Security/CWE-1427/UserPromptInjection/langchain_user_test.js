const express = require("express");
const { ChatOpenAI } = require("@langchain/openai");
const { ChatAnthropic } = require("@langchain/anthropic");
const { HumanMessage, SystemMessage } = require("@langchain/core/messages");
const { AgentExecutor } = require("langchain/agents");
const { LLMChain } = require("langchain/chains");
const { ChatPromptTemplate, PromptTemplate } = require("@langchain/core/prompts");
const { createAgent, initChatModel } = require("langchain");

const app = express();

app.get("/test", async (req, res) => {
  const userInput = req.query.userInput;

  // === ChatModel.invoke (SHOULD ALERT) ===

  const chatModel = new ChatOpenAI({ model: "gpt-4" });
  await chatModel.invoke(userInput); // $ Alert[js/user-prompt-injection]

  // === ChatModel.stream (SHOULD ALERT) ===

  await chatModel.stream(userInput); // $ Alert[js/user-prompt-injection]

  // === ChatModel.call (SHOULD ALERT) ===

  await chatModel.call(userInput); // $ Alert[js/user-prompt-injection]

  // === ChatModel.predict (SHOULD ALERT) ===

  await chatModel.predict(userInput); // $ Alert[js/user-prompt-injection]

  // === ChatModel.batch (SHOULD ALERT) ===

  await chatModel.batch([userInput]); // $ Alert[js/user-prompt-injection]

  // === ChatModel.generate (SHOULD ALERT) ===

  await chatModel.generate([[userInput]]); // $ Alert[js/user-prompt-injection]

  // === HumanMessage (SHOULD ALERT) ===

  const msg1 = new HumanMessage(userInput); // $ Alert[js/user-prompt-injection]

  const msg2 = new HumanMessage({ content: userInput }); // $ Alert[js/user-prompt-injection]

  // === ChatAnthropic via type model (SHOULD ALERT) ===

  const anthropicModel = new ChatAnthropic({ model: "claude-sonnet-4-20250514" });
  await anthropicModel.invoke(userInput); // $ Alert[js/user-prompt-injection]

  // === initChatModel via type model (SHOULD ALERT) ===

  const dynamicModel = await initChatModel();
  await dynamicModel.invoke(userInput); // $ Alert[js/user-prompt-injection]

  // === AgentExecutor.invoke (SHOULD ALERT) ===

  const executor = new AgentExecutor();
  await executor.invoke({ input: userInput }); // $ Alert[js/user-prompt-injection]

  // === createAgent().invoke with messages (SHOULD ALERT) ===

  const agent = createAgent();
  await agent.invoke({
    messages: [{ content: userInput }], // $ Alert[js/user-prompt-injection]
  });

  // === createAgent().stream with messages (SHOULD ALERT) ===

  await agent.stream({
    messages: [{ content: userInput }], // $ Alert[js/user-prompt-injection]
  });

  // === LLMChain.call (SHOULD ALERT) ===

  const chain = new LLMChain();
  await chain.call({ input: userInput }); // $ Alert[js/user-prompt-injection]

  // === LLMChain.invoke (SHOULD ALERT) ===

  await chain.invoke({ input: userInput }); // $ Alert[js/user-prompt-injection]

  // === ChatPromptTemplate.fromMessages (SHOULD ALERT) ===

  ChatPromptTemplate.fromMessages([[userInput]]); // $ Alert[js/user-prompt-injection]

  // === PromptTemplate.format (SHOULD ALERT) ===

  const tmpl = new PromptTemplate();
  await tmpl.format(userInput); // $ Alert[js/user-prompt-injection]

  // === SystemMessage should NOT alert for user-prompt-injection ===

  const sysMsg = new SystemMessage(userInput); // OK - system prompt sink, not user prompt

  const sysMsg2 = new SystemMessage({ content: userInput }); // OK - system prompt sink

  // === Constant comparison sanitizer (SHOULD NOT ALERT) ===

  const userInput2 = req.query.userInput2;
  if (userInput2 === "hello") {
    await chatModel.invoke(userInput2); // OK - sanitized by constant comparison
  }

  res.send("done");
});
