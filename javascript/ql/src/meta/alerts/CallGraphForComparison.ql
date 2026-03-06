/**
 * @name Call graph for comparison
 * @description An edge in the call graph.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/call-graph-for-comparison
 * @tags meta
 * @precision very-low
 */

import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate

from InvokeExpr invoke, Function f, string kind
where
  viableCallable(any(DataFlowCall call | call.asOrdinaryCall().getInvokeExpr() = invoke))
      .asSourceCallable() = f and
  kind = "Call" and
  not f.getTopLevel().isExterns()
select invoke, kind + " to $@", f, f.toString()
