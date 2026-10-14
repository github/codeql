import java
import semmle.code.java.security.RequestForgery
import semmle.code.java.security.UrlRedirect
import semmle.code.java.security.ResponseSplitting
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
    n instanceof RequestForgerySink
    or
    n instanceof UrlRedirectSink
    or
    n instanceof HeaderSplittingSink
  }
}

import TaintFlowTest<Config>
