import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.performance.SuperlinearBackTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.regex.RegexTreeView
import semmle.code.java.regex.RegexFlowConfigs
import semmle.code.java.dataflow.FlowSources

class PolynomialRedosSink extends DataFlow::Node {
  RegExpLiteral reg;

  PolynomialRedosSink() { regexMatchedAgainst(reg.getRegex(), this.asExpr()) }

  RegExpTerm getRegExp() { result.getParent() = reg }
}

class PolynomialRedosConfig extends TaintTracking::Configuration {
  PolynomialRedosConfig() { this = "PolynomialRedosConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PolynomialRedosSink }
}

class HasPolyRedos extends InlineExpectationsTest {
  HasPolyRedos() { this = "HasPolyRedos" }

  override string getARelevantTag() { result = ["hasPolyRedos"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasPolyRedos" and
    exists(
      PolynomialRedosConfig config, DataFlow::PathNode source, DataFlow::PathNode sink,
      PolynomialRedosSink sinkNode, PolynomialBackTrackingTerm regexp
    |
      config.hasFlowPath(source, sink) and
      sinkNode = sink.getNode() and
      regexp.getRootTerm() = sinkNode.getRegExp() and
      location = sinkNode.getLocation() and
      element = sinkNode.toString() and
      value = ""
    )
  }
}
