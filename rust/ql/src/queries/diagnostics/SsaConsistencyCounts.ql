/**
 * @name Static single assignment inconsistency counts
 * @description Counts the number of static single assignment inconsistencies of each type.  This query is intended for internal use.
 * @kind diagnostic
 * @id rust/diagnostics/ssa-consistency-counts
 */

private import codeql.rust.dataflow.internal.SsaImpl::Consistency as SsaConsistency

// see also `rust/diagnostics/ssa-consistency`, which lists the
// individual inconsistency results.
from string type, int num
where num = SsaConsistency::getInconsistencyCounts(type)
select type, num
