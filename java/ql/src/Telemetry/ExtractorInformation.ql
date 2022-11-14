/**
 * @name Java extraction information
 * @description Information about the extraction for a Java database
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/extraction-information
 */

import java
import semmle.code.java.Diagnostics

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

from string key, int value
where
  fileCount(key, value) or
  fileCountByExtension(key, value) or
  totalNumberOfLines(key, value) or
  numberOfLinesOfCode(key, value) or
  totalNumberOfLinesByExtension(key, value) or
  numberOfLinesOfCodeByExtension(key, value) or
  extractorDiagnostics(key, value)
select key, value
