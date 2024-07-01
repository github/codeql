/**
 * @name Java extraction information
 * @description Information about the extraction for a Java database
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/extraction-information
 */

import java
import semmle.code.java.Diagnostics
import DatabaseQuality

extensible predicate extractorInformationSkipKey(string key);

predicate compilationInfo(string key, int value) {
  exists(Compilation c, string infoKey |
    key = infoKey + ": " + c.getInfo(infoKey) and
    value = 1
  )
}

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

predicate totalNumberOfLines(string key, int value) {
  key = "Total number of lines" and
  value = strictsum(File f | any() | f.getTotalNumberOfLines())
}

predicate numberOfLinesOfCode(string key, int value) {
  key = "Number of lines of code" and
  value = strictsum(File f | any() | f.getNumberOfLinesOfCode())
}

predicate totalNumberOfLinesByExtension(string key, int value) {
  exists(string extension |
    key = "Total number of lines with extension " + extension and
    value = strictsum(File f | f.getExtension() = extension | f.getTotalNumberOfLines())
  )
}

predicate numberOfLinesOfCodeByExtension(string key, int value) {
  exists(string extension |
    key = "Number of lines of code with extension " + extension and
    value = strictsum(File f | f.getExtension() = extension | f.getNumberOfLinesOfCode())
  )
}

predicate extractorDiagnostics(string key, int value) {
  exists(string extractor, int severity |
    key = "Number of diagnostics from " + extractor + " with severity " + severity.toString() and
    value =
      strictcount(Diagnostic d | d.getGeneratedBy() = extractor and d.getSeverity() = severity)
  )
}

/*
 * Just counting the diagnostics doesn't give the full picture, as
 * CODEQL_EXTRACTOR_KOTLIN_DIAGNOSTIC_LIMIT means that some diagnostics
 * will be suppressed. In that case, we need to look for the
 * suppression message, uncount those that did get emitted, uncount the
 * suppression message itself, and then add on the full count.
 */

predicate extractorTotalDiagnostics(string key, int value) {
  exists(string extractor, string limitRegex |
    limitRegex = "Total of ([0-9]+) diagnostics \\(reached limit of ([0-9]+)\\).*" and
    key = "Total number of diagnostics from " + extractor and
    value =
      strictcount(Diagnostic d | d.getGeneratedBy() = extractor) +
        sum(Diagnostic d |
          d.getGeneratedBy() = extractor
        |
          d.getMessage().regexpCapture(limitRegex, 1).toInt() -
              d.getMessage().regexpCapture(limitRegex, 2).toInt() - 1
        )
  )
}

from string key, int value
where
  not exists(string pattern | extractorInformationSkipKey(pattern) and key.matches(pattern)) and
  (
    compilationInfo(key, value) or
    fileCount(key, value) or
    fileCountByExtension(key, value) or
    totalNumberOfLines(key, value) or
    numberOfLinesOfCode(key, value) or
    totalNumberOfLinesByExtension(key, value) or
    numberOfLinesOfCodeByExtension(key, value) or
    extractorDiagnostics(key, value) or
    extractorTotalDiagnostics(key, value) or
    CallTargetStatsReport::numberOfOk(key, value) or
    CallTargetStatsReport::numberOfNotOk(key, value) or
    CallTargetStatsReport::percentageOfOk(key, any(float x | value = x.floor())) or
    ExprTypeStatsReport::numberOfOk(key, value) or
    ExprTypeStatsReport::numberOfNotOk(key, value) or
    ExprTypeStatsReport::percentageOfOk(key, any(float x | value = x.floor()))
  )
select key, value
