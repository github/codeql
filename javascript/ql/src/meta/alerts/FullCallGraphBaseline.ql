/**
 * @name Call graph baseline
 * @description An edge in the call graph.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/full-call-graph
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
