/**
 * @name Taint sinks
 * @description Sinks that are sensitive to untrusted data.
 * @kind problem
 * @problem.severity recommendation
 * @id rb/meta/taint-sinks
 * @tags meta
 * @precision very-low
 */

import internal.TaintMetrics

from string kind
select relevantTaintSink(kind), kind + " sink"
