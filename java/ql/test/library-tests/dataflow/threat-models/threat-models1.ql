import codeql.threatmodels.ThreatModels as ThreatModels

query predicate supportedThreatModels(string kind) {
  ThreatModels::currentThreatModel(kind)
}
