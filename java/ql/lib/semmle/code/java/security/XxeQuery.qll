/** Provides default definitions to be used in XXE queries. */

import java
private import semmle.code.java.dataflow.TaintTracking2
private import semmle.code.java.security.XmlParsers
import semmle.code.java.security.Xxe

/**
 * The default implementation of a XXE sink.
 * The argument of a parse call on an insecurely configured XML parser.
 */
private class DefaultXxeSink extends XxeSink {
  DefaultXxeSink() {
    not exists(SafeSaxSourceFlowConfig safeSource | safeSource.hasFlowTo(this)) and
    exists(XmlParserCall parse |
      parse.getSink() = this.asExpr() and
      not parse.isSafe()
    )
  }
}

/**
 * A taint-tracking configuration for safe XML readers used to parse XML documents.
 */
private class SafeSaxSourceFlowConfig extends TaintTracking2::Configuration {
  SafeSaxSourceFlowConfig() { this = "SafeSaxSourceFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(XmlParserCall parse).getSink()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}
