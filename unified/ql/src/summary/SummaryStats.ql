/**
 * @name Summary Statistics
 * @description A table of summary statistics about a database.
 * @kind metric
 * @id unified/summary/summary-statistics
 * @tags summary telemetry
 */

import unified
import codeql.unified.internal.AnalysisQuality

from string key, int value
where taintStats(key, value)
select key, value order by key
