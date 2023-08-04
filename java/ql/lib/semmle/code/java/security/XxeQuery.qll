/** Provides default definitions to be used in XXE queries. */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.XmlParsers
import semmle.code.java.security.Xxe

/**
 * The default implementation of a XXE sink.
 * The argument of a parse call on an insecurely configured XML parser.
 */
private class DefaultXxeSink extends XxeSink {
  DefaultXxeSink() {
    not SafeSaxSourceFlow::flowTo(this) and
    exists(XmlParserCall parse |
      parse.getSink() = this.asExpr() and
      not parse.isSafe()
    )
  }
}

/**
 * A taint-tracking configuration for safe XML readers used to parse XML documents.
 */
private module SafeSaxSourceFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxSource }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(XmlParserCall parse).getSink() }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeSaxSourceFlow = TaintTracking::Global<SafeSaxSourceFlowConfig>;
