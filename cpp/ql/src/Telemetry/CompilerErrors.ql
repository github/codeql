/**
 * @name Compiler errors
 * @description A count of all compiler errors, grouped by error text.
 * @kind metric
 * @tags summary telemetry
 * @id cpp/telemetry/compiler-errors
 */

import Metrics

from CppMetrics::ErrorCount m
select m.toString(), m.getValue()
