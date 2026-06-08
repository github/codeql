/**
 * Provides classes modeling security-relevant aspects of the `openAI-Node` package.
 * See https://github.com/openai/openai-node 
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
     result = classRef()
      .getMember(["checkPlainText", "runGuardrails"])
  }
}

module OpenAI {

  /** Gets a reference to all clients without guardrails. */
  API::Node clientsNoGuardrails() {
    // Default export: import OpenAI from 'openai'; new OpenAI()
    result = API::moduleImport("openai").getInstance()
    or
    // Named import: import { OpenAI, AzureOpenAI } from 'openai'; new AzureOpenAI()
    result = API::moduleImport("openai").getMember(["OpenAI", "AzureOpenAI"]).getInstance()
    or
    result = unprotectedGuardedClient()
  }

  /** Gets a reference to the `openai.OpenAI` class or a guardrails-wrapped equivalent. */
  API::Node allClients() {
    // Default export: import OpenAI from 'openai'; new OpenAI()
    result = clientsNoGuardrails()
    or
    // Guardrails drop-in: import { GuardrailsOpenAI } from '@openai/guardrails';
    // const client = await GuardrailsOpenAI.create(config);
    result = guardedClient()
  }

  /** Gets a reference to an open AI client from Guardrails. */
  API::Node guardedClient() {
    result =
      API::moduleImport("@openai/guardrails")
          .getMember(["GuardrailsOpenAI", "GuardrailsAzureOpenAI"])
          .getMember("create")
          .getReturn()
          .getPromised()
  }

  /** Gets a guarded client that is clearly configured without input guardrails. */
  API::Node unprotectedGuardedClient() {
    exists(API::Node createCall |
      createCall =
        API::moduleImport("@openai/guardrails")
            .getMember(["GuardrailsOpenAI", "GuardrailsAzureOpenAI"])
            .getMember("create") and
      result = createCall.getReturn().getPromised() and
      // Config is an inspectable object literal, e.g. GuardrailsOpenAI.create({ version: 1 })
      exists(createCall.getParameter(0).getMember("version")) and
      // No input-stage guardrails, e.g. missing input: { guardrails: [{ name: '...' }] }
      not exists(
        createCall.getParameter(0).getMember("input").getMember("guardrails").getArrayElement()
      ) and
      // No pre_flight-stage guardrails, e.g. missing pre_flight: { guardrails: [{ name: '...' }] }
      not exists(
        createCall.getParameter(0).getMember("pre_flight").getMember("guardrails").getArrayElement()
      )
    )
  }


  /** Gets a reference to a potential property of `openai.OpenAI` called instructions which refers to the system prompt. */
  API::Node getSystemOrAssistantPromptNode() {
    // responses.create({ input: ..., instructions: ... })
    // input can be a string or an array of message objects
    exists(API::Node responsesCreate |
      responsesCreate =
        allClients()
            .getMember("responses")
            .getMember("create")
            .getParameter(0)
    |
      // instructions: "string"
      result = responsesCreate.getMember("instructions")
      // intended that user data can flow into input
      // or
      // // input: "string"
      // result = responsesCreate.getMember("input")
      or
      // input: [{ role: "system"/"developer", content: "..." }]
      exists(API::Node msg |
        msg = responsesCreate.getMember("input").getArrayElement() and
        isSystemOrDevMessage(msg)
      |
        result = msg.getMember("content")
      )
    )
    or
    // chat.completions.create({ messages: [{ role: "system"/"developer", content: ... }] })
    // content can be a string or an array of content parts
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
      // content: "string"
      result = content
      or
      // content: [{ type: "text", text: "..." }]
      result = content.getArrayElement().getMember("text")
    )
    or
    // beta.assistants.create({ instructions: ... }) and beta.assistants.update(id, { instructions: ... })
    result =
      allClients()
          .getMember("beta")
          .getMember("assistants")
          .getMember(["create", "update"])
          .getParameter(0)
          .getMember("instructions")
    or
    // beta.threads.runs.create(threadId, { instructions: ..., additional_instructions: ... })
    result =
      allClients()
          .getMember("beta")
          .getMember("threads")
          .getMember("runs")
          .getMember("create")
          .getParameter(1)
          .getMember(["instructions", "additional_instructions"])
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

  /** Gets a reference to nodes where potential user input can land. */
  API::Node getUserPromptNode() {
    // responses.create({ input: ... }) — string input
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
    // content can be a string or an array of content parts
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
      // content: "string"
      result = content
      or
      // content: [{ type: "text", text: "..." }]
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
    // embeddings.create({ input: ... })
    result =
      clientsNoGuardrails()
          .getMember("embeddings")
          .getMember("create")
          .getParameter(0)
          .getMember("input")
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
    // audio.transcriptions.create({ prompt: ... }) and audio.translations.create({ prompt: ... })
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
 * Provides models for agents SDK (instances of the `agents` class etc).
 *
 * See https://github.com/openai/openai-agents-js and
 * https://github.com/openai/openai-guardrails-js.
 * 
 * Note: Agent.run is not covered currently for the user prompt because it necessitates a more complex analysis.
 * Specifically, the call looks like run(agent, input), where the agent may have been initiated as a guardrails agent or an unsafe agent.
 * The input may also be coming from a non-external source so we'd need to cross-reference two analyses. Instead, we will flag unsafe agent creations, thus
 * guaranteeing that when the value reaches the run call, it is either safe or previously flagged.
 */
module AgentSdk {
  API::Node moduleRef() {
    result = API::moduleImport("@openai/agents")
    or
    result = API::moduleImport("@openai/guardrails")
  }

  /** Gets a reference to the `agents.Runner` class. */
  API::Node agentConstructor() { result = moduleRef().getMember("Agent") }

  API::Node classInstance() { result = agentConstructor().getInstance() }

  /** Gets a reference to the top-level run() or Runner.run() functions. */
  API::Node run() {
    // import { run } from '@openai/agents'; run(agent, input)
    result = moduleRef().getMember("run")
    or
    // const runner = new Runner(); runner.run(agent, input)
    result = moduleRef().getMember("Runner").getInstance().getMember("run")
  }

  API::Node asTool() { result = classInstance().getMember("asTool")}

  API::Node toolFunction() { result = moduleRef().getMember("tool") }

  /** Gets a reference to a potential property of `agents.Runner` called input which can refer to a system prompt depending on the role specified. */
  API::Node getSystemOrAssistantPromptNode() {
    // Agent({ instructions: ... })
    result = agentConstructor()
    .getParameter(0)
    .getMember(["instructions", "handoffDescription"])
    or
    // Agent({ instructions: (runContext) => returnValue })
    result = agentConstructor()
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
    or
    // agent.asTool({..., toolDescription: ...})
    result = asTool().getParameter(0).getMember("toolDescription")
    or
    // tool({..., description: ...})
    result = toolFunction().getParameter(0).getMember("description")
    or
    // GuardrailAgent.create(config, name, instructions)
    // import { GuardrailAgent } from '@openai/guardrails';
    result =
      moduleRef()
          .getMember("GuardrailAgent")
          .getMember("create")
          .getParameter(2)
    or
    // GuardrailAgent.create(config, name, (ctx, agent) => "...") — callback form
    result =
      moduleRef()
          .getMember("GuardrailAgent")
          .getMember("create")
          .getParameter(2)
          .getReturn()
  }

    /**
   * Gets an agent constructor config that visibly lacks input guardrails.
   * Covers both native Agent({ inputGuardrails: [...] }) and
   * GuardrailAgent.create({ input: { guardrails: [...] } }, ...).
   */
  API::Node getUnsafeAgentNode() {
    // new Agent({ name: '...', ... }) without inputGuardrails
    result = agentConstructor().getParameter(0) and
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
      // Config is an inspectable object literal
      exists(result.getMember("version")) and
      // No input-stage guardrails
      not exists(
        result.getMember("input").getMember("guardrails").getArrayElement()
      ) and
      // No pre_flight-stage guardrails
      not exists(
        result.getMember("pre_flight").getMember("guardrails").getArrayElement()
      )
    )
  }
}
