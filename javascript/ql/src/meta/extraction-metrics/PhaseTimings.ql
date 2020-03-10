/**
 * @name Extractor phase timings
 * @description An overview of how time was spent during extraction
 * @kind table
 * @id js/meta/extraction/phase-timings
 * @tags meta
 */

import semmle.javascript.meta.ExtractionMetrics::ExtractionMetrics

from PhaseName phaseName
select phaseName, Aggregated::getCpuTime(phaseName) as CPU_NANO,
  Aggregated::getWallclockTime(phaseName) as WALLCLOCK_NANO
