/**
 * @name Cyclic namespaces
 * @description Shows namespaces that cyclically depend on one another.
 * @kind graph
 * @id cpp/architecture/cyclic-namespaces
 * @graph.layout hierarchical
 * @tags maintainability
 *       modularity
 */

import cpp

from MetricNamespace a, MetricNamespace b
where a.getANamespaceDependency() = b and b.getANamespaceDependency*() = a
select a, b
