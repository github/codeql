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

/**
 * A regexp term that matches substrings that should be replaced with the empty string.
 */
class EmptyReplaceRegExpTerm extends RegExpTerm {
  EmptyReplaceRegExpTerm() {
    exists(StringReplaceCall replace |
      [replace.getRawReplacement(), replace.getCallback(1).getAReturn()].mayHaveStringValue("") and
      this = replace.getRegExp().getRoot().getAChild*()
    )
  }
}

/**
 * A prefix that may be dangerous to sanitize explicitly.
 *
 * Note that this class exists solely as a (necessary) optimization for this query.
 */
class DangerousPrefix extends string {
  DangerousPrefix() {
    this = ["/..", "../"] or
    this = "<!--" or
    this = "<" + ["iframe", "script", "cript", "scrip", "style"]
  }
}

/**
 * A substring of a prefix that may be dangerous to sanitize explicitly.
 */
class DangerousPrefixSubstring extends string {
  DangerousPrefixSubstring() {
    exists(DangerousPrefix s | this = s.substring([0 .. s.length()], [0 .. s.length()]))
  }
}

/**
 * Gets a dangerous prefix that is in the prefix language of `t`.
 */
DangerousPrefix getADangerousMatchedPrefix(EmptyReplaceRegExpTerm t) {
  result = getADangerousMatchedPrefixSubstring(t) and
  not exists(EmptyReplaceRegExpTerm pred | pred = t.getPredecessor+() and not pred.isNullable())
}

/**
 * Gets a substring of a dangerous prefix that is in the language starting at `t` (ignoring lookarounds).
 *
 * Note that the language of `t` is slightly restricted as not all RegExpTerm types are supported.
 */
DangerousPrefixSubstring getADangerousMatchedPrefixSubstring(EmptyReplaceRegExpTerm t) {
  exists(string left |
    t.isNullable() and left = ""
    or
    t.getAMatchedString() = left
    or
    (
      t instanceof RegExpOpt or
      t instanceof RegExpStar or
      t instanceof RegExpPlus or
      t instanceof RegExpGroup or
      t instanceof RegExpAlt
    ) and
    left = getADangerousMatchedPrefixSubstring(t.getAChild())
  |
    result = left + getADangerousMatchedPrefixSubstring(t.getSuccessor()) or
    result = left
  )
}

/**
 * Holds if `t` may match the dangerous `prefix` and some suffix, indicating intent to prevent a vulnerablity of kind `kind`.
 */
predicate matchesDangerousPrefix(EmptyReplaceRegExpTerm t, string prefix, string kind) {
  prefix = getADangerousMatchedPrefix(t) and
  (
    kind = "path injection" and
    // upwards navigation
    prefix = ["/..", "../"] and
    not t.getSuccessor*().getAMatchedString().regexpMatch("(?is).*[a-z0-9_-].*") // explicit path name mentions make this an unlikely sanitizer
    or
    kind = "HTML element injection" and
    (
      // comments
      prefix = "<!--" and
      not t.getSuccessor*().getAMatchedString().regexpMatch("(?is).*[a-z0-9_].*") // explicit comment content mentions make this an unlikely sanitizer
      or
      // specific tags
      prefix = "<" + ["iframe", "script", "cript", "scrip", "style"] // the `cript|scrip` case has been observed in the wild several times
    )
  )
  or
  kind = "HTML attribute injection" and
  prefix =
    [
      // ordinary event handler prefix
      "on",
      // angular prefixes
      "ng-", "ng:", "data-ng-", "x-ng-"
    ] and
  (
    // explicit matching: `onclick` and `ng-bind`
    t.getAMatchedString().regexpMatch("(?i)" + prefix + "[a-z]+")
    or
    // regexp-based matching: `on[a-z]+`
    exists(EmptyReplaceRegExpTerm start | start = t.getAChild() |
      start.getConstantValue().regexpMatch("(?i)[^a-z]*" + prefix) and
      isCommonWordMatcher(start.getSuccessor())
    )
  )
}

/**
 * Holds if `t` is a common pattern for matching words
 */
predicate isCommonWordMatcher(RegExpTerm t) {
  exists(RegExpTerm quantified | quantified = t.(RegExpQuantifier).getChild(0) |
    // [a-z]+ and similar
    quantified
        .(RegExpCharacterClass)
        .getAChild()
        .(RegExpCharacterRange)
        .isRange(["a", "A"], ["z", "Z"])
    or
    // \w+ or [\w]+
    [quantified, quantified.(RegExpCharacterClass).getAChild()]
        .(RegExpCharacterClassEscape)
        .getValue() = "w"
  )
}

from
  StringReplaceCall replace, EmptyReplaceRegExpTerm regexp, EmptyReplaceRegExpTerm dangerous,
  string prefix, string kind
where
  regexp = replace.getRegExp().getRoot() and
  dangerous.getRootTerm() = regexp and
  // skip leading optional elements
  not dangerous.isNullable() and
  // only warn about the longest match (presumably the most descriptive)
  prefix = max(string m | matchesDangerousPrefix(dangerous, m, kind) | m order by m.length()) and
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
