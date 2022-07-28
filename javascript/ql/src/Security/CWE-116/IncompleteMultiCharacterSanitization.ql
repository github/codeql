/**
 * @name Incomplete multi-character sanitization
 * @description A sanitizer that removes a sequence of characters may reintroduce the dangerous sequence.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id js/incomplete-multi-character-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 *       external/cwe/cwe-080
 *       external/cwe/cwe-116
 */

import javascript
private import semmle.javascript.security.IncompleteMultiCharacterSanitization

from
  StringReplaceCall replace, EmptyReplaceRegExpTerm regexp, EmptyReplaceRegExpTerm dangerous,
  string prefix, string kind
where
  regexp = replace.getRegExp().getRoot() and
  dangerous.getRootTerm() = regexp and
  // skip leading optional elements
  not dangerous.isNullable() and
  // only warn about the longest match (presumably the most descriptive)
  prefix = max(string m | matchesDangerousPrefix(dangerous, m, kind) | m order by m.length(), m) and
  // only warn once per kind
  not exists(EmptyReplaceRegExpTerm other |
    other = dangerous.getAChild+() or other = dangerous.getPredecessor+()
  |
    matchesDangerousPrefix(other, _, kind) and
    not other.isNullable()
  ) and
  // don't flag replace operations in a loop
  not replace.getAMethodCall*().flowsTo(replace.getReceiver()) and
  // avoid anchored terms
  not exists(RegExpAnchor a | regexp = a.getRootTerm())
select replace, "This string may still contain $@, which may cause a " + kind + " vulnerability.",
  dangerous, prefix
