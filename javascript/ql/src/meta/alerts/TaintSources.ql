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

from ThreatModelSource node
where node = relevantTaintSource() and node.getThreatModel() = "remote"
select node, getTaintSourceName(node)
