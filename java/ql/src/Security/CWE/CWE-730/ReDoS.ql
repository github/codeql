/**
 * @name Inefficient regular expression
 * @description A regular expression that requires exponential time to match certain inputs
 *              can be a performance bottleneck, and may be vulnerable to denial-of-service
 *              attacks.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/redos
 * @tags security
 *       external/cwe/cwe-1333
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

private import semmle.code.java.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.ExponentialBackTracking::Make<TreeView> as ExponentialBackTracking

from TreeView::RegExpTerm t, string pump, ExponentialBackTracking::State s, string prefixMsg
where
  ExponentialBackTracking::hasReDoSResult(t, pump, s, prefixMsg) and
  // exclude verbose mode regexes for now
  not t.getRegex().getAMode() = "VERBOSE"
select t,
  "This part of the regular expression may cause exponential backtracking on strings " + prefixMsg +
    "containing many repetitions of '" + pump + "'."
