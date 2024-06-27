import java
import semmle.code.java.dataflow.TaintTracking

predicate step(Expr e1, Expr e2) {
  exists(MethodCall ma |
    ma.getMethod().hasName("step") and
    ma = e2 and
    ma.getQualifier() = e1
  )
}

predicate isSink0(Expr sink) {
  exists(MethodCall ma |
    ma.getMethod().hasName("sink") and
    ma.getAnArgument() = sink
  )
}

module FirstConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("src") }

  predicate isSink(DataFlow::Node n) { any() }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    step(n1.asExpr(), n2.asExpr())
  }
}

module FirstFlow = DataFlow::Global<FirstConfig>;

module SecondConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("src") }

  predicate isSink(DataFlow::Node n) { isSink0(n.asExpr()) }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    step(n1.asExpr(), n2.asExpr())
  }
}

module SecondFlow = DataFlow::Global<SecondConfig>;

from int i1, int i2
where
  i1 =
    count(DataFlow::Node src, DataFlow::Node sink |
      FirstFlow::flow(src, sink) and isSink0(sink.asExpr())
    ) and
  i2 = count(DataFlow::Node src, DataFlow::Node sink | SecondFlow::flow(src, sink))
select i1, i2
