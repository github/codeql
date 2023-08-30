/**
 * @name Number of alerts per sink model and query
 * @description Counts the number of alerts per query using `ai-generated` sink models.
 * @kind table
 * @id java/ml/metrics-count-alerts-per-sink-model-and-query
 * @tags internal automodel metrics
 */

private import java
private import AutomodelAlertSinkUtil

from string queryId, int alertCount, SinkModel s
where
  sinkModelTallyPerQuery(queryId, alertCount, s) and
  s.getProvenance() = "ai-generated"
select queryId, alertCount, s.getPackage() as package, s.getType() as type,
  s.getSubtypes() as subtypes, s.getName() as name, s.getSignature() as signature,
  s.getInput() as input, s.getExt() as ext, s.getKind() as kind, s.getProvenance() as provenance
  order by queryId, alertCount desc
