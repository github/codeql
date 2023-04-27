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

module Conf1 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }
}

module Conf2 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }

  predicate isBarrierIn(Node n) { src0(n) }
}

module Conf3 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }

  predicate isBarrierOut(Node n) { sink0(n) }
}

module Conf4 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }

  predicate isBarrierIn(Node n) { src0(n) }

  predicate isBarrierOut(Node n) { sink0(n) }
}

predicate flow(Node src, Node sink, string s) {
  Global<Conf1>::flow(src, sink) and s = "nobarrier"
  or
  Global<Conf2>::flow(src, sink) and s = "srcbarrier"
  or
  Global<Conf3>::flow(src, sink) and s = "sinkbarrier"
  or
  Global<Conf4>::flow(src, sink) and s = "both"
}

from Node src, Node sink, string s
where flow(src, sink, _) and s = concat(any(string s0 | flow(src, sink, s0)), ", ")
select src, sink, s
