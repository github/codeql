import semmle.code.csharp.frameworks.Sql
import semmle.code.csharp.dataflow.ExternalFlow
import semmle.code.csharp.dataflow.internal.DataFlowPublic

query predicate sqlExpressions(SqlExpr se, Expr e) { se.getSql() = e }

query predicate sqlCsvSinks(Element p, Expr e) {
  p = e.getParent() and
  exists(Node n |
    sinkNode(n, "sql") and
    n.asExpr() = e
  )
}
