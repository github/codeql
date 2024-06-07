/**
 * Provides shared predicates for reasoning about improper multi-character sanitization.
 */

import IncompleteMultiCharacterSanitizationSpecific

/**
 * A prefix that may be dangerous to sanitize explicitly.
 *
 * Note that this class exists solely as a (necessary) optimization for this query.
 */
private class DangerousPrefix extends string {
  DangerousPrefix() {
    this = ["/..", "../"] or
    this = "<!--" or
    this = "<" + ["iframe", "script", "cript", "scrip", "style"]
  }

  /**
   * Gets a character that is important to the dangerous prefix.
   * That is, a char that should be mentioned in a regular expression that explicitly sanitizes the dangerous prefix.
   */
  string getAnImportantChar() {
    if this = ["/..", "../"] then result = ["/", "."] else result = "<"
  }
}

/**
 * A substring of a prefix that may be dangerous to sanitize explicitly.
 */
private class DangerousPrefixSubstring extends string {
  DangerousPrefixSubstring() {
    exists(DangerousPrefix s | this = s.substring([0 .. s.length()], [0 .. s.length()]))
  }
}

/**
 * Gets a char from a dangerous prefix that is matched by `t`.
 */
pragma[noinline]
private DangerousPrefixSubstring getADangerousMatchedChar(EmptyReplaceRegExpTerm t) {
  t.isNullable() and result = ""
  or
  result = t.getAMatchedString()
  or
  // A substring matched by some character class. This is only used to match the "word" part of an HTML tag (e.g. "iframe" in "<iframe").
  exists(NfaUtils::CharacterClass cc |
    cc = NfaUtils::getCanonicalCharClass(t) and
    cc.matches(result) and
    result.regexpMatch("\\w") and
    // excluding character classes that match ">" (e.g. /<[^<]*>/), as these might consume nested HTML tags, and thus prevent the dangerous pattern this query is looking for.
    not cc.matches(">")
  )
  or
  t instanceof RegExpDot and
  result.length() = 1
  or
  (
    t instanceof RegExpOpt or
    t instanceof RegExpStar or
    t instanceof RegExpPlus or
    t instanceof RegExpGroup or
    t instanceof RegExpAlt
  ) and
  result = getADangerousMatchedChar(t.getAChild())
}

/**
 * Gets a dangerous prefix that is in the prefix language of `t`.
 */
private DangerousPrefix getADangerousMatchedPrefix(EmptyReplaceRegExpTerm t) {
  result = getADangerousMatchedPrefixSubstring(t) and
  not exists(EmptyReplaceRegExpTerm pred | pred = t.getPredecessor+() and not pred.isNullable()) and
  // the regex must explicitly mention a char important to the prefix.
  forex(string char | char = result.getAnImportantChar() |
    t.getRootTerm().getAChild*().(RegExpConstant).getValue().matches("%" + char + "%")
  )
}

/**
 * Gets a substring of a dangerous prefix that is in the language starting at `t` (ignoring lookarounds).
 *
 * Note that the language of `t` is slightly restricted as not all RegExpTerm types are supported.
 */
private DangerousPrefixSubstring getADangerousMatchedPrefixSubstring(EmptyReplaceRegExpTerm t) {
  result = getADangerousMatchedChar(t) + getADangerousMatchedPrefixSubstring(t.getSuccessor())
  or
  result = getADangerousMatchedChar(t)
  or
  // loop around for repetitions (only considering alphanumeric characters in the repetition)
  exists(RepetitionMatcher repetition | t = repetition |
    result = getADangerousMatchedPrefixSubstring(repetition) + repetition.getAChar()
  )
}

private class RepetitionMatcher extends EmptyReplaceRegExpTerm {
  string char;

  pragma[noinline]
  RepetitionMatcher() {
    (this instanceof RegExpPlus or this instanceof RegExpStar) and
    char = getADangerousMatchedChar(this.getAChild()) and
    char.regexpMatch("\\w")
  }

  pragma[noinline]
  string getAChar() { result = char }
}

/**
 * Holds if `t` may match the dangerous `prefix` and some suffix, indicating intent to prevent a vulnerability of kind `kind`.
 */
predicate matchesDangerousPrefix(EmptyReplaceRegExpTerm t, string prefix, string kind) {
  prefix = getADangerousMatchedPrefix(t) and
  (
    kind = "a path injection vulnerability" and
    prefix = ["/..", "../"] and
    // If the regex is matching explicit path components, it is unlikely that it's being used as a sanitizer.
    not t.getSuccessor*().getAMatchedString().regexpMatch("(?is).*[a-z0-9_-].*")
    or
    kind = "an HTML element injection vulnerability" and
    (
      // comments
      prefix = "<!--" and
      // If the regex is matching explicit textual content of an HTML comment, it is unlikely that it's being used as a sanitizer.
      not t.getSuccessor*().getAMatchedString().regexpMatch("(?is).*[a-z0-9_].*")
      or
      // specific tags
      // the `cript|scrip` case has been observed in the wild several times
      prefix = "<" + ["iframe", "script", "cript", "scrip", "style"]
    )
  )
  or
  kind = "an HTML attribute injection vulnerability" and
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
      start.getAMatchedString().regexpMatch("(?i)[^a-z]*" + prefix) and
      isCommonWordMatcher(start.getSuccessor())
    )
  )
}

/**
 * Holds if `t` is a common pattern for matching words
 */
private predicate isCommonWordMatcher(RegExpTerm t) {
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

/**
 * Holds if `replace` has a pattern argument containing a regular expression
 * `dangerous` which matches a dangerous string beginning with `prefix`, in an
 * attempt to avoid a vulnerability of kind `kind`.
 */
predicate isResult(
  StringSubstitutionCall replace, EmptyReplaceRegExpTerm dangerous, string prefix, string kind
) {
  exists(EmptyReplaceRegExpTerm regexp |
    replace = regexp.getCall() and
    dangerous.getRootTerm() = regexp and
    // skip leading optional elements
    not dangerous.isNullable() and
    // only warn about the longest match
    prefix = max(string m | matchesDangerousPrefix(dangerous, m, kind) | m order by m.length(), m) and
    // only warn once per kind
    not exists(EmptyReplaceRegExpTerm other |
      other = dangerous.getAChild+() or other = dangerous.getPredecessor+()
    |
      matchesDangerousPrefix(other, _, kind) and
      not other.isNullable()
    ) and
    // avoid anchored terms
    not exists(RegExpAnchor a | regexp = a.getRootTerm()) and
    // Don't flag replace operations that are called repeatedly in a loop, as they can actually work correctly.
    not replace.flowsTo(replace.getReceiver+())
  )
}

/**
 * Holds if `replace` has a pattern argument containing a regular expression
 * `dangerous` which matches a dangerous string beginning with `prefix`. `msg`
 * is the alert we report.
 */
query predicate problems(
  StringSubstitutionCall replace, string msg, EmptyReplaceRegExpTerm dangerous, string prefix
) {
  exists(string kind |
    isResult(replace, dangerous, prefix, kind) and
    msg = "This string may still contain $@, which may cause " + kind + "."
  )
}
