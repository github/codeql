import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

predicate src0(Node n) {
  n.asExpr().(MethodAccess).getMethod().hasName("src") or
  n.asExpr().(FieldAccess).getField().hasName("fsrc")
}

predicate sink0(Node n) {
  exists(MethodAccess sink |
    sink.getMethod().hasName("sink") and
    sink.getAnArgument() = n.asExpr()
  )
}

class Conf1 extends Configuration {
  Conf1() { this = "inoutbarriers1" }

  override predicate isSource(Node n) { src0(n) }

  override predicate isSink(Node n) { sink0(n) }
}

class Conf2 extends Configuration {
  Conf2() { this = "inoutbarriers2" }

  override predicate isSource(Node n) { src0(n) }

  override predicate isSink(Node n) { sink0(n) }

  override predicate isBarrierIn(Node n) { src0(n) }
}

class Conf3 extends Configuration {
  Conf3() { this = "inoutbarriers3" }

  override predicate isSource(Node n) { src0(n) }

  override predicate isSink(Node n) { sink0(n) }

  override predicate isBarrierOut(Node n) { sink0(n) }
}

class Conf4 extends Configuration {
  Conf4() { this = "inoutbarriers4" }

  override predicate isSource(Node n) { src0(n) }

  override predicate isSink(Node n) { sink0(n) }

  override predicate isBarrierIn(Node n) { src0(n) }

  override predicate isBarrierOut(Node n) { sink0(n) }
}

predicate flow(Node src, Node sink, string s) {
  any(Conf1 c).hasFlow(src, sink) and s = "nobarrier"
  or
  any(Conf2 c).hasFlow(src, sink) and s = "srcbarrier"
  or
  any(Conf3 c).hasFlow(src, sink) and s = "sinkbarrier"
  or
  any(Conf4 c).hasFlow(src, sink) and s = "both"
}

from Node src, Node sink, string s
where flow(src, sink, _) and s = concat(any(string s0 | flow(src, sink, s0)), ", ")
select src, sink, s
