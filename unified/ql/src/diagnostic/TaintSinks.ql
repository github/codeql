/**
 * @name Taint sinks
 * @description Taint sinks
 * @kind problem
 * @problem.severity recommendation
 * @id unified/diagnostic/taint-sinks
 * @tags meta
 * @precision very-low
 */

import unified

from DataFlow::Node node, string kind
where Models::isSink(node, kind)
select node, "Sink of kind '" + kind + "'"
