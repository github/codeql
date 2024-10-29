/**
 * Predicates used in summary queries.
 */

import rust
import codeql.rust.AstConsistency as AstConsistency
private import codeql.rust.controlflow.internal.CfgConsistency as CfgConsistency

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
