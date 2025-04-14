/**
 * @name Data flow inconsistency counts
 * @description Counts the number of data flow inconsistencies of each type.  This query is intended for internal use.
 * @kind diagnostic
 * @id rust/diagnostics/data-flow-consistency-counts
 */

import codeql.rust.dataflow.internal.DataFlowConsistency as Consistency

// see also `rust/diagnostics/data-flow-consistency`, which lists the
// individual inconsistency results.
from string type, int num
where num = Consistency::getInconsistencyCounts(type)
select type, num
