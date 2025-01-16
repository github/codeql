/**
 * @name Query Sinks
 * @description Lists query sinks that are found in the database. Query sinks are flow sinks that
 *              are used as possible locations for query results. Cryptographic operations are
 *              excluded (see `rust/summary/cryptographic-operations` instead).
 * @kind problem
 * @problem.severity info
 * @id rust/summary/query-sinks
 * @tags summary
 */

import rust
import codeql.rust.dataflow.DataFlow
import Stats

from DataFlow::Node n
select n, "Sink for " + strictconcat(getAQuerySinkKind(n), ", ") + "."
