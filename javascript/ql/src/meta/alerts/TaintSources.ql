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

string getName(DataFlow::Node node) {
  result = node.(RemoteFlowSource).getSourceType()
  or
  not node instanceof RemoteFlowSource and
  result = "Taint source"
}

from DataFlow::Node node
where node = relevantTaintSource()
select node, getName(node)
