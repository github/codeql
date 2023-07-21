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

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node x) {
    x.asExpr() instanceof IntegerLiteral and x.getEnclosingCallable().fromSource()
  }

  predicate isSink(DataFlow::Node x) {
    x.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
