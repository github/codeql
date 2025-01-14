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
import codeql.rust.security.SqlInjectionExtensions
import Stats

/**
 * Gets a kind of query for which `n` is a sink (if any).
 */
string getAQuerySinkKind(DataFlow::Node n) {
  (n instanceof SqlInjection::Sink and result = "SqlInjection")
}

from DataFlow::Node n
select n, "sink for " + strictconcat(getAQuerySinkKind(n), ", ")
