import java
import semmle.code.java.dataflow.DataFlow

class ShouldNotBeSunk extends StringLiteral {
  ShouldNotBeSunk() { this.getValue().matches("%not sunk%") }
}

class ShouldBeSunk extends StringLiteral {
  ShouldBeSunk() {
    this.getValue().matches("%sunk%") and
    not this instanceof ShouldNotBeSunk
  }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    n.asExpr() instanceof ShouldBeSunk or
    n.asExpr() instanceof ShouldNotBeSunk
  }

  predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

module Flow = DataFlow::Global<Config>;

predicate isSunk(StringLiteral sl) {
  exists(DataFlow::Node source | Flow::flow(source, _) and sl = source.asExpr())
}

query predicate shouldBeSunkButIsnt(ShouldBeSunk src) { not isSunk(src) }

query predicate shouldntBeSunkButIs(ShouldNotBeSunk src) { isSunk(src) }
