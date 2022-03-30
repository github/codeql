import semmle.code.java.dataflow.FlowSources

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:cwe-089:taintedString" }

  override predicate isSource(DataFlow::Node source) { source instanceof UserInput }

  override predicate isSink(DataFlow::Node sink) { any() }
}

from Conf conf, Expr tainted, Method method
where
  conf.hasFlowToExpr(tainted) and
  tainted.getEnclosingCallable() = method and
  tainted.getFile().getStem() = ["Test", "Validation"]
select method, tainted.getLocation().getStartLine() - method.getLocation().getStartLine(), tainted
