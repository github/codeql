/**
 * @name Nodes with underlying type
 * @description Nodes that has an underlying type coming from a package.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/nodes-with-underlying-type
 * @tags meta-disabled
 * @precision very-low
 */

import javascript

from DataFlow::SourceNode sn, string mod, string name
where sn.hasUnderlyingType(mod, name)
select sn, "'" + mod + "'." + name
