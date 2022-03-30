/**
 * @name Metric filter: increase the value of a metric by 10
 * @description This filter demonstrates how to change the value
 *              computed by the metric that it is filtering. In this
 *              example the value is increased by 10.
 * @tags filter
 */

import cpp
import external.MetricFilter

from MetricResult res
select res, res.getValue() + 10
