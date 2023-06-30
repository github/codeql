/**
 * @name Number of alerts per sink model
 * @description Counts the number of alerts using `ai-generated` sink models.
 * @kind table
 * @id java/ml/metrics-count-alerts-per-sink-model
 * @tags internal automodel metrics
 */

private import java
private import AutomodelAlertSinkUtil

from int alertCount, string sinkModel
where sinkModelTally(alertCount, sinkModel)
select alertCount, sinkModel
