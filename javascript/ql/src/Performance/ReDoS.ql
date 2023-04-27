/**
 * @name Inefficient regular expression
 * @description A regular expression that requires exponential time to match certain inputs
 *              can be a performance bottleneck, and may be vulnerable to denial-of-service
 *              attacks.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/redos
 * @tags security
 *       external/cwe/cwe-1333
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import javascript
private import semmle.javascript.security.regexp.RegExpTreeView::RegExpTreeView as TreeView
import codeql.regex.nfa.ExponentialBackTracking::Make<TreeView>

from RegExpTerm t, string pump, State s, string prefixMsg
where hasReDoSResult(t, pump, s, prefixMsg)
select t,
  "This part of the regular expression may cause exponential backtracking on strings " + prefixMsg +
    "containing many repetitions of '" + pump + "'."
