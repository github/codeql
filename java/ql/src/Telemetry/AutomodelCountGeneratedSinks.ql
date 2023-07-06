/**
 * @name Number of instances of each sink model
 * @description Counts the number of instances of `ai-generated` sink models.
 * @kind table
 * @id java/ml/metrics-count-instances-per-sink-model
 * @tags internal automodel metrics
 */

private import java
private import AutomodelAlertSinkUtil

from int instanceCount, SinkModel s
where
  instanceCount = s.getInstanceCount() and
  instanceCount > 0 and
  s.getProvenance() = "ai-generated"
select instanceCount, s.getPackage() as package, s.getType() as type, s.getSubtypes() as subtypes,
  s.getName() as name, s.getSignature() as signature, s.getInput() as input, s.getExt() as ext,
  s.getKind() as kind, s.getProvenance() as provenance order by instanceCount desc
