/**
 * @name Call graph unified
 * @description An edge in the call graph.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/full-call-graph-unified
 * @tags meta
 * @precision very-low
 */

import semmle.javascript.internal.unified.JSUnified
import semmle.javascript.internal.unified.minimal.minimal

from Function f, InvokeExpr invoke, string kind
where
  (
    DataFlowInput::CallGraphOutput::viableCallable(any(DataFlowInput::DataFlowCall c |
        c.asSourceCall().getUnderlyingInvokeExpr() = invoke
      )).asSourceCallable() = f and
    kind = "Call"
    or
    none() and kind = "Accessor call"
  ) and
  not f.getTopLevel().isExterns()
select invoke, kind + " to $@", f, f.toString()
