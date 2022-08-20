import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS
import semmle.code.java.security.UrlRedirect
import TestUtilities.InlineFlowTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:frameworks:apache-http" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
    or
    n instanceof RemoteFlowSource
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
    or
    n instanceof XssSink
    or
    n instanceof UrlRedirectSink
  }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override DataFlow::Configuration getTaintFlowConfig() { result = any(Conf c) }
}
