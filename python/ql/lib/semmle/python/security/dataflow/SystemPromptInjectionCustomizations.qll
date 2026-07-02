/**
 * Provides default sources, sinks and sanitizers for detecting
 * "system prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.frameworks.OpenAI
private import semmle.python.frameworks.Anthropic
private import semmle.python.frameworks.GoogleGenAI
private import semmle.python.frameworks.OpenRouter

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "system prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module SystemPromptInjection {
  /**
   * A data flow source for "system prompt injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "system prompt injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "system prompt injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A prompt to an AI model, considered as a flow sink.
   */
  class AIPromptAsSink extends Sink {
    AIPromptAsSink() { this = any(AIPrompt p).getAPrompt() }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("system-prompt-injection").asSink() }
  }

  private class PromptContentSink extends Sink {
    PromptContentSink() {
      this = OpenAI::getSystemOrAssistantPromptNode().asSink()
      or
      this = AgentSdk::getSystemOrAssistantPromptNode().asSink()
      or
      this = Anthropic::getSystemOrAssistantPromptNode().asSink()
      or
      this = GoogleGenAI::getSystemOrAssistantPromptNode().asSink()
      or
      this = OpenRouter::getSystemOrAssistantPromptNode().asSink()
    }
  }

  /**
   * Content placed in a message with `role: "user"` is not a system prompt
   * injection vector; it is intended user-role content.
   *
   * This prevents false positives when user input and system prompts are
   * combined in the same message list and taint would otherwise propagate to
   * the system message.
   */
  private class UserRoleMessageContentBarrier extends Sanitizer {
    UserRoleMessageContentBarrier() {
      exists(API::Node msg |
        msg.getSubscript("role").getAValueReachingSink().asExpr().(StringLiteral).getText() = "user"
      |
        this = msg.getSubscript("content").asSink()
      )
    }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }
}
