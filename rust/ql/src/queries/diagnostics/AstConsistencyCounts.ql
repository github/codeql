/**
 * @name Abstract syntax tree inconsistency counts
 * @description Counts the number of abstract syntax tree inconsistencies of each type.  This query is intended for internal use.
 * @kind diagnostic
 * @id rust/diagnostics/ast-consistency-counts
 */

import rust
import codeql.rust.AstConsistency as Consistency

// see also `rust/diagnostics/ast-consistency`, which lists the
// individual inconsistency results.
from string type, int num
where num = Consistency::getAstInconsistencyCounts(type)
select type, num
