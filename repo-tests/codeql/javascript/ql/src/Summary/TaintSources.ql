/**
 * @name Taint sources
 * @description Sources of untrusted input.
 * @kind problem
 * @problem.severity info
 * @id js/summary/taint-sources
 * @tags summary
 * @precision medium
 */

import javascript
import meta.internal.TaintMetrics

from RemoteFlowSource node
where node = relevantTaintSource()
select node, node.getSourceType()
