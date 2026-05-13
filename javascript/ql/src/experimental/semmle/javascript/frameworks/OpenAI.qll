/**
 * Provides classes modeling security-relevant aspects of the `openAI-Node` package.
 * See https://github.com/openai/openai-node
 *
 * Structurally typed sinks (instructions, prompt, input, etc.) have been moved to
 * Models as Data: javascript/ql/lib/ext/openai.model.yml
 *
 * This file retains only role-filtered sinks that require inspecting a sibling
 * `role` property, which MaD cannot express.
 */

private import javascript

/** Holds if `msg` is a message array element with a privileged role. */
private predicate isSystemOrDevMessage(API::Node msg) {
  msg.getMember("role").asSink().mayHaveStringValue(["system", "developer", "assistant"])
}

module OpenAIGuardrails {
  /** Gets a reference to the `GuardrailsOpenAI` class. */
  API::Node classRef() {
    result = API::moduleImport("@openai/guardrails")
  }

  API::Node getSanitizerNode() {
    // checkPlainText(userInput, bundle) or runGuardrails(userInput, bundle)
    result = classRef().getMember(["checkPlainText", "runGuardrails"])
  }
}

module OpenAI {
  /** Gets a reference to all OpenAI client instances. */
  private API::Node allClients() {
    result = API::moduleImport("openai").getInstance()
    or
    result = API::moduleImport("openai").getMember(["OpenAI", "AzureOpenAI"]).getInstance()
    or
    result =
      API::moduleImport("@openai/guardrails")
          .getMember(["GuardrailsOpenAI", "GuardrailsAzureOpenAI"])
          .getMember("create")
          .getReturn()
          .getPromised()
  }

  /**
   * Gets role-filtered system/developer/assistant message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getSystemOrAssistantPromptNode() {
    // responses.create({ input: [{ role: "system"/"developer", content: "..." }] })
    exists(API::Node msg |
      msg =
        allClients()
            .getMember("responses")
            .getMember("create")
            .getParameter(0)
            .getMember("input")
            .getArrayElement() and
      isSystemOrDevMessage(msg)
    |
      result = msg.getMember("content")
    )
    or
    // chat.completions.create({ messages: [{ role: "system"/"developer", content: ... }] })
    exists(API::Node msg, API::Node content |
      msg =
        allClients()
            .getMember("chat")
            .getMember("completions")
            .getMember("create")
            .getParameter(0)
            .getMember("messages")
            .getArrayElement() and
      isSystemOrDevMessage(msg) and
      content = msg.getMember("content")
    |
      result = content
      or
      result = content.getArrayElement().getMember("text")
    )
    or
    // beta.threads.messages.create(threadId, { role: "system"/"developer", content: ... })
    exists(API::Node msg |
      msg =
        allClients()
            .getMember("beta")
            .getMember("threads")
            .getMember("messages")
            .getMember("create")
            .getParameter(1) and
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
    // responses.create({ input: [{ role: "user", content: ... }] })
    exists(API::Node msg |
      msg =
        allClients()
            .getMember("responses")
            .getMember("create")
            .getParameter(0)
            .getMember("input")
            .getArrayElement() and
      not isSystemOrDevMessage(msg)
    |
      result = msg.getMember("content")
    )
    or
    // chat.completions.create({ messages: [{ role: "user", content: ... }] })
    exists(API::Node msg, API::Node content |
      msg =
        allClients()
            .getMember("chat")
            .getMember("completions")
            .getMember("create")
            .getParameter(0)
            .getMember("messages")
            .getArrayElement() and
      not isSystemOrDevMessage(msg) and
      content = msg.getMember("content")
    |
      result = content
      or
      result = content.getArrayElement().getMember("text")
    )
    or
    // beta.threads.messages.create(threadId, { role: "user", content: ... })
    exists(API::Node msg |
      msg =
        allClients()
            .getMember("beta")
            .getMember("threads")
            .getMember("messages")
            .getMember("create")
            .getParameter(1) and
      not isSystemOrDevMessage(msg)
    |
      result = msg.getMember("content")
    )
  }
}

/**
 * Provides models for agents SDK.
 *
 * See https://github.com/openai/openai-agents-js and
 * https://github.com/openai/openai-guardrails-js.
 *
 * Structurally typed sinks have been moved to openai.model.yml.
 * This module retains only role-filtered sinks, callback-based sinks, and
 * unsafe agent detection that MaD cannot express.
 */
module AgentSDK {
  API::Node moduleRef() {
    result = API::moduleImport("@openai/agents")
    or
    result = API::moduleImport("@openai/guardrails")
  }

  /** Gets a reference to the top-level run() or Runner.run() functions. */
  private API::Node run() {
    result = moduleRef().getMember("run")
    or
    result = moduleRef().getMember("Runner").getInstance().getMember("run")
  }

  /**
   * Gets role-filtered and callback-based system prompt sinks that MaD cannot express.
   */
  API::Node getSystemOrAssistantPromptNode() {
    // Agent({ instructions: (runContext) => returnValue }) — callback form
    result = moduleRef()
        .getMember("Agent")
        .getParameter(0)
        .getMember("instructions")
        .getReturn()
    or
    // run(agent, [{ role: "system"/"developer", content: ... }])
    exists(API::Node msg |
      msg = run()
          .getParameter(1)
          .getArrayElement() and
      isSystemOrDevMessage(msg)
    |
      result = msg.getMember("content")
    )
  }

  /**
   * Gets an agent constructor config that visibly lacks input guardrails.
   * Covers both native Agent({ inputGuardrails: [...] }) and
   * GuardrailAgent.create({ input: { guardrails: [...] } }, ...).
   */
  API::Node getUnsafeAgentNode() {
    // new Agent({ name: '...', ... }) without inputGuardrails
    result = moduleRef().getMember("Agent").getParameter(0) and
    // Config is an inspectable object literal
    (exists(result.getMember("name")) or exists(result.getMember("instructions"))) and
    not exists(result.getMember("inputGuardrails").getArrayElement())
    or
    // GuardrailAgent.create(config, ...) without input/pre_flight guardrails
    exists(API::Node createCall |
      createCall =
        moduleRef()
            .getMember("GuardrailAgent")
            .getMember("create") and
      result = createCall.getParameter(0) and
      exists(result.getMember("version")) and
      not exists(
        result.getMember("input").getMember("guardrails").getArrayElement()
      ) and
      not exists(
        result.getMember("pre_flight").getMember("guardrails").getArrayElement()
      )
    )
  }
}
