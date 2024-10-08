/**
 * Predicates used in summary queries.
 */

import rust
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
 * Gets a count of the total number of control flow graph inconsistencies in the database.
 */
int getTotalCfgInconsistencies() { result = sum(CfgConsistency::getCfgInconsistencyCounts(_)) }
