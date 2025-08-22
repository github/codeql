/**
 * @name Rust extraction information
 * @description Information about the extraction for a Rust database
 * @kind metric
 * @tags summary telemetry
 * @id rust/telemetry/extraction-information
 */

import rust
import DatabaseQuality
import RustAnalyzerComparison
import codeql.rust.Diagnostics

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

predicate extractorDiagnostics(string key, int value) {
  exists(int severity |
    key = "Number of diagnostics with severity " + severity.toString() and
    value = strictcount(Diagnostic d | d.getSeverity() = severity)
  )
}

predicate pathResolutionCompare(string key, int value) {
  exists(string suffix |
    PathResolutionCompare::summary(suffix, value) and
    key = "Rust-analyzer path resolution comparison: " + suffix
  )
}

predicate callGraphCompare(string key, int value) {
  exists(string suffix |
    CallGraphCompare::summary(suffix, value) and
    key = "Rust-analyzer call graph comparison: " + suffix
  )
}

from string key, float value
where
  (
    fileCount(key, value) or
    fileCountByExtension(key, value) or
    numberOfLinesOfCode(key, value) or
    numberOfLinesOfCodeByExtension(key, value) or
    extractorDiagnostics(key, value) or
    CallTargetStatsReport::numberOfOk(key, value) or
    CallTargetStatsReport::numberOfNotOk(key, value) or
    CallTargetStatsReport::percentageOfOk(key, value) or
    MacroCallTargetStatsReport::numberOfOk(key, value) or
    MacroCallTargetStatsReport::numberOfNotOk(key, value) or
    MacroCallTargetStatsReport::percentageOfOk(key, value) or
    pathResolutionCompare(key, value) or
    callGraphCompare(key, value)
  ) and
  /* Infinity */
  value != 1.0 / 0.0 and
  /* -Infinity */
  value != -1.0 / 0.0 and
  /* NaN */
  value != 0.0 / 0.0
select key, value
