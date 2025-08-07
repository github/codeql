/**
 * @name Type inference inconsistency counts
 * @description Counts the number of type inference inconsistencies of each type.  This query is intended for internal use.
 * @kind diagnostic
 * @id rust/diagnostics/type-inference-consistency-counts
 */

private import codeql.rust.internal.TypeInferenceConsistency as Consistency

// see also `rust/diagnostics/type-inference-consistency`, which lists the
// individual inconsistency results.
from string type, int num
where num = Consistency::getTypeInferenceInconsistencyCounts(type)
select type, num
