private import iac
private import codeql.iac.YamlDocumentClassification

query predicate supportedYamlDocument(
  YamlDocumentClassification::YamlSyntaxDocument doc, YamlDocumentClassification::DocumentKind kind
) {
  YamlDocumentClassification::isSupportedYamlDocument(doc, kind)
}

query predicate allYamlDocuments(YamlDocument doc) { any() }
