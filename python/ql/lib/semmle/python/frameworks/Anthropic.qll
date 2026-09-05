/**
 * Provides classes modeling security-relevant aspects of the `anthropic` package.
 * See https://github.com/anthropics/anthropic-sdk-python.
 *
 * Structurally typed sinks (the `system` field) are modeled via Models as Data:
 * python/ql/lib/semmle/python/frameworks/anthropic.model.yml
 *
 * This file retains only role-filtered message sinks that require inspecting a
 * sibling `role` key, which MaD cannot express.
 */

private import python
private import semmle.python.ApiGraphs

/** Provides classes modeling prompt-injection sinks of the `anthropic` package. */
module Anthropic {
  /** Gets a reference to an `anthropic.Anthropic` client instance. */
  private API::Node classRef() {
    result = API::moduleImport("anthropic").getMember(["Anthropic", "AsyncAnthropic"]).getReturn()
  }

  /** Gets the message dictionaries passed to `messages.create`/`messages.stream` (stable and beta). */
  private API::Node messageElement() {
    exists(API::Node create |
      create = classRef().getMember("messages").getMember(["create", "stream"])
      or
      create = classRef().getMember("beta").getMember("messages").getMember(["create", "stream"])
    |
      result = create.getKeywordParameter("messages").getASubscript()
    )
  }

  /**
   * Gets role-filtered system/assistant message content sinks that MaD cannot express.
   */
  API::Node getSystemOrAssistantPromptNode() {
    exists(API::Node msg |
      msg = messageElement() and
      msg.getSubscript("role").getAValueReachingSink().asExpr().(StringLiteral).getText() =
        ["system", "assistant"]
    |
      result = msg.getSubscript("content")
    )
  }

  /**
   * Gets role-filtered user message content sinks that MaD cannot express.
   */
  API::Node getUserPromptNode() {
    exists(API::Node msg |
      msg = messageElement() and
      not msg.getSubscript("role").getAValueReachingSink().asExpr().(StringLiteral).getText() =
        ["system", "assistant"]
    |
      result = msg.getSubscript("content")
    )
  }
}
