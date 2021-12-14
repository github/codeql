/**
 * @name Route handlers
 * @description The number of HTTP route handler functions found.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/route-handlers
 */

import javascript
import CallGraphQuality

HTTP::RouteHandler relevantRouteHandler() { not result.getFile() instanceof IgnoredFile }

select projectRoot(), count(relevantRouteHandler())
