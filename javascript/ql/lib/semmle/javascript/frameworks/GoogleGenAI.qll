/**
 * Provides classes modeling security-relevant aspects of the `@google/genai` package.
 * See https://github.com/googleapis/js-genai
 *
 * Structurally typed sinks (systemInstruction, prompt, message, etc.) have been
 * moved to Models as Data: javascript/ql/lib/ext/google-genai.model.yml
 *
 * This file retains only role-filtered content sinks that require inspecting
 * a sibling `role` property, which MaD cannot express.
 */

private import javascript

/** Provides classes modeling prompt-injection sources of the `@google/genai` package. */
module GoogleGenAI {
  /** Gets a reference to the `GoogleGenAI` client instance. */
  private API::Node clientRef() {
    result = API::moduleImport("@google/genai").getMember("GoogleGenAI").getInstance()
  }

  /**
   * Gets role-filtered system/model message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getSystemOrAssistantPromptNode() {
    // contents: [{ role: "model", parts: [{ text: "..." }] }]
    // Gemini uses "model" role instead of "assistant"
    exists(API::Node msg |
      msg =
        clientRef()
            .getMember("models")
            .getMember(["generateContent", "generateContentStream"])
            .getParameter(0)
            .getMember("contents")
            .getArrayElement() and
      msg.getMember("role").asSink().mayHaveStringValue(["system", "model"])
    |
      result = msg.getMember("parts").getArrayElement().getMember("text")
    )
  }

  /**
   * Gets role-filtered user message sinks.
   * These require checking a sibling `role` property and cannot be expressed in MaD.
   */
  API::Node getUserPromptNode() {
    // contents: [{ role: "user", parts: [{ text: "..." }] }]
    exists(API::Node msg |
      msg =
        clientRef()
            .getMember("models")
            .getMember(["generateContent", "generateContentStream"])
            .getParameter(0)
            .getMember("contents")
            .getArrayElement() and
      not msg.getMember("role").asSink().mayHaveStringValue(["system", "model"])
    |
      result = msg.getMember("parts").getArrayElement().getMember("text")
    )
  }
}
