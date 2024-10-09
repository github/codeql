/**
 * @name Overly permissive regular expression range
 * @description Overly permissive regular expression ranges match a wider range of characters than intended.
 *              This may allow an attacker to bypass a filter or sanitizer.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id java/overly-large-range
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import semmle.code.java.regex.RegexDiffInformed
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.OverlyLargeRangeQuery::Make<TreeView>

class OverlyLargeRangeDiffInformed extends RegexDiffInformedConfig {
  override predicate observeDiffInformedIncrementalMode() { any() }

  override Location getASelectedSinkLocation(DataFlow::Node sink) { none() }
}

TreeView::RegExpCharacterClass potentialMisparsedCharClass() {
  // nested char classes are currently misparsed
  result.getAChild().(TreeView::RegExpNormalChar).getValue() = "["
}

from TreeView::RegExpCharacterRange range, string reason
where
  problem(range, reason) and
  not range.getParent() = potentialMisparsedCharClass()
select range, "Suspicious character range that " + reason + "."
