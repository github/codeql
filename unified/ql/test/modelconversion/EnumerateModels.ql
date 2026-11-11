import codeql.unified.internal.mad.LegacyMaD

query predicate legacySourceModels(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
) {
  legacySourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance)
}

query predicate legacySinkModels(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
) {
  legacySinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance)
}

query predicate legacySummaryModels(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
) {
  legacySummaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind,
    provenance)
}
