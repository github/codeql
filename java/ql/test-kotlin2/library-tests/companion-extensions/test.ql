import java
import semmle.code.java.dataflow.TaintTracking

predicate isCompanionCallable(Callable callable) {
  callable.getName() = ["empty", "create", "getDefault"]
}

query predicate declarations(
  Callable callable, RefType declaringType, string primaryClass, string signature
) {
  isCompanionCallable(callable) and
  callable.fromSource() and
  declaringType = callable.getDeclaringType() and
  primaryClass = callable.getAPrimaryQlClass() and
  signature = callable.getSignature()
}

query predicate calls(MethodCall call, Callable caller, Method target, Expr qualifier) {
  caller.fromSource() and
  call.getEnclosingCallable() = caller and
  target = call.getMethod() and
  isCompanionCallable(target) and
  qualifier = call.getQualifier()
}

query predicate properties(Property property, RefType declaringType, Method getter) {
  property.hasName("default") and
  property.fromSource() and
  getter = property.getGetter() and
  declaringType = getter.getDeclaringType()
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("source") }

  predicate isSink(DataFlow::Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
