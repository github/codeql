/**
 * Predicates used in summary queries.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.rust.AstConsistency as AstConsistency
private import codeql.rust.controlflow.internal.CfgConsistency as CfgConsistency
private import codeql.rust.dataflow.internal.DataFlowConsistency as DataFlowConsistency
private import codeql.rust.security.SqlInjectionExtensions
private import codeql.rust.security.CleartextLoggingExtensions

/**
 * Gets a count of the total number of lines of code in the database.
 */
int getLinesOfCode() { result = sum(File f | | f.getNumberOfLinesOfCode()) }

/**
 * Gets a count of the total number of lines of code from the source code directory in the database.
 */
int getLinesOfUserCode() {
  result = sum(File f | exists(f.getRelativePath()) | f.getNumberOfLinesOfCode())
}

/**
 * Gets a count of the total number of abstract syntax tree inconsistencies in the database.
 */
int getTotalAstInconsistencies() {
  result = sum(string type | | AstConsistency::getAstInconsistencyCounts(type))
}

/**
 * Gets a count of the total number of control flow graph inconsistencies in the database.
 */
int getTotalCfgInconsistencies() {
  result = sum(string type | | CfgConsistency::getCfgInconsistencyCounts(type))
}

/**
 * Gets a count of the total number of data flow inconsistencies in the database.
 */
int getTotalDataFlowInconsistencies() {
  result = sum(string type | | DataFlowConsistency::getInconsistencyCounts(type))
}

/**
 * Gets the total number of taint edges in the database.
 */
int getTaintEdgesCount() {
  result =
    count(DataFlow::Node a, DataFlow::Node b |
      RustTaintTracking::defaultAdditionalTaintStep(a, b, _)
    )
}

/**
 * Gets a kind of query for which `n` is a sink (if any).
 */
string getAQuerySinkKind(DataFlow::Node n) {
  n instanceof SqlInjection::Sink and result = "SqlInjection"
  or
  n instanceof CleartextLogging::Sink and result = "CleartextLogging"
}

/**
 * Gets a count of the total number of query sinks in the database.
 */
int getQuerySinksCount() { result = count(DataFlow::Node n | exists(getAQuerySinkKind(n))) }
