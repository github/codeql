/**
 * @name Types with qualified name
 * @description The number of type annotations with a qualified name
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/types-with-qualified-name
 */

import javascript
import meta.MetaMetrics

select projectRoot(), count(TypeAnnotation t | t.hasQualifiedName(_) or t.hasQualifiedName(_, _))
