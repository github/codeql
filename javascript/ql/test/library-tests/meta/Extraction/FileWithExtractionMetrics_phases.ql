import semmle.javascript.meta.ExtractionMetrics::ExtractionMetrics

from FileWithExtractionMetrics f, PhaseName phase
where
  exists(f.getCpuTime(phase)) and
  exists(f.getWallclockTime(phase))
select f, phase
