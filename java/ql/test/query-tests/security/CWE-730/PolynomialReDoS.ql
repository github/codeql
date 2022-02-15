import java
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTest
import semmle.code.java.security.performance.SuperlinearBackTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.regex.RegexTreeView
import semmle.code.java.regex.RegexFlowConfigs
import semmle.code.java.dataflow.FlowSources

class PolynomialRedosSink extends DataFlow::Node {
  RegExpLiteral reg;

  PolynomialRedosSink() { regexMatchedAgainst(reg.getRegex(), this.asExpr()) }
  // RegExpTerm getRegExp() { result = reg }
}

class PolynomialRedosConfig extends TaintTracking::Configuration {
  PolynomialRedosConfig() { this = "PolynomialRodisConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PolynomialRedosSink }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { result = any(PolynomialRedosConfig c) }

  override DataFlow::Configuration getValueFlowConfig() { none() }
}
