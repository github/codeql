/**
 * @name Namespace dependencies
 * @description Shows dependencies between namespaces as a hierarchical graph.
 * @kind graph
 * @id cpp/architecture/namespace-dependencies
 * @graph.layout hierarchical
 * @tags maintainability
 *       modularity
 */

import cpp

from MetricNamespace a, MetricNamespace b
where a.getANamespaceDependency() = b
select a, b
