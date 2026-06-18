/**
 * Provides classes modeling security-relevant aspects of the `openai` Agents SDK package.
 * See https://github.com/openai/openai-agents-python.
 * As well as the regular openai python interface.
 * See https://github.com/openai/openai-python.
 *
 * Structurally typed sinks (instructions, prompt, input, etc.) are modeled via
 * Models as Data: python/ql/lib/semmle/python/frameworks/openai.model.yml and
 * python/ql/lib/semmle/python/frameworks/agent.model.yml
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

/**
 * Provides models for the agents SDK (instances of the `agents.Runner` class etc).
 *
 * See https://github.com/openai/openai-agents-python.
 */
module AgentSdk {
  /** Gets a reference to the `agents.Runner` class. */
  API::Node classRef() { result = API::moduleImport("agents").getMember("Runner") }

  /** Gets a reference to the `run` members. */
  API::Node runMembers() { result = classRef().getMember(["run", "run_sync", "run_streamed"]) }

  /** Gets a reference to the `input` argument of a `Runner.run` call. */
  private API::Node runInput() {
    result = runMembers().getKeywordParameter("input")
    or
    result = runMembers().getParameter(1)
  }

  /**
   * Gets role-filtered system/developer/assistant message content sinks that
   * MaD cannot express.
   */
  API::Node getSystemOrAssistantPromptNode() {
    exists(API::Node msg |
      msg = runInput().getASubscript() and
      isSystemOrDevMessage(msg)
    |
      result = msg.getSubscript("content")
    )
  }

  /**
   * Gets role-filtered user message content sinks that MaD cannot express.
   * The string-input case is handled via MaD (agent.model.yml).
   */
  API::Node getUserPromptNode() {
    exists(API::Node msg |
      msg = runInput().getASubscript() and
      not isSystemOrDevMessage(msg)
    |
      result = msg.getSubscript("content")
    )
  }
}

/**
 * Provides models for the OpenAI client (instances of the `openai.OpenAI` class).
 *
 * See https://github.com/openai/openai-python.
 */
module OpenAI {
  /** Gets a reference to an `openai.OpenAI` client instance. */
  API::Node classRef() {
    result =
      API::moduleImport("openai").getMember(["OpenAI", "AsyncOpenAI", "AzureOpenAI"]).getReturn()
  }

  /** Gets the message dictionaries passed to `chat.completions.create`. */
  private API::Node chatMessage() {
    result =
      classRef()
          .getMember("chat")
          .getMember("completions")
          .getMember("create")
          .getKeywordParameter("messages")
          .getASubscript()
  }

  /** Gets the message dictionaries passed as a list to `responses.create`. */
  private API::Node responsesMessage() {
    result =
      classRef().getMember("responses").getMember("create").getKeywordParameter("input").getASubscript()
  }

  /** Gets the content sink of a message dictionary, including the `text` of structured content. */
  private API::Node messageContent(API::Node msg) {
    result = msg.getSubscript("content")
    or
    result = msg.getSubscript("content").getASubscript().getSubscript("text")
  }

  /** Gets the `beta.threads.messages.create` call (Assistants API thread messages). */
  private API::Node threadMessageCreate() {
    result =
      classRef().getMember("beta").getMember("threads").getMember("messages").getMember("create")
  }

  /** Holds if the `role` keyword of thread-message `call` is a privileged (assistant) role. */
  private predicate threadRoleIsAssistant(API::Node call) {
    call.getKeywordParameter("role").getAValueReachingSink().asExpr().(StringLiteral).getText() =
      "assistant"
  }

  /**
   * Gets role-filtered system/developer/assistant message content sinks that
   * MaD cannot express.
   */
  API::Node getSystemOrAssistantPromptNode() {
    exists(API::Node msg | msg = [chatMessage(), responsesMessage()] and isSystemOrDevMessage(msg) |
      result = messageContent(msg)
    )
    or
    exists(API::Node call | call = threadMessageCreate() and threadRoleIsAssistant(call) |
      result = call.getKeywordParameter("content")
    )
  }

  /**
   * Gets role-filtered user message content sinks that MaD cannot express.
   * The string-input case is handled via MaD (openai.model.yml).
   */
  API::Node getUserPromptNode() {
    exists(API::Node msg |
      msg = [chatMessage(), responsesMessage()] and not isSystemOrDevMessage(msg)
    |
      result = messageContent(msg)
    )
    or
    exists(API::Node call | call = threadMessageCreate() and not threadRoleIsAssistant(call) |
      result = call.getKeywordParameter("content")
    )
    or
    // realtime conversation items, role cannot be statically resolved in general
    result =
      classRef()
          .getMember("realtime")
          .getMember("connect")
          .getReturn()
          .getMember("conversation")
          .getMember("item")
          .getMember("create")
          .getKeywordParameter("item")
          .getSubscript("content")
          .getASubscript()
          .getSubscript("text")
  }
}
