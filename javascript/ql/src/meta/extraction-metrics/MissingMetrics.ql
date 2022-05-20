/**
 * @name File with missing extraction metrics
 * @description A file missing extraction metrics is indicative of a faulty extractor.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id js/meta/extraction/missing-metrics
 * @tags meta
 */

import javascript
import semmle.javascript.meta.ExtractionMetrics::ExtractionMetrics

from File f, string cause
where
  not extraction_data(f, _, _, _) and cause = "No extraction_data for this file"
  or
  not extraction_time(f, _, _, _) and cause = "No extraction_time for this file"
select f, cause
