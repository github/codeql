import java
import semmle.code.java.dataflow.DataFlow

query predicate callables(Callable c, RefType declType, string kind) {
  c.fromSource() and
  declType = c.getDeclaringType() and
  (
    kind = c.compilerGeneratedReason()
    or
    not exists(c.compilerGeneratedReason()) and kind = "from source"
  )
}

query predicate superAccesses(
  SuperAccess sa, RefType enclosingType, Callable enclosingCallable, Expr qualifier
) {
  sa.getQualifier() = qualifier and
  enclosingCallable = sa.getEnclosingCallable() and
  enclosingType = enclosingCallable.getDeclaringType()
}

class Config extends DataFlow::Configuration {
  Config() { this = "testconfig" }

  override predicate isSource(DataFlow::Node x) {
    x.asExpr() instanceof IntegerLiteral and x.getEnclosingCallable().fromSource()
  }

  override predicate isSink(DataFlow::Node x) {
    x.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

from Config c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select source, sink
