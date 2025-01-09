/**
 * @name Taint sources
 * @description Sources of untrusted input.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/taint-sources
 * @tags meta
 * @precision very-low
 */

import javascript
import meta.internal.TaintMetrics

from DataFlow::Node node
where node = relevantTaintSource()
select node, getTaintSourceName(node)
