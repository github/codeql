/** Provides taint tracking configurations to be used in XXE queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.security.XmlParsers

/**
 * A taint-tracking configuration for unvalidated remote user input that is used in XML external entity expansion.
 */
class XxeConfig extends TaintTracking::Configuration {
  XxeConfig() { this = "XxeConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeXxeSink }
}

/**
 * A taint-tracking configuration for unvalidated local user input that is used in XML external entity expansion.
 */
class XxeLocalConfig extends TaintTracking::Configuration {
  XxeLocalConfig() { this = "XxeLocalConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeXxeSink }
}

private class UnsafeXxeSink extends DataFlow::ExprNode {
  UnsafeXxeSink() {
    not exists(SafeSaxSourceFlowConfig safeSource | safeSource.hasFlowTo(this)) and
    exists(XmlParserCall parse |
      parse.getSink() = this.getExpr() and
      not parse.isSafe()
    )
  }
}

/**
 * A taint-tracking configuration for safe XML readers used to parse XML documents.
 */
private class SafeSaxSourceFlowConfig extends TaintTracking2::Configuration {
  SafeSaxSourceFlowConfig() { this = "XmlParsers::SafeSAXSourceFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(XmlParserCall parse).getSink()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}
