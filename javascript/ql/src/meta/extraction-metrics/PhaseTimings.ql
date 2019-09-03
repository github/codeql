/**
 * @name Extractor phase timings
 * @description An overview of how time was spent during extraction
 * @kind table
 * @id js/meta/extraction/phase-timings
 */

import semmle.javascript.meta.ExtractionMetrics::ExtractionMetrics

from PhaseName phaseName, float cpuTime, int cpuPerc
where
  cpuTime = Aggregated::getCpuTime(phaseName) and
  cpuPerc = ((cpuTime / Aggregated::getCpuTime()) * 100).floor()
select phaseName, cpuTime as CPU_NANO, cpuPerc as CPU_PERC
