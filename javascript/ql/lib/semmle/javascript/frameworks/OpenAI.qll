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

  /** Gets a guarded client that is clearly configured without input guardrails. */
  private API::Node unprotectedGuardedClient() {
    exists(API::Node createCall |
      createCall =
        API::moduleImport("@openai/guardrails")
            .getMember(["GuardrailsOpenAI", "GuardrailsAzureOpenAI"])
            .getMember("create") and
      result = createCall.getReturn().getPromised() and
      exists(createCall.getParameter(0).getMember("version")) and
      not exists(
        createCall.getParameter(0).getMember("input").getMember("guardrails").getArrayElement()
      ) and
      not exists(
        createCall.getParameter(0).getMember("pre_flight").getMember("guardrails").getArrayElement()
      )
    )
  }

  /** Gets a reference to all clients without input guardrails. */
  private API::Node clientsNoGuardrails() {
    result = API::moduleImport("openai").getInstance()
    or
    result = API::moduleImport("openai").getMember(["OpenAI", "AzureOpenAI"]).getInstance()
    or
    result = unprotectedGuardedClient()
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
    // responses.create({ input: "string" })
    result =
      clientsNoGuardrails()
          .getMember("responses")
          .getMember("create")
          .getParameter(0)
          .getMember("input")
    or
    // responses.create({ input: [{ role: "user", content: ... }] })
    exists(API::Node msg |
      msg =
        clientsNoGuardrails()
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
        clientsNoGuardrails()
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
    // Legacy completions API: completions.create({ prompt: ... })
    result =
      clientsNoGuardrails()
          .getMember("completions")
          .getMember("create")
          .getParameter(0)
          .getMember("prompt")
    or
    // images.generate({ prompt: ... }) and images.edit({ prompt: ... })
    result =
      clientsNoGuardrails()
          .getMember("images")
          .getMember(["generate", "edit"])
          .getParameter(0)
          .getMember("prompt")
    or
    // beta.threads.messages.create(threadId, { role: "user", content: ... })
    exists(API::Node msg |
      msg =
        clientsNoGuardrails()
            .getMember("beta")
            .getMember("threads")
            .getMember("messages")
            .getMember("create")
            .getParameter(1) and
      not isSystemOrDevMessage(msg)
    |
      result = msg.getMember("content")
    )
    or
    // audio.transcriptions/translations.create({ prompt: ... })
    result =
      clientsNoGuardrails()
          .getMember("audio")
          .getMember(["transcriptions", "translations"])
          .getMember("create")
          .getParameter(0)
          .getMember("prompt")
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
   * Gets role-filtered user prompt sinks for run(agent, input).
   * The string-input case is handled via MaD (openai.model.yml).
   */
  API::Node getUserPromptNode() {
    // run(agent, [{ role: "user", content: ... }])
    exists(API::Node msg |
      msg = run().getParameter(1).getArrayElement() and
      not isSystemOrDevMessage(msg)
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
