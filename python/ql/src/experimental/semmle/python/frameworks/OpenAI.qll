/**
 * Provides classes modeling security-relevant aspects of the `openAI` Agents SDK package.
 * See https://github.com/openai/openai-agents-python.
 * As well as the regular openai python interface.
 * See https://github.com/openai/openai-python.
 */

private import python
private import semmle.python.ApiGraphs

/**
 * Provides models for agents SDK (instances of the `agents.Runner` class etc).
 *
 * See https://github.com/openai/openai-agents-python.
 */
module AgentSDK {
  /** Gets a reference to the `agents.Runner` class. */
  API::Node classRef() { result = API::moduleImport("agents").getMember("Runner") }

  /** Gets a reference to the `run` members. */
  API::Node runMembers() { result = classRef().getMember(["run", "run_sync", "run_streamed"]) }

  /** Gets a reference to a potential property of `agents.Runner` called input which can refer to a system prompt depending on the role specified. */
  API::Node getContentNode() {
    result = runMembers().getKeywordParameter("input").getASubscript().getSubscript("content")
    or
    result = runMembers().getParameter(_).getASubscript().getSubscript("content")
  }
}

/**
 * Provides models for Agent (instances of the `openai.OpenAI` class).
 *
 * See https://github.com/openai/openai-python.
 */
module OpenAI {
  /** Gets a reference to the `openai.OpenAI` class. */
  API::Node classRef() {
    result =
      API::moduleImport("openai").getMember(["OpenAI", "AsyncOpenAI", "AzureOpenAI"]).getReturn()
  }

  /** Gets a reference to a potential property of `openai.OpenAI` called instructions which refers to the system prompt. */
  API::Node getContentNode() {
    exists(API::Node content |
      content =
        classRef()
            .getMember("responses")
            .getMember("create")
            .getKeywordParameter(["input", "instructions"])
      or
      content =
        classRef()
            .getMember("responses")
            .getMember("create")
            .getKeywordParameter(["input", "instructions"])
            .getASubscript()
            .getSubscript("content")
      or
      content =
        classRef()
            .getMember("realtime")
            .getMember("connect")
            .getReturn()
            .getMember("conversation")
            .getMember("item")
            .getMember("create")
            .getKeywordParameter("item")
            .getSubscript("content")
      or
      content =
        classRef()
            .getMember("chat")
            .getMember("completions")
            .getMember("create")
            .getKeywordParameter("messages")
            .getASubscript()
            .getSubscript("content")
    |
      // content
      if not exists(content.getASubscript())
      then result = content
      else
        // content.text
        result = content.getASubscript().getSubscript("text")
    )
  }
}
