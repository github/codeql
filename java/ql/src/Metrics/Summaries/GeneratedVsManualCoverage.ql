/**
 * @id java/summary/generated-vs-manual-coverage
 * @name Metrics of generated versus manual MaD coverage
 * @description Expose metrics for the number of API endpoints covered by generated versus manual MaD models.
 * @kind table
 * @tags summary
 */

import java
import GeneratedVsManualCoverageQuery

from
  string package, int generatedOnly, int both, int manualOnly, int non, int all, float coverage,
  float generatedCoverage, float manualCoverage, float manualCoveredByGenerated,
  float generatedCoveredByManual, float match
where
  modelCoverageGenVsMan(package, generatedOnly, both, manualOnly, non, all, coverage,
    generatedCoverage, manualCoverage, manualCoveredByGenerated, generatedCoveredByManual, match,
    "allApis")
select package, generatedOnly, both, manualOnly, non, all, coverage, generatedCoverage,
  manualCoverage, manualCoveredByGenerated, generatedCoveredByManual, match order by package
