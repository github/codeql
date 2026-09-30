import semmle.code.java.dataflow.internal.ExternalFlowExtensions
import codeql.threatmodels.ThreatModels
import codeql.util.AlertFiltering

extensible private predicate threatModelGrouping(string kind, string group);

query predicate threatModelConfigurations(string kind, boolean enable, int priority) {
  threatModelConfiguration(kind, enable, priority)
}

private query predicate threatModelGroupings(string kind, string group) {
  threatModelGrouping(kind, group)
}

query predicate restrictAlertsTos(string filePath, int lineStart, int lineEnd) {
  restrictAlertsTo(filePath, lineStart, lineEnd)
}

query predicate restrictAlertsToExactLocations(
  string filePath, int startLine, int startColumn, int endLine, int endColumn
) {
  restrictAlertsToExactLocation(filePath, startLine, startColumn, endLine, endColumn)
}

/*
 * Note: madId columns are ignored, since renaming extension files causes them to be loaded in a
 * different order, and the generated values in that column do not match as a result.
 */

query predicate barrierGuardModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string acceptingValue, string kind, string provenance
) {
  barrierGuardModel(package, type, subtypes, name, signature, ext, input, acceptingValue, kind,
    provenance, _)
}

query predicate barrierModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
) {
  barrierModel(package, type, subtypes, name, signature, ext, output, kind, provenance, _)
}

query predicate experimentalSinkModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, string filter
) {
  experimentalSinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance,
    filter, _)
}

query predicate experimentalSourceModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, string filter
) {
  experimentalSourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance,
    filter, _)
}

query predicate experimentalSummaryModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, string filter
) {
  experimentalSummaryModel(package, type, subtypes, name, signature, ext, input, output, kind,
    provenance, filter, _)
}

query predicate neutralModels(
  string package, string type, string name, string signature, string kind, string provenance
) {
  neutralModel(package, type, name, signature, kind, provenance)
}

query predicate sinkModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
) {
  sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, _)
}

query predicate sourceModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
) {
  sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance, _)
}

query predicate summaryModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
) {
  summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance, _)
}
