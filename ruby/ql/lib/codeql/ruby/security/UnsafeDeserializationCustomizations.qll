/**
 * Provides default sources, sinks and sanitizers for reasoning about unsafe
 * deserialization, as well as extension points for adding your own.
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources

module UnsafeDeserialization {
  /**
   * A data flow source for unsafe deserialization vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unsafe deserialization vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for unsafe deserialization vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Additional taint steps for "unsafe deserialization" vulnerabilities.
   */
  predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    base64DecodeTaintStep(fromNode, toNode)
  }

  /** A source of remote user input, considered as a flow source for unsafe deserialization. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An argument in a call to `Marshal.load` or `Marshal.restore`, considered a
   * sink for unsafe deserialization.
   */
  class MarshalLoadOrRestoreArgument extends Sink {
    MarshalLoadOrRestoreArgument() {
      this = API::getTopLevelMember("Marshal").getAMethodCall(["load", "restore"]).getArgument(0)
    }
  }

  /**
   * An argument in a call to `YAML.load`, considered a sink for unsafe
   * deserialization.
   */
  class YamlLoadArgument extends Sink {
    YamlLoadArgument() {
      this = API::getTopLevelMember("YAML").getAMethodCall("load").getArgument(0)
    }
  }

  /**
   * An argument in a call to `JSON.load` or `JSON.restore`, considered a sink
   * for unsafe deserialization.
   */
  class JsonLoadArgument extends Sink {
    JsonLoadArgument() {
      this = API::getTopLevelMember("JSON").getAMethodCall(["load", "restore"]).getArgument(0)
    }
  }

  /**
   * `Base64.decode64` propagates taint from its argument to its return value.
   */
  predicate base64DecodeTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    exists(DataFlow::CallNode callNode |
      callNode =
        API::getTopLevelMember("Base64")
            .getAMethodCall(["decode64", "strict_decode64", "urlsafe_decode64"])
    |
      fromNode = callNode.getArgument(0) and
      toNode = callNode
    )
  }
}
