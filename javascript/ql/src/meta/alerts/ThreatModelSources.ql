/**
 * @name Threat model sources
 * @description Sources of possibly untrusted input that can be configured via threat models.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/threat-model-sources
 * @tags meta
 * @precision very-low
 */

import javascript
import meta.internal.TaintMetrics

from ThreatModelSource node, string threatModel
where
  node = relevantTaintSource() and
  threatModel = node.getThreatModel() and
  threatModel != "remote" // "remote" is reported by TaintSources.ql
select node, getTaintSourceName(node) + " (\"" + threatModel + "\" threat model)"
