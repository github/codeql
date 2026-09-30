import semmle.code.java.dataflow.internal.ExternalFlowExtensions

query predicate barrierGuardModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string acceptingValue, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  barrierGuardModel(package, type, subtypes, name, signature, ext, input, acceptingValue, kind,
    provenance, madId)
}

query predicate barrierModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  barrierModel(package, type, subtypes, name, signature, ext, output, kind, provenance, madId)
}

query predicate experimentalSinkModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, string filter, QlBuiltins::ExtensionId madId
) {
  experimentalSinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance,
    filter, madId)
}

query predicate experimentalSourceModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, string filter, QlBuiltins::ExtensionId madId
) {
  experimentalSourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance,
    filter, madId)
}

query predicate experimentalSummaryModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, string filter,
  QlBuiltins::ExtensionId madId
) {
  experimentalSummaryModel(package, type, subtypes, name, signature, ext, input, output, kind,
    provenance, filter, madId)
}

query predicate neutralModels(
  string package, string type, string name, string signature, string kind, string provenance
) {
  neutralModel(package, type, name, signature, kind, provenance)
}

query predicate sinkModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, madId)
}

query predicate sourceModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance, madId)
}

query predicate summaryModels(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance, madId)
}
