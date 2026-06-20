/**
 * Provides classes modeling security-relevant aspects of the OpenRouter JS/TS SDKs.
 * See https://openrouter.ai/docs/client-sdks/typescript (`@openrouter/sdk`) and
 * https://openrouter.ai/docs/agent-sdk/overview (`@openrouter/agent`).
 *
 * Structurally typed sinks (instructions, input, description, etc.) have been moved to
 * Models as Data: javascript/ql/lib/ext/openrouter.model.yml
 *
 * This file retains only role-filtered sinks that require inspecting a sibling
 * `role` property, which MaD cannot express.
 */

private import javascript

/** Holds if `msg` is a message array element with a privileged role. */
private predicate isSystemOrDevMessage(API::Node msg) {
  msg.getMember("role").asSink().mayHaveStringValue(["system", "developer", "assistant"])
}

/**
 * Provides models for the OpenRouter Client SDK (`@openrouter/sdk`).
 */
module OpenRouter {
  /** Gets a reference to an `@openrouter/sdk` client instance. */
  private API::Node clientRef() {
    // Default export: import OpenRouter from '@openrouter/sdk'; new OpenRouter()
    result = API::moduleImport("@openrouter/sdk").getInstance()
    or
    // Named import: import { OpenRouter } from '@openrouter/sdk'; new OpenRouter()
    result = API::moduleImport("@openrouter/sdk").getMember("OpenRouter").getInstance()
  }

  /** Gets the parameter object of a chat completion call. */
  private API::Node chatCreateParams() {
    // client.chat.send({ messages: [...] })
    result = clientRef().getMember("chat").getMember("send").getParameter(0)
    or
    // OpenAI-compatible surface: client.chat.completions.create({ messages: [...] })
    result =
      clientRef().getMember("chat").getMember("completions").getMember("create").getParameter(0)
  }

  /**
   * Gets role-filtered system/developer/assistant message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getSystemOrAssistantPromptNode() {
    // chat.send/completions.create({ messages: [{ role: "system"/"developer"/"assistant", content: ... }] })
    exists(API::Node msg, API::Node content |
      msg = chatCreateParams().getMember("messages").getArrayElement() and
      isSystemOrDevMessage(msg) and
      content = msg.getMember("content")
    |
      result = content
      or
      result = content.getArrayElement().getMember("text")
    )
  }

  /**
   * Gets role-filtered user message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getUserPromptNode() {
    // chat.send/completions.create({ messages: [{ role: "user", content: ... }] })
    exists(API::Node msg, API::Node content |
      msg = chatCreateParams().getMember("messages").getArrayElement() and
      not isSystemOrDevMessage(msg) and
      content = msg.getMember("content")
    |
      result = content
      or
      result = content.getArrayElement().getMember("text")
    )
  }
}

/**
 * Provides models for the OpenRouter Agent SDK (`@openrouter/agent`).
 *
 * Structurally typed sinks have been moved to openrouter.model.yml.
 * This module retains only role-filtered sinks that MaD cannot express.
 */
module OpenRouterAgent {
  /** Gets a reference to the `@openrouter/agent` module. */
  private API::Node moduleRef() { result = API::moduleImport("@openrouter/agent") }

  /** Gets a `callModel` invocation's parameter object (top-level and instance forms). */
  private API::Node callModelParams() {
    // import { callModel } from '@openrouter/agent'; callModel({ ... })
    result = moduleRef().getMember("callModel").getParameter(0)
    or
    // import { OpenRouter } from '@openrouter/agent'; new OpenRouter(...).callModel({ ... })
    result =
      moduleRef().getMember("OpenRouter").getInstance().getMember("callModel").getParameter(0)
  }

  /**
   * Gets role-filtered system/developer/assistant message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getSystemOrAssistantPromptNode() {
    // callModel({ messages/input: [{ role: "system"/"developer"/"assistant", content: ... }] })
    exists(API::Node msg |
      msg = callModelParams().getMember(["messages", "input"]).getArrayElement() and
      isSystemOrDevMessage(msg)
    |
      result = msg.getMember("content")
    )
  }

  /**
   * Gets role-filtered user message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getUserPromptNode() {
    // callModel({ messages/input: [{ role: "user", content: ... }] })
    exists(API::Node msg |
      msg = callModelParams().getMember(["messages", "input"]).getArrayElement() and
      not isSystemOrDevMessage(msg)
    |
      result = msg.getMember("content")
    )
  }
}
