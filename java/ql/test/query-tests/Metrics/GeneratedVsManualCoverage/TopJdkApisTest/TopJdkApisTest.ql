import java
import Metrics.Summaries.GeneratedVsManualCoverageQuery

from
  string package, int generatedOnly, int both, int manualOnly, int non, int all, float coverage,
  float generatedCoverage, float manualCoverage, float manualCoveredByGenerated,
  float generatedCoveredByManual, float match
where
  modelCoverageGenVsMan(package, generatedOnly, both, manualOnly, non, all, coverage,
    generatedCoverage, manualCoverage, manualCoveredByGenerated, generatedCoveredByManual, match,
    "topJdkApis")
select package, generatedOnly, both, manualOnly, non, all, coverage, generatedCoverage,
  manualCoverage, manualCoveredByGenerated, generatedCoveredByManual, match order by package
