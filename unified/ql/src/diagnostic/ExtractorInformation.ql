/**
 * @name Unified extractor/analysis information
 * @description Information about the extraction and analysis for a database
 * @kind metric
 * @tags summary telemetry
 * @id unified/telemetry/extraction-information
 */

private import unified
private import codeql.unified.internal.AnalysisQuality

from string key, float value
where
  (
    StaticNameResolutionStatsReport::keyValuePair(key, value) or
    FilesCoveredByModuleManifestStatsReport::keyValuePair(key, value)
  ) and
  /* Infinity */
  value != 1.0 / 0.0 and
  /* -Infinity */
  value != -1.0 / 0.0 and
  /* NaN */
  value != 0.0 / 0.0
select key, value
