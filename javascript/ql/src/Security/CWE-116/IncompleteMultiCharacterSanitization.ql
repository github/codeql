/**
 * @name Incomplete multi-character sanitization
 * @description A sanitizer that removes a sequence of characters may reintroduce the dangerous sequence.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/incomplete-multi-character-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-116
 *       external/cwe/cwe-020
 */

import javascript
import semmle.javascript.security.IncompleteBlacklistSanitizer

predicate isDangerous(RegExpTerm t) {
  // path traversals
  t.getAMatchedString() = ["..", "/..", "../"]
  or
  exists(RegExpTerm start |
    start = t.(RegExpSequence).getAChild() and
    start.getConstantValue() = "." and
    start.getSuccessor().getConstantValue() = "." and
    not [start.getPredecessor(), start.getSuccessor().getSuccessor()].getConstantValue() = "."
  )
  or
  // HTML comments
  t.getAMatchedString() = "<!--"
  or
  // HTML scripts
  t.getAMatchedString().regexpMatch("(?i)<script.*")
  or
  exists(RegExpSequence seq | seq = t |
    t.getChild(0).getConstantValue() = "<" and
    // the `cript|scrip` case has been observed in the wild, not sure what the goal of that pattern is...
    t
        .getChild(0)
        .getSuccessor+()
        .getAMatchedString()
        .regexpMatch("(?i)iframe|script|cript|scrip|style")
  )
  or
  // HTML attributes
  exists(string dangerousPrefix | dangerousPrefix = ["ng-", "on"] |
    t.getAMatchedString().regexpMatch("(i?)" + dangerousPrefix + "[a-z]+")
    or
    exists(RegExpTerm start, RegExpTerm event | start = t.getAChild() |
      start.getConstantValue().regexpMatch("(?i)[^a-z]*" + dangerousPrefix) and
      event = start.getSuccessor() and
      exists(RegExpTerm quantified | quantified = event.(RegExpQuantifier).getChild(0) |
        quantified
            .(RegExpCharacterClass)
            .getAChild()
            .(RegExpCharacterRange)
            .isRange(["a", "A"], ["z", "Z"]) or
        [quantified, quantified.(RegExpRange).getAChild()].(RegExpCharacterClassEscape).getValue() =
          "w"
      )
    )
  )
}

from StringReplaceCall replace, RegExpTerm regexp, RegExpTerm dangerous
where
  [replace.getRawReplacement(), replace.getCallback(1).getAReturn()].mayHaveStringValue("") and
  replace.isGlobal() and
  regexp = replace.getRegExp().getRoot() and
  dangerous.getRootTerm() = regexp and
  isDangerous(dangerous) and
  // avoid anchored terms
  not exists(RegExpAnchor a | a.getRootTerm() = regexp) and
  // avoid flagging wrappers
  not (
    dangerous instanceof RegExpAlt or
    dangerous instanceof RegExpGroup
  ) and
  // don't flag replace operations in a loop
  not replace.getReceiver().getALocalSource() = replace
select replace, "The replaced string may still contain a substring that starts matching at $@.",
  dangerous, dangerous.toString()
