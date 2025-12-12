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
