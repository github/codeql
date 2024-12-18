import java
import semmle.code.java.dataflow.DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(StringLiteral).getValue() = "Source" }

  predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

module Flow = DataFlow::Global<Config>;

query predicate isFinalField(Field f) {
  exists(FieldDeclaration f2 | f = f2.getAField()) and f.isFinal()
}

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
