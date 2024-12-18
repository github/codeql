import java
import semmle.code.java.controlflow.Paths

class PathTestConf extends ActionConfiguration {
  PathTestConf() { this = "PathTestConf" }

  override predicate isAction(ControlFlowNode node) {
    node.asExpr().(MethodCall).getMethod().hasName("action")
  }
}

from Callable c, PathTestConf conf
where conf.callableAlwaysPerformsAction(c)
select c
