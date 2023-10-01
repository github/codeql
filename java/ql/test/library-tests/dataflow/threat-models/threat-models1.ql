import semmle.code.java.dataflow.ExternalFlowConfiguration as ExternalFlowConfiguration

query predicate supportedThreatModels(string kind) {
  ExternalFlowConfiguration::sourceModelKindConfig(kind)
}
