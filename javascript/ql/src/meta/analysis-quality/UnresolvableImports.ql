/**
 * @name Unresolvable imports
 * @description The number of imports that could not be resolved to a module.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/unresolvable-imports
 */

import javascript
import CallGraphQuality

Import unresolvableImport() { not exists(result.getImportedModule()) }

select projectRoot(), count(unresolvableImport())
