/** Provides taint tracking configurations to be used in unsafe content URI resolution queries. */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2
import UnsafeContentUriResolution

/** A taint-tracking configuration to find paths from remote sources to content URI resolutions. */
class UnsafeContentResolutionConf extends TaintTracking::Configuration {
  UnsafeContentResolutionConf() { this = "UnsafeContentResolutionConf" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    flowsToWrite(sink.(ContentUriResolutionSink).getCallNode())
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof ContentUriResolutionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(ContentUriResolutionAdditionalTaintStep s).step(node1, node2)
  }
}

/** Holds if `node` flows to a write operation. */
private predicate flowsToWrite(DataFlow::Node node) { any(FlowsToWriteConfig c).hasFlow(node, _) }

/** A taint-tracking configuration to find paths to write operations. */
private class FlowsToWriteConfig extends TaintTracking2::Configuration {
  FlowsToWriteConfig() { this = "FlowsToWriteConfig" }

  override predicate isSource(DataFlow::Node src) {
    src = any(ContentUriResolutionSink s).getCallNode()
  }

  override predicate isSink(DataFlow::Node sink) {
    sinkNode(sink, "create-file")
    or
    sinkNode(sink, "write-file")
    or
    exists(MethodAccess ma | sink.asExpr() = ma.getArgument(0) |
      ma.getMethod() instanceof WriteStreamMethod
    )
  }
}

private class WriteStreamMethod extends Method {
  WriteStreamMethod() {
    this.getAnOverride*().hasQualifiedName("java.io", "OutputStream", "write")
    or
    this.hasQualifiedName("org.apache.commons.io", "IOUtils", "copy")
    or
    this.hasQualifiedName("org.springframework.util", ["StreamUtils", "CopyUtils"], "copy")
    or
    this.hasQualifiedName("com.google.common.io", ["ByteStreams", "CharStreams"], "copy")
  }
}
