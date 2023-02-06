import java
import semmle.code.java.dataflow.DataFlow

class Config extends DataFlow::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node n) { n.asExpr().(StringLiteral).getValue() = "Source" }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

query predicate isFinalField(Field f) {
  exists(FieldDeclaration f2 | f = f2.getAField()) and f.isFinal()
}

from DataFlow::Node source, DataFlow::Node sink
where any(Config c).hasFlow(source, sink)
select source, sink
