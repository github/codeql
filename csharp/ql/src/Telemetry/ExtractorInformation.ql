/**
 * @name C# extraction information
 * @description Information about the extraction for a C# database
 * @kind metric
 * @tags summary telemetry
 * @id cs/telemetry/extraction-information
 */

import csharp
import semmle.code.csharp.commons.Diagnostics
import DatabaseQuality

predicate compilationInfo(string key, float value) {
  not key.matches("Compiler diagnostic count for%") and
  not key.matches("Extractor message count for group%") and
  exists(Compilation c, string infoKey, string infoValue | infoValue = c.getInfo(infoKey) |
    key = infoKey and
    value = infoValue.toFloat()
    or
    not exists(infoValue.toFloat()) and
    key = infoKey + ": " + infoValue and
    value = 1
  )
}

predicate compilerDiagnostics(string key, int value) {
  key.matches("Compiler diagnostic count for%") and
  strictsum(Compilation c | | c.getInfo(key).toInt()) = value
}

predicate extractorMessages(string key, int value) {
  key.matches("Extractor message count for group%") and
  strictsum(Compilation c | | c.getInfo(key).toInt()) = value
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
  value = strictsum(File f | any() | f.getNumberOfLines())
}

predicate numberOfLinesOfCode(string key, int value) {
  key = "Number of lines of code" and
  value = strictsum(File f | any() | f.getNumberOfLinesOfCode())
}

predicate totalNumberOfLinesByExtension(string key, int value) {
  exists(string extension |
    key = "Total number of lines with extension " + extension and
    value = strictsum(File f | f.getExtension() = extension | f.getNumberOfLines())
  )
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

CompilerError getAmbiguityCompilerError() {
  result.getSeverity() >= 3 and
  result.getTag() = ["CS0101", "CS0104", "CS0111", "CS0121", "CS0229"]
}

predicate numberOfAmbiguityCompilerErrors(string key, int value) {
  value = count(getAmbiguityCompilerError()) and
  key = "Number of compiler reported ambiguity errors"
}

predicate numberOfDistinctAmbiguityCompilerErrorMessages(string key, int value) {
  value = count(getAmbiguityCompilerError().getFullMessage()) and
  key = "Number of compiler reported ambiguity error messages"
}

predicate extractionIsStandalone(string key, int value) {
  (
    value = 1 and
    extractionIsStandalone()
    or
    value = 0 and
    not extractionIsStandalone()
  ) and
  key = "Is extracted with build-mode set to 'none'"
}

module TypeMentionTypeStats implements StatsSig {
  int getNumberOfOk() { result = count(TypeMention t | not t.getType() instanceof UnknownType) }

  int getNumberOfNotOk() { result = count(TypeMention t | t.getType() instanceof UnknownType) }

  string getOkText() { result = "type mentions with known type" }

  string getNotOkText() { result = "type mentions with unknown type" }
}

module AccessTargetStats implements StatsSig {
  int getNumberOfOk() { result = count(Access a | exists(a.getTarget())) }

  int getNumberOfNotOk() { result = count(Access a | not exists(a.getTarget())) }

  string getOkText() { result = "access with target" }

  string getNotOkText() { result = "access with missing target" }
}

module ExprStats implements StatsSig {
  int getNumberOfOk() { result = count(Expr e | not e instanceof @unknown_expr) }

  int getNumberOfNotOk() { result = count(Expr e | e instanceof @unknown_expr) }

  string getOkText() { result = "expressions with known kind" }

  string getNotOkText() { result = "expressions with unknown kind" }
}

module TypeMentionTypeStatsReport = ReportStats<TypeMentionTypeStats>;

module AccessTargetStatsReport = ReportStats<AccessTargetStats>;

module ExprStatsReport = ReportStats<ExprStats>;

predicate analyzerAssemblies(string key, float value) {
  exists(Compilation c, string arg |
    c.getExpandedArgument(_) = arg and
    arg.indexOf("/analyzer:") = 0 and
    key = "CSC analyzer: " + arg.substring(10, arg.length())
  ) and
  value = 1.0
}

from string key, float value
where
  (
    compilationInfo(key, value) or
    compilerDiagnostics(key, value) or
    extractorMessages(key, value) or
    fileCount(key, value) or
    fileCountByExtension(key, value) or
    totalNumberOfLines(key, value) or
    numberOfLinesOfCode(key, value) or
    totalNumberOfLinesByExtension(key, value) or
    numberOfLinesOfCodeByExtension(key, value) or
    extractorDiagnostics(key, value) or
    numberOfAmbiguityCompilerErrors(key, value) or
    numberOfDistinctAmbiguityCompilerErrorMessages(key, value) or
    extractionIsStandalone(key, value) or
    CallTargetStatsReport::numberOfOk(key, value) or
    CallTargetStatsReport::numberOfNotOk(key, value) or
    CallTargetStatsReport::percentageOfOk(key, value) or
    ExprTypeStatsReport::numberOfOk(key, value) or
    ExprTypeStatsReport::numberOfNotOk(key, value) or
    ExprTypeStatsReport::percentageOfOk(key, value) or
    TypeMentionTypeStatsReport::numberOfOk(key, value) or
    TypeMentionTypeStatsReport::numberOfNotOk(key, value) or
    TypeMentionTypeStatsReport::percentageOfOk(key, value) or
    AccessTargetStatsReport::numberOfOk(key, value) or
    AccessTargetStatsReport::numberOfNotOk(key, value) or
    AccessTargetStatsReport::percentageOfOk(key, value) or
    ExprStatsReport::numberOfOk(key, value) or
    ExprStatsReport::numberOfNotOk(key, value) or
    ExprStatsReport::percentageOfOk(key, value) or
    analyzerAssemblies(key, value)
  ) and
  /* Infinity */
  value != 1.0 / 0.0 and
  /* -Infinity */
  value != -1.0 / 0.0 and
  /* NaN */
  value != 0.0 / 0.0
select key, value
