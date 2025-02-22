import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS
import semmle.code.java.security.UrlRedirect
import utils.test.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodCall).getMethod().hasName("taint")
    or
    n instanceof ActiveThreatModelSource
  }

  predicate isSink(DataFlow::Node n) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
    or
    n instanceof XssSink
    or
    n instanceof UrlRedirectSink
  }
}

import TaintFlowTest<Config>
