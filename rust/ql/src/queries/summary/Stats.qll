/**
 * Predicates used in summary queries.
 */

import rust

int getLinesOfCode() { result = sum(File f | | f.getNumberOfLinesOfCode()) }

int getLinesOfUserCode() {
  result = sum(File f | exists(f.getRelativePath()) | f.getNumberOfLinesOfCode())
}
