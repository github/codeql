import semmle.code.java.dataflow.FlowSources

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UserInput }

  predicate isSink(DataFlow::Node sink) { any() }
}

module Flow = TaintTracking::Global<Config>;

from Expr tainted, Method method
where
  Flow::flowToExpr(tainted) and
  tainted.getEnclosingCallable() = method and
  tainted.getFile().getStem() = ["Test", "Validation"]
select method, tainted.getLocation().getStartLine() - method.getLocation().getStartLine(), tainted
