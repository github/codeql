/**
 * Provides classes modeling security-relevant aspects of the `google-genai` package.
 * See https://github.com/googleapis/python-genai.
 *
 * Structurally typed sinks (`system_instruction`, `contents`, etc.) are modeled via
 * Models as Data: python/ql/lib/semmle/python/frameworks/google-genai.model.yml
 *
 * This file retains only role-filtered content sinks that require inspecting a
 * sibling `role` key, which MaD cannot express.
 */

private import python
private import semmle.python.ApiGraphs

/** Provides classes modeling prompt-injection sinks of the `google-genai` package. */
module GoogleGenAI {
  /** Gets a reference to a `google.genai.Client` instance. */
  private API::Node clientRef() {
    result = API::moduleImport("google.genai").getMember("Client").getReturn()
  }

  /** Gets the content dictionaries passed to `models.generate_content`/`generate_content_stream`. */
  private API::Node contentElement() {
    result =
      clientRef()
          .getMember("models")
          .getMember(["generate_content", "generate_content_stream"])
          .getKeywordParameter("contents")
          .getASubscript()
  }

  /**
   * Gets role-filtered system/model content sinks that MaD cannot express.
   * Gemini uses the "model" role instead of "assistant".
   */
  API::Node getSystemOrAssistantPromptNode() {
    exists(API::Node msg |
      msg = contentElement() and
      msg.getSubscript("role").getAValueReachingSink().asExpr().(StringLiteral).getText() =
        ["system", "model"]
    |
      result = msg.getSubscript("parts").getASubscript().getSubscript("text")
    )
  }

  /**
   * Gets role-filtered user content sinks that MaD cannot express.
   */
  API::Node getUserPromptNode() {
    exists(API::Node msg |
      msg = contentElement() and
      not msg.getSubscript("role").getAValueReachingSink().asExpr().(StringLiteral).getText() =
        ["system", "model"]
    |
      result = msg.getSubscript("parts").getASubscript().getSubscript("text")
    )
  }
}
