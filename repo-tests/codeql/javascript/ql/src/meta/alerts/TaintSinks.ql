/**
 * @name Taint sinks
 * @description Sinks that are sensitive to untrusted data.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/taint-sinks
 * @tags meta
 * @precision very-low
 */

import javascript
import meta.internal.TaintMetrics

from string kind
select relevantTaintSink(kind), kind + " sink"
