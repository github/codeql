/**
 * Provides default sources, sinks and sanitizers for detecting
 * "code execution from deserialization"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.frameworks.data.ModelsAsData

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "code execution from deserialization"
 * vulnerabilities, as well as extension points for adding your own.
 */
module UnsafeDeserialization {
  /**
   * A data flow source for "code execution from deserialization" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "code execution from deserialization" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "code execution from deserialization" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * An insecure decoding, considered as a flow sink.
   */
  class InsecureDecodingAsSink extends Sink {
    InsecureDecodingAsSink() {
      exists(Decoding d |
        d.mayExecuteInput() and
        this = d.getAnInput()
      )
    }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("unsafe-deserialization").asSink() }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsSanitizerGuard instead. */
  deprecated class StringConstCompareAsSanitizerGuard = ConstCompareAsSanitizerGuard;
}
