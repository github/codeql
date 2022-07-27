/**
 * Provides predicates for reasoning about improper multi-character sanitization.
 */

private import ruby
private import codeql.ruby.regexp.RegExpTreeView as RETV
private import codeql.ruby.security.performance.ReDoSUtil as ReDoSUtil
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.core.String
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/**
 * A regexp term that matches substrings that should be replaced with the empty string.
 */
class EmptyReplaceRegExpTerm extends RETV::RegExpTerm {
  private StringSubstitutionCall call;

  EmptyReplaceRegExpTerm() {
    call.getReplacementString() = "" and
    this = call.getPatternRegExp().getRegExpTerm().getAChild*()
  }

  /**
   * Get the substitution call that uses this regexp term.
   */
  StringSubstitutionCall getCall() { result = call }
}

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
 * Gets a dangerous prefix that is in the prefix language of `t`.
 */
private DangerousPrefix getADangerousMatchedPrefix(EmptyReplaceRegExpTerm t) {
  result = getADangerousMatchedPrefixSubstring(t) and
  not exists(EmptyReplaceRegExpTerm pred | pred = t.getPredecessor+() and not pred.isNullable())
}

pragma[noinline]
private DangerousPrefixSubstring getADangerousMatchedChar(EmptyReplaceRegExpTerm t) {
  t.isNullable() and result = ""
  or
  result = t.getAMatchedString()
  or
  // A substring matched by some character class. This is only used to match the "word" part of a HTML tag (e.g. "iframe" in "<iframe").
  exists(ReDoSUtil::CharacterClass cc |
    cc = ReDoSUtil::getCanonicalCharClass(t) and
    cc.matches(result) and
    result.regexpMatch("\\w") and
    // excluding character classes that match ">" (e.g. /<[^<]*>/), as these might consume nested HTML tags, and thus prevent the dangerous pattern this query is looking for.
    not cc.matches(">")
  )
  or
  t instanceof RETV::RegExpDot and
  result.length() = 1
  or
  (
    t instanceof RETV::RegExpOpt or
    t instanceof RETV::RegExpStar or
    t instanceof RETV::RegExpPlus or
    t instanceof RETV::RegExpGroup or
    t instanceof RETV::RegExpAlt
  ) and
  result = getADangerousMatchedChar(t.getAChild())
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
    (this instanceof RETV::RegExpPlus or this instanceof RETV::RegExpStar) and
    char = getADangerousMatchedChar(this.getAChild()) and
    char.regexpMatch("\\w")
  }

  pragma[noinline]
  string getAChar() { result = char }
}

/**
 * Holds if `t` may match the dangerous `prefix` and some suffix, indicating intent to prevent a vulnerability of kind `kind`.
 */
private predicate matchesDangerousPrefix(EmptyReplaceRegExpTerm t, string prefix, string kind) {
  prefix = getADangerousMatchedPrefix(t) and
  (
    kind = "path injection" and
    prefix = ["/..", "../"] and
    // If the regex is matching explicit path components, it is unlikely that it's being used as a sanitizer.
    not t.getSuccessor*().getAMatchedString().regexpMatch("(?is).*[a-z0-9_-].*")
    or
    kind = "HTML element injection" and
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
      start.getAMatchedString().regexpMatch("(?i)[^a-z]*" + prefix) and
      isCommonWordMatcher(start.getSuccessor())
    )
  )
}

/**
 * Holds if `t` is a common pattern for matching words
 */
private predicate isCommonWordMatcher(RETV::RegExpTerm t) {
  exists(RETV::RegExpTerm quantified | quantified = t.(RETV::RegExpQuantifier).getChild(0) |
    // [a-z]+ and similar
    quantified
        .(RETV::RegExpCharacterClass)
        .getAChild()
        .(RETV::RegExpCharacterRange)
        .isRange(["a", "A"], ["z", "Z"])
    or
    // \w+ or [\w]+
    [quantified, quantified.(RETV::RegExpCharacterClass).getAChild()]
        .(RETV::RegExpCharacterClassEscape)
        .getValue() = "w"
  )
}

/**
 * Holds if `replace` has a pattern argument containing a regular expression
 * `dangerous` which matches a dangerous string beginning with `prefix`, in
 * attempt to avoid a vulnerability of kind `kind`.
 */
predicate hasResult(
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
    not exists(RETV::RegExpCaret c | regexp = c.getRootTerm()) and
    not exists(RETV::RegExpDollar d | regexp = d.getRootTerm()) and
    // Don't flag replace operations that are called repeatedly in a loop, as they can actually work correctly.
    not replace.flowsTo(replace.getReceiver+())
  )
}
