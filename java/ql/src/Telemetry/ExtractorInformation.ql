/**
 * @name Java extraction information
 * @description Information about the extraction for a Java database
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/extraction-information
 */

import java
import semmle.code.java.Diagnostics

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

signature module StatsSig {
  int getNumberOfOk();

  int getNumberOfNotOk();

  string getOkText();

  string getNotOkText();
}

module ReportStats<StatsSig Stats> {
  predicate numberOfOk(string key, int value) {
    value = Stats::getNumberOfOk() and
    key = "Number of " + Stats::getOkText()
  }

  predicate numberOfNotOk(string key, int value) {
    value = Stats::getNumberOfNotOk() and
    key = "Number of " + Stats::getNotOkText()
  }

  predicate percentageOfOk(string key, float value) {
    value = Stats::getNumberOfOk() * 100.0 / (Stats::getNumberOfOk() + Stats::getNumberOfNotOk()) and
    key = "Percentage of " + Stats::getOkText()
  }
}

module CallTargetStats implements StatsSig {
  int getNumberOfOk() { result = count(Call c | exists(c.getCallee())) }

  int getNumberOfNotOk() { result = count(Call c | not exists(c.getCallee())) }

  string getOkText() { result = "calls with call target" }

  string getNotOkText() { result = "calls with missing call target" }
}

private class SourceExpr extends Expr {
  SourceExpr() { this.getFile().isSourceFile() }
}

private predicate hasGoodType(Expr e) {
  exists(e.getType()) and not e.getType() instanceof ErrorType
}

module ExprTypeStats implements StatsSig {
  int getNumberOfOk() { result = count(SourceExpr e | hasGoodType(e)) }

  int getNumberOfNotOk() { result = count(SourceExpr e | not hasGoodType(e)) }

  string getOkText() { result = "expressions with known type" }

  string getNotOkText() { result = "expressions with unknown type" }
}

module CallTargetStatsReport = ReportStats<CallTargetStats>;

module ExprTypeStatsReport = ReportStats<ExprTypeStats>;

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
