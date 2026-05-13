/**
 * Provides classes modeling security-relevant aspects of the `@anthropic-ai/sdk` package.
 * See https://github.com/anthropics/anthropic-sdk-typescript
 *
 * Structurally typed sinks (system, beta.agents) have been moved to
 * Models as Data: javascript/ql/lib/ext/anthropic.model.yml
 *
 * This file retains only role-filtered message sinks that require inspecting
 * a sibling `role` property, which MaD cannot express.
 */

private import javascript

module Anthropic {
  /** Gets a reference to the `Anthropic` client instance. */
  private API::Node classRef() {
    result = API::moduleImport("@anthropic-ai/sdk").getInstance()
  }

  /** Gets a reference to the messages.create params (both stable and beta). */
  private API::Node messagesCreateParams() {
    result = classRef().getMember("messages").getMember("create").getParameter(0)
    or
    result =
      classRef().getMember("beta").getMember("messages").getMember("create").getParameter(0)
  }

  /**
   * Gets role-filtered system/assistant message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getSystemOrAssistantPromptNode() {
    // messages: [{ role: "assistant", content: "..." }]
    exists(API::Node msg |
      msg = messagesCreateParams().getMember("messages").getArrayElement() and
      msg.getMember("role").asSink().mayHaveStringValue("assistant")
    |
      result = msg.getMember("content")
    )
  }

  /**
   * Gets role-filtered user message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getUserPromptNode() {
    // messages: [{ role: "user", content: "..." }]
    exists(API::Node msg |
      msg = messagesCreateParams().getMember("messages").getArrayElement() and
      not msg.getMember("role").asSink().mayHaveStringValue("assistant")
    |
      result = msg.getMember("content")
    )
  }
}