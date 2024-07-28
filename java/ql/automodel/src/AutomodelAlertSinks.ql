/**
 * @name Number of alerts per sink model
 * @description Counts the number of alerts using `ai-generated` sink models.
 * @kind table
 * @id java/ml/metrics-count-alerts-per-sink-model
 * @tags internal automodel metrics
 */

private import java
private import AutomodelAlertSinkUtil

from int alertCount, SinkModel s
where sinkModelTally(alertCount, s) and s.getProvenance() = "ai-generated"
select alertCount, s.getPackage() as package, s.getType() as type, s.getSubtypes() as subtypes,
  s.getName() as name, s.getSignature() as signature, s.getInput() as input, s.getExt() as ext,
  s.getKind() as kind, s.getProvenance() as provenance order by alertCount desc
