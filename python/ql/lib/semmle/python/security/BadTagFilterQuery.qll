/**
 * Provides precicates for reasoning about bad tag filter vulnerabilities.
 */

import performance.ReDoSUtil

/**
 * A module for determining if a regexp matches a given string,
 * and reasoning about which capture groups are filled by a given string.
 */
private module RegexpMatching {
  /**
   * A class to test whether a regular expression matches a string.
   * Override this class and extend `test`/`testWithGroups` to configure which strings should be tested for acceptance by this regular expression.
   * The result can afterwards be read from the `matches` predicate.
   *
   * Strings in the `testWithGroups` predicate are also tested for which capture groups are filled by the given string.
   * The result is available in the `fillCaptureGroup` predicate.
   */
  abstract class MatchedRegExp extends RegExpTerm {
    MatchedRegExp() { this.isRootTerm() }

    /**
     * Holds if it should be tested whether this regular expression matches `str`.
     *
     * If `ignorePrefix` is true, then a regexp without a start anchor will be treated as if it had a start anchor.
     * E.g. a regular expression `/foo$/` will match any string that ends with "foo",
     * but if `ignorePrefix` is true, it will only match "foo".
     */
    predicate test(string str, boolean ignorePrefix) {
      none() // maybe overriden in subclasses
    }

    /**
     * Same as `test(..)`, but where the `fillsCaptureGroup` afterwards tells which capture groups were filled by the given string.
     */
    predicate testWithGroups(string str, boolean ignorePrefix) {
      none() // maybe overriden in subclasses
    }

    /**
     * Holds if this RegExp matches `str`, where `str` is either in the `test` or `testWithGroups` predicate.
     */
    final predicate matches(string str) {
      exists(State state | state = getAState(this, str.length() - 1, str, _) |
        epsilonSucc*(state) = Accept(_)
      )
    }

    /**
     * Holds if matching `str` may fill capture group number `g`.
     * Only holds if `str` is in the `testWithGroups` predicate.
     */
    final predicate fillsCaptureGroup(string str, int g) {
      exists(State s |
        s = getAStateThatReachesAccept(this, _, str, _) and
        g = group(s.getRepr())
      )
    }
  }

  /**
   * Gets a state the regular expression `reg` can be in after matching the `i`th char in `str`.
   * The regular expression is modeled as a non-determistic finite automaton,
   * the regular expression can therefore be in multiple states after matching a character.
   *
   * It's a forward search to all possible states, and there is thus no guarantee that the state is on a path to an accepting state.
   */
  private State getAState(MatchedRegExp reg, int i, string str, boolean ignorePrefix) {
    // start state, the -1 position before any chars have been matched
    i = -1 and
    (
      reg.test(str, ignorePrefix)
      or
      reg.testWithGroups(str, ignorePrefix)
    ) and
    result.getRepr().getRootTerm() = reg and
    isStartState(result)
    or
    // recursive case
    result = getAStateAfterMatching(reg, _, str, i, _, ignorePrefix)
  }

  /**
   * Gets the next state after the `prev` state from `reg`.
   * `prev` is the state after matching `fromIndex` chars in `str`,
   * and the result is the state after matching `toIndex` chars in `str`.
   *
   * This predicate is used as a step relation in the forwards search (`getAState`),
   * and also as a step relation in the later backwards search (`getAStateThatReachesAccept`).
   */
  private State getAStateAfterMatching(
    MatchedRegExp reg, State prev, string str, int toIndex, int fromIndex, boolean ignorePrefix
  ) {
    // the basic recursive case - outlined into a noopt helper to make performance work out.
    result = getAStateAfterMatchingAux(reg, prev, str, toIndex, fromIndex, ignorePrefix)
    or
    // we can skip past word boundaries if the next char is a non-word char.
    fromIndex = toIndex and
    prev.getRepr() instanceof RegExpWordBoundary and
    prev = getAState(reg, toIndex, str, ignorePrefix) and
    after(prev.getRepr()) = result and
    str.charAt(toIndex + 1).regexpMatch("\\W") // \W matches any non-word char.
  }

  pragma[noopt]
  private State getAStateAfterMatchingAux(
    MatchedRegExp reg, State prev, string str, int toIndex, int fromIndex, boolean ignorePrefix
  ) {
    prev = getAState(reg, fromIndex, str, ignorePrefix) and
    fromIndex = toIndex - 1 and
    exists(string char | char = str.charAt(toIndex) | specializedDeltaClosed(prev, char, result)) and
    not discardedPrefixStep(prev, result, ignorePrefix)
  }

  /** Holds if a step from `prev` to `next` should be discarded when the `ignorePrefix` flag is set. */
  private predicate discardedPrefixStep(State prev, State next, boolean ignorePrefix) {
    prev = mkMatch(any(RegExpRoot r)) and
    ignorePrefix = true and
    next = prev
  }

  // The `deltaClosed` relation specialized to the chars that exists in strings tested by a `MatchedRegExp`.
  private predicate specializedDeltaClosed(State prev, string char, State next) {
    deltaClosed(prev, specializedGetAnInputSymbolMatching(char), next)
  }

  // The `getAnInputSymbolMatching` relation specialized to the chars that exists in strings tested by a `MatchedRegExp`.
  pragma[noinline]
  private InputSymbol specializedGetAnInputSymbolMatching(string char) {
    exists(string s, MatchedRegExp r |
      r.test(s, _)
      or
      r.testWithGroups(s, _)
    |
      char = s.charAt(_)
    ) and
    result = getAnInputSymbolMatching(char)
  }

  /**
   * Gets the `i`th state on a path to the accepting state when `reg` matches `str`.
   * Starts with an accepting state as found by `getAState` and searches backwards
   * to the start state through the reachable states (as found by `getAState`).
   *
   * This predicate holds the invariant that the result state can be reached with `i` steps from a start state,
   * and an accepting state can be found after (`str.length() - 1 - i`) steps from the result.
   * The result state is therefore always on a valid path where `reg` accepts `str`.
   *
   * This predicate is only used to find which capture groups a regular expression has filled,
   * and thus the search is only performed for the strings in the `testWithGroups(..)` predicate.
   */
  private State getAStateThatReachesAccept(
    MatchedRegExp reg, int i, string str, boolean ignorePrefix
  ) {
    // base case, reaches an accepting state from the last state in `getAState(..)`
    reg.testWithGroups(str, ignorePrefix) and
    i = str.length() - 1 and
    result = getAState(reg, i, str, ignorePrefix) and
    epsilonSucc*(result) = Accept(_)
    or
    // recursive case. `next` is the next state to be matched after matching `prev`.
    // this predicate is doing a backwards search, so `prev` is the result we are looking for.
    exists(State next, State prev, int fromIndex, int toIndex |
      next = getAStateThatReachesAccept(reg, toIndex, str, ignorePrefix) and
      next = getAStateAfterMatching(reg, prev, str, toIndex, fromIndex, ignorePrefix) and
      i = fromIndex and
      result = prev
    )
  }

  /** Gets the capture group number that `term` belongs to. */
  private int group(RegExpTerm term) {
    exists(RegExpGroup grp | grp.getNumber() = result | term.getParent*() = grp)
  }
}

/** A class to test whether a regular expression matches certain HTML tags. */
class HtmlMatchingRegExp extends RegexpMatching::MatchedRegExp {
  HtmlMatchingRegExp() {
    // the regexp must mention "<" and ">" explicitly.
    forall(string angleBracket | angleBracket = ["<", ">"] |
      any(RegExpConstant term | term.getValue().matches("%" + angleBracket + "%")).getRootTerm() =
        this
    )
  }

  override predicate testWithGroups(string str, boolean ignorePrefix) {
    ignorePrefix = true and
    str = ["<!-- foo -->", "<!-- foo --!>", "<!- foo ->", "<foo>", "<script>"]
  }

  override predicate test(string str, boolean ignorePrefix) {
    ignorePrefix = true and
    str =
      [
        "<!-- foo -->", "<!- foo ->", "<!-- foo --!>", "<!-- foo\n -->", "<script>foo</script>",
        "<script \n>foo</script>", "<script >foo\n</script>", "<foo ></foo>", "<foo>",
        "<foo src=\"foo\"></foo>", "<script>", "<script src=\"foo\"></script>",
        "<script src='foo'></script>", "<SCRIPT>foo</SCRIPT>", "<script\tsrc=\"foo\"/>",
        "<script\tsrc='foo'></script>", "<sCrIpT>foo</ScRiPt>", "<script src=\"foo\">foo</script >",
        "<script src=\"foo\">foo</script foo=\"bar\">", "<script src=\"foo\">foo</script\t\n bar>"
      ]
  }
}

/** DEPRECATED: Alias for HtmlMatchingRegExp */
deprecated class HTMLMatchingRegExp = HtmlMatchingRegExp;

/**
 * Holds if `regexp` matches some HTML tags, but misses some HTML tags that it should match.
 *
 * When adding a new case to this predicate, make sure the test string used in `matches(..)` calls are present in `HTMLMatchingRegExp::test` / `HTMLMatchingRegExp::testWithGroups`.
 */
predicate isBadRegexpFilter(HtmlMatchingRegExp regexp, string msg) {
  // CVE-2021-33829 - matching both "<!-- foo -->" and "<!-- foo --!>", but in different capture groups
  regexp.matches("<!-- foo -->") and
  regexp.matches("<!-- foo --!>") and
  exists(int a, int b | a != b |
    regexp.fillsCaptureGroup("<!-- foo -->", a) and
    // <!-- foo --> might be ambigously parsed (matching both capture groups), and that is ok here.
    regexp.fillsCaptureGroup("<!-- foo --!>", b) and
    not regexp.fillsCaptureGroup("<!-- foo --!>", a) and
    msg =
      "Comments ending with --> are matched differently from comments ending with --!>. The first is matched with capture group "
        + a + " and comments ending with --!> are matched with capture group " +
        strictconcat(int i | regexp.fillsCaptureGroup("<!-- foo --!>", i) | i.toString(), ", ") +
        "."
  )
  or
  // CVE-2020-17480 - matching "<!-- foo -->" and other tags, but not "<!-- foo --!>".
  exists(int group, int other |
    group != other and
    regexp.fillsCaptureGroup("<!-- foo -->", group) and
    regexp.fillsCaptureGroup("<foo>", other) and
    not regexp.matches("<!-- foo --!>") and
    not regexp.fillsCaptureGroup("<!-- foo -->", any(int i | i != group)) and
    not regexp.fillsCaptureGroup("<!- foo ->", group) and
    not regexp.fillsCaptureGroup("<foo>", group) and
    not regexp.fillsCaptureGroup("<script>", group) and
    msg =
      "This regular expression only parses --> (capture group " + group +
        ") and not --!> as a HTML comment end tag."
  )
  or
  regexp.matches("<!-- foo -->") and
  not regexp.matches("<!-- foo\n -->") and
  not regexp.matches("<!- foo ->") and
  not regexp.matches("<foo>") and
  not regexp.matches("<script>") and
  msg = "This regular expression does not match comments containing newlines."
  or
  regexp.matches("<script>foo</script>") and
  regexp.matches("<script src=\"foo\"></script>") and
  not regexp.matches("<foo ></foo>") and
  (
    not regexp.matches("<script \n>foo</script>") and
    msg = "This regular expression matches <script></script>, but not <script \\n></script>"
    or
    not regexp.matches("<script >foo\n</script>") and
    msg = "This regular expression matches <script>...</script>, but not <script >...\\n</script>"
  )
  or
  regexp.matches("<script>foo</script>") and
  regexp.matches("<script src=\"foo\"></script>") and
  not regexp.matches("<script src='foo'></script>") and
  not regexp.matches("<foo>") and
  msg = "This regular expression does not match script tags where the attribute uses single-quotes."
  or
  regexp.matches("<script>foo</script>") and
  regexp.matches("<script src='foo'></script>") and
  not regexp.matches("<script src=\"foo\"></script>") and
  not regexp.matches("<foo>") and
  msg = "This regular expression does not match script tags where the attribute uses double-quotes."
  or
  regexp.matches("<script>foo</script>") and
  regexp.matches("<script src='foo'></script>") and
  not regexp.matches("<script\tsrc='foo'></script>") and
  not regexp.matches("<foo>") and
  not regexp.matches("<foo src=\"foo\"></foo>") and
  msg = "This regular expression does not match script tags where tabs are used between attributes."
  or
  regexp.matches("<script>foo</script>") and
  not RegExpFlags::isIgnoreCase(regexp) and
  not regexp.matches("<foo>") and
  not regexp.matches("<foo ></foo>") and
  (
    not regexp.matches("<SCRIPT>foo</SCRIPT>") and
    msg = "This regular expression does not match upper case <SCRIPT> tags."
    or
    not regexp.matches("<sCrIpT>foo</ScRiPt>") and
    regexp.matches("<SCRIPT>foo</SCRIPT>") and
    msg = "This regular expression does not match mixed case <sCrIpT> tags."
  )
  or
  regexp.matches("<script src=\"foo\"></script>") and
  not regexp.matches("<foo>") and
  not regexp.matches("<foo ></foo>") and
  (
    not regexp.matches("<script src=\"foo\">foo</script >") and
    msg = "This regular expression does not match script end tags like </script >."
    or
    not regexp.matches("<script src=\"foo\">foo</script foo=\"bar\">") and
    msg = "This regular expression does not match script end tags like </script foo=\"bar\">."
    or
    not regexp.matches("<script src=\"foo\">foo</script\t\n bar>") and
    msg = "This regular expression does not match script end tags like </script\\t\\n bar>."
  )
}
