import java
import semmle.code.java.dataflow.DataFlow

class Conf extends DataFlow::Configuration {
  Conf() { this = "qltest:exprStmtFlow" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(ClassInstanceExpr).getType().(RefType).getASupertype*().hasName("Source")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

from DataFlow::Node src, DataFlow::Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
