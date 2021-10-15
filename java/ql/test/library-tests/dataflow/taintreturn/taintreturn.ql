import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow

predicate step(Expr e1, Expr e2) {
  exists(MethodAccess ma |
    ma.getMethod().hasName("step") and
    ma = e2 and
    ma.getQualifier() = e1
  )
}

predicate isSink0(Expr sink) {
  exists(MethodAccess ma |
    ma.getMethod().hasName("sink") and
    ma.getAnArgument() = sink
  )
}

class Conf1 extends Configuration {
  Conf1() { this = "testconf1" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("src") }

  override predicate isSink(Node n) { any() }

  override predicate isAdditionalFlowStep(Node n1, Node n2) { step(n1.asExpr(), n2.asExpr()) }
}

class Conf2 extends Configuration {
  Conf2() { this = "testconf2" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("src") }

  override predicate isSink(Node n) { isSink0(n.asExpr()) }

  override predicate isAdditionalFlowStep(Node n1, Node n2) { step(n1.asExpr(), n2.asExpr()) }
}

from int i1, int i2
where
  i1 = count(Node src, Node sink, Conf1 c | c.hasFlow(src, sink) and isSink0(sink.asExpr())) and
  i2 = count(Node src, Node sink, Conf2 c | c.hasFlow(src, sink))
select i1, i2
