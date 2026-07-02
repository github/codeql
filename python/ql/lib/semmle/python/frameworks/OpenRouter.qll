/**
 * Provides classes modeling security-relevant aspects of the OpenRouter Python SDK.
 * See https://openrouter.ai/docs.
 *
 * This file retains only role-filtered message sinks that require inspecting a
 * sibling `role` key, which MaD cannot express.
 */

private import python
private import semmle.python.ApiGraphs

/** Holds if `msg` is a message dictionary with a privileged (system/developer/assistant) role. */
private predicate isSystemOrDevMessage(API::Node msg) {
  msg.getSubscript("role").getAValueReachingSink().asExpr().(StringLiteral).getText() =
    ["system", "developer", "assistant"]
}

/** Provides classes modeling prompt-injection sinks of the `openrouter` package. */
module OpenRouter {
  /** Gets a reference to an `openrouter.OpenRouter` client instance. */
  private API::Node clientRef() {
    result = API::moduleImport("openrouter").getMember("OpenRouter").getReturn()
  }

  /** Gets the message dictionaries passed to `chat.send`. */
  private API::Node chatMessage() {
    result =
      clientRef()
          .getMember("chat")
          .getMember("send")
          .getKeywordParameter("messages")
          .getASubscript()
  }

  /** Gets the content sink of a message dictionary, including the `text` of structured content. */
  private API::Node messageContent(API::Node msg) {
    result = msg.getSubscript("content")
    or
    result = msg.getSubscript("content").getASubscript().getSubscript("text")
  }

  /**
   * Gets role-filtered system/developer/assistant message content sinks that
   * MaD cannot express.
   */
  API::Node getSystemOrAssistantPromptNode() {
    exists(API::Node msg | msg = chatMessage() and isSystemOrDevMessage(msg) |
      result = messageContent(msg)
    )
  }

  /**
   * Gets role-filtered user message content sinks that MaD cannot express.
   */
  API::Node getUserPromptNode() {
    exists(API::Node msg | msg = chatMessage() and not isSystemOrDevMessage(msg) |
      result = messageContent(msg)
    )
  }
}
