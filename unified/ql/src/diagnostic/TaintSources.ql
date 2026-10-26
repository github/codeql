/**
 * @name Taint sources
 * @description Taint sources
 * @kind problem
 * @problem.severity recommendation
 * @id unified/diagnostic/taint-sources
 * @tags meta
 * @precision very-low
 */

import unified

from DataFlow::Node node, string kind
where Models::isSource(node, kind)
select node, "Source of kind '" + kind + "'"
