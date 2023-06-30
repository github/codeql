/**
 * @name Number of alerts per sink model and query
 * @description Counts the number of alerts per query using `ai-generated` sink models.
 * @kind table
 * @id java/ml/metrics-count-alerts-per-sink-model-and-query
 * @tags internal automodel metrics
 */

private import java
private import AutomodelAlertSinkUtil

from string queryId, int alertCount, string sinkModel
where sinkModelTallyPerQuery(queryId, alertCount, sinkModel)
select alertCount, sinkModel
