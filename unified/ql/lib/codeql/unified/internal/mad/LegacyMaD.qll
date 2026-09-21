private import unified

extensible predicate legacySourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
);

extensible predicate legacySinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
);

extensible predicate legacySummaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
);
