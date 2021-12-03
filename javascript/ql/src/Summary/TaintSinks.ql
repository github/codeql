/**
 * @name Taint sinks
 * @description Expressions that are vulnerable if containing untrusted data.
 * @kind problem
 * @problem.severity info
 * @id js/summary/taint-sinks
 * @tags summary
 * @precision medium
 */

import javascript
import meta.internal.TaintMetrics

from string kind
select relevantTaintSink(kind), kind + " sink"
