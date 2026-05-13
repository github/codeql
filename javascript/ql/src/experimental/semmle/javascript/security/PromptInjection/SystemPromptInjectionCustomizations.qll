/**
 * Provides default sources, sinks and sanitizers for detecting
 * "prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

import javascript

private import semmle.javascript.dataflow.DataFlow
private import semmle.javascript.Concepts
private import semmle.javascript.security.dataflow.RemoteFlowSources
private import semmle.javascript.dataflow.internal.BarrierGuards
private import semmle.javascript.frameworks.data.ModelsAsData
private import experimental.semmle.javascript.frameworks.OpenAI
private import experimental.semmle.javascript.frameworks.Anthropic
private import experimental.semmle.javascript.frameworks.GoogleGenAI

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module SystemPromptInjection {
  /**
   * A data flow source for "prompt injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "prompt injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "prompt injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource {
  }

  /**
   * A prompt to an AI model, considered as a flow sink.
   */
  class AIPromptAsSink extends Sink {
    AIPromptAsSink() { this = any(AIPrompt p).getAPrompt() }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() {
      this = ModelOutput::getASinkNode("system-prompt-injection").asSink()
    }
  }

  private class PromptContentSink extends Sink {
    PromptContentSink() {
      this = OpenAI::getSystemOrAssistantPromptNode().asSink()
      or
      this = AgentSDK::getSystemOrAssistantPromptNode().asSink()
      or
      this = Anthropic::getSystemOrAssistantPromptNode().asSink()
      or
      this = GoogleGenAI::getSystemOrAssistantPromptNode().asSink()
    }
  }

  private class ConstCompareAsSanitizerGuard extends Sanitizer {
    ConstCompareAsSanitizerGuard()
    {
      this = DataFlow::MakeBarrierGuard<ConstCompareBarrierGuard>::getABarrierNode()
    }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  private class ConstCompareBarrierGuard extends DataFlow::ValueNode
  {
    override EqualityTest astNode;

    ConstCompareBarrierGuard()
    {
      astNode.hasOperands(_, any(ConstantString cs))
    }

    predicate blocksExpr(boolean outcome, Expr e) {
      outcome = astNode.getPolarity() and
      e = astNode.getLeftOperand() and
      e = astNode.getAnOperand() and
      not e instanceof ConstantString
    }
  }
}
