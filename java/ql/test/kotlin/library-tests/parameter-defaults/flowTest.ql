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

class Config extends DataFlow::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr() instanceof ShouldBeSunk or
    n.asExpr() instanceof ShouldNotBeSunk
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

predicate isSunk(StringLiteral sl) {
  exists(Config c, DataFlow::Node source | c.hasFlow(source, _) and sl = source.asExpr())
}

query predicate shouldBeSunkButIsnt(ShouldBeSunk src) { not isSunk(src) }

query predicate shouldntBeSunkButIs(ShouldNotBeSunk src) { isSunk(src) }
