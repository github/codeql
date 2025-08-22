/**
 * @name Summarized callable call sites
 * @description A call site for which we have a summarized callable
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/summarized-callable-call-sites
 * @tags meta
 * @precision very-low
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.FlowSummary
import meta.MetaMetrics

from DataFlow::Node useSite, SummarizedCallable target, string kind
where
  (
    useSite = target.getACall() and kind = "Call"
    or
    useSite = target.getACallback() and kind = "Callback"
  ) and
  not useSite.getLocation().getFile() instanceof IgnoredFile
select useSite, kind + " to " + target
