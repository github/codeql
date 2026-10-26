/**
 * @name Resolvable imports
 * @description The number of imports that could be resolved to its target.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/resolvable-imports
 */

import javascript
import CallGraphQuality

Import relevantImport() { not result.getFile() instanceof IgnoredFile }

select projectRoot(),
  count(Import imprt | imprt = relevantImport() and exists(imprt.getImportedModule()))
