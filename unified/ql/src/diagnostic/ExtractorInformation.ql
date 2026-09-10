/**
 * @name Unified extractor/analysis information
 * @description Information about the extraction and analysis for a database
 * @kind metric
 * @tags summary telemetry
 * @id unified/telemetry/extraction-information
 */

private import unified
private import codeql.unified.internal.AnalysisQuality

predicate fileCount(string key, int value) {
  key = "Number of files" and
  value = strictcount(File f)
}

predicate fileCountByExtension(string key, int value) {
  exists(string extension |
    key = "Number of files with extension " + extension and
    value = strictcount(File f | f.getExtension() = extension)
  )
}

predicate numberOfLinesOfCode(string key, int value) {
  key = "Number of lines of code" and
  value = strictsum(File f | any() | f.getNumberOfLinesOfCode())
}

predicate numberOfLinesOfCodeByExtension(string key, int value) {
  exists(string extension |
    key = "Number of lines of code with extension " + extension and
    value = strictsum(File f | f.getExtension() = extension | f.getNumberOfLinesOfCode())
  )
}

from string key, float value
where
  (
    fileCount(key, value) or
    fileCountByExtension(key, value) or
    numberOfLinesOfCode(key, value) or
    numberOfLinesOfCodeByExtension(key, value) or
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
