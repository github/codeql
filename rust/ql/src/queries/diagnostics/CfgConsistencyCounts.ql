/**
 * @name Control flow graph inconsistency counts
 * @description Counts the number of control flow graph inconsistencies of each type.  This query is intended for internal use.
 * @kind diagnostic
 * @id rust/diagnostics/cfg-consistency-counts
 */

import rust
import codeql.rust.controlflow.internal.CfgConsistency as Consistency

// see also `rust/diagnostics/cfg-consistency`, which lists the
// individual inconsistency results.
from string type, int num
where num = Consistency::getCfgInconsistencyCounts(type)
select type, num
