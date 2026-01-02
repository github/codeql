/**
 * Provides classes modeling security-relevant aspects of the `openAI`Agents SDK package.
 * See https://github.com/openai/openai-agents-python.
 */

private import python
private import semmle.python.ApiGraphs

/**
 * Provides models for Agent (instances of the `agents.Agent` class).
 *
 * See https://github.com/openai/openai-agents-python.
 */
module Agent {
  /** Gets a reference to the `agents.Agent` class. */
  API::Node classRef() { result = API::moduleImport("agents").getMember("Agent") }

  /** Gets a reference to a potential property of `agents.Agent` called instructions which refers to the system prompt. */
  API::Node sink() { result = classRef().getACall().getKeywordParameter("instructions") }
}

/**
 * Provides models for OpenAI (instances of `openai` classes).
 *
 * See https://github.com/openai/openai-python.
 */
module OpenAI {
  /** Gets a reference to `openai.OpenAI`, `openai.AsyncOpenAI` and `openai.AzureOpenAI`classes. */
  API::Node classRef() {
    result = API::moduleImport("openai").getMember(["OpenAI", "AsyncOpenAI", "AzureOpenAI"])
  }

  /** Gets a reference to a potential property of `openai.OpenAI called instructions which refers to the system prompt. */
  API::Node sink() {
    result =
      classRef()
          .getReturn()
          .getMember("responses")
          .getMember("create")
          .getKeywordParameter(["input", "instructions"]) or
    result =
      classRef()
          .getReturn()
          .getMember("realtime")
          .getMember("connect")
          .getReturn()
          .getMember("conversation")
          .getMember("item")
          .getMember("create")
          .getKeywordParameter("item") or
    result =
      classRef()
          .getReturn()
          .getMember("chat")
          .getMember("completions")
          .getMember("create")
          .getKeywordParameter("messages")
  }
}
