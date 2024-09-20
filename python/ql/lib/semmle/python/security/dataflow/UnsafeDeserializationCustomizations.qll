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
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

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
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier { }
}
