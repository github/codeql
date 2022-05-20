/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @id rb/regex/missing-regexp-anchor
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import HostnameRegexpShared
import codeql.ruby.DataFlow
import codeql.ruby.regexp.RegExpTreeView
import codeql.ruby.Regexp

/**
 * Holds if `term` is a final term, that is, no term will match anything after this one.
 */
predicate isFinalRegExpTerm(RegExpTerm term) {
  term.isRootTerm()
  or
  exists(RegExpSequence seq |
    isFinalRegExpTerm(seq) and
    term = seq.getLastChild()
  )
  or
  exists(RegExpTerm parent |
    isFinalRegExpTerm(parent) and
    term = parent.getAChild() and
    not parent instanceof RegExpSequence and
    not parent instanceof RegExpQuantifier
  )
}

/** Holds if `term` is one of the transitive left children of a regexp. */
predicate isLeftArmTerm(RegExpTerm term) {
  term.isRootTerm()
  or
  exists(RegExpTerm parent |
    term = parent.getChild(0) and
    isLeftArmTerm(parent)
  )
}

/** Holds if `term` is one of the transitive right children of a regexp. */
predicate isRightArmTerm(RegExpTerm term) {
  term.isRootTerm()
  or
  exists(RegExpTerm parent |
    term = parent.getLastChild() and
    isRightArmTerm(parent)
  )
}

/**
 * Holds if `term` is an anchor that is not the first or last node
 * in its tree.
 */
predicate isInteriorAnchor(RegExpAnchor term) {
  not isLeftArmTerm(term) and
  not isRightArmTerm(term)
}

/**
 * Holds if `term` contains an anchor that is not the first or last node
 * in its tree, such as `(foo|bar$|baz)`.
 */
predicate containsInteriorAnchor(RegExpTerm term) { isInteriorAnchor(term.getAChild*()) }

/**
 * Holds if `term` starts with a word boundary or lookbehind assertion,
 * indicating that it's not intended to be anchored on that side.
 */
predicate containsLeadingPseudoAnchor(RegExpSequence term) {
  exists(RegExpTerm child | child = term.getChild(0) |
    child instanceof RegExpWordBoundary or
    child instanceof RegExpNonWordBoundary or
    child instanceof RegExpLookbehind
  )
}

/**
 * Holds if `term` ends with a word boundary or lookahead assertion,
 * indicating that it's not intended to be anchored on that side.
 */
predicate containsTrailingPseudoAnchor(RegExpSequence term) {
  exists(RegExpTerm child | child = term.getLastChild() |
    child instanceof RegExpWordBoundary or
    child instanceof RegExpNonWordBoundary or
    child instanceof RegExpLookahead
  )
}

/**
 * Holds if `term` is an empty sequence, usually arising from
 * literals with a trailing alternative such as `foo|`.
 */
predicate isEmpty(RegExpSequence term) { term.getNumChild() = 0 }

/**
 * Holds if `term` contains a letter constant.
 *
 * We use this as a heuristic to filter out uninteresting results.
 */
predicate containsLetters(RegExpTerm term) {
  term.getAChild*().(RegExpConstant).getValue().regexpMatch(".*[a-zA-Z].*")
}

/**
 * Holds if `alt` has an explicitly anchored group, such as `^(foo|bar)|baz`
 * and doesn't have any unnecessary groups, such as in `^(foo)|(bar)`.
 */
predicate hasExplicitAnchorPrecedence(RegExpAlt alt) {
  isAnchoredGroup(alt.getAChild()) and
  not alt.getAChild() instanceof RegExpGroup
}

/**
 * Holds if `term` consists only of an anchor and a parenthesized term,
 * such as the left side of `^(foo|bar)|baz`.
 *
 * The precedence of the anchor is likely to be intentional in this case,
 * as the group wouldn't be needed otherwise.
 */
predicate isAnchoredGroup(RegExpSequence term) {
  term.getNumChild() = 2 and
  term.getAChild() instanceof RegExpAnchor and
  term.getAChild() instanceof RegExpGroup
}

/**
 * Holds if `src` is a pattern for a collection of alternatives where
 * only the first or last alternative is anchored, indicating a
 * precedence mistake explained by `msg`.
 *
 * The canonical example of such a mistake is: `^a|b|c`, which is
 * parsed as `(^a)|(b)|(c)`.
 */
predicate hasMisleadingAnchorPrecedence(RegExpPatternSource src, string msg) {
  exists(RegExpAlt root, RegExpSequence anchoredTerm, string direction |
    root = src.getRegExpTerm() and
    not containsInteriorAnchor(root) and
    not isEmpty(root.getAChild()) and
    not hasExplicitAnchorPrecedence(root) and
    containsLetters(anchoredTerm) and
    (
      anchoredTerm = root.getChild(0) and
      anchoredTerm.getChild(0) instanceof RegExpCaret and
      not containsLeadingPseudoAnchor(root.getChild([1 .. root.getNumChild() - 1])) and
      containsLetters(root.getChild([1 .. root.getNumChild() - 1])) and
      direction = "beginning"
      or
      anchoredTerm = root.getLastChild() and
      anchoredTerm.getLastChild() instanceof RegExpDollar and
      not containsTrailingPseudoAnchor(root.getChild([0 .. root.getNumChild() - 2])) and
      containsLetters(root.getChild([0 .. root.getNumChild() - 2])) and
      direction = "end"
    ) and
    // that is not used for string replacement
    not exists(DataFlow::CallNode mcn, DataFlow::Node arg, string name |
      name = mcn.getMethodName() and
      arg = mcn.getArgument(0)
    |
      (
        src.getAParse().(DataFlow::LocalSourceNode).flowsTo(arg) or
        src.getAParse() = arg
      ) and
      name = ["sub", "sub!", "gsub", "gsub!"]
    ) and
    msg =
      "Misleading operator precedence. The subexpression '" + anchoredTerm.getRawValue() +
        "' is anchored at the " + direction +
        ", but the other parts of this regular expression are not"
  )
}

/**
 * Holds if `src` contains a hostname pattern that uses the `^/$` line anchors
 * rather than `\A/\z` which match the start/end of the whole string.
 */
predicate isLineAnchoredHostnameRegExp(RegExpPatternSource src, string msg) {
  // avoid double reporting
  not (
    isSemiAnchoredHostnameRegExp(src, _) or
    hasMisleadingAnchorPrecedence(src, _)
  ) and
  exists(RegExpTerm term, RegExpSequence tld, int i | term = src.getRegExpTerm() |
    not isConstantInvalidInsideOrigin(term.getAChild*()) and
    tld = term.getAChild*() and
    hasTopLevelDomainEnding(tld, i) and
    isFinalRegExpTerm(tld.getChild(i)) and // nothing is matched after the TLD
    (
      tld.getChild(0).(RegExpCaret).getChar() = "^" or
      tld.getLastChild().(RegExpDollar).getChar() = "$"
    ) and
    msg =
      "This hostname pattern uses anchors such as '^' and '$', which match the start and end of a line, not the whole string. Use '\\A' and '\\z' instead."
  )
}

/**
 * Holds if `src` contains a hostname pattern that is missing a `$` anchor.
 */
predicate isSemiAnchoredHostnameRegExp(RegExpPatternSource src, string msg) {
  not hasMisleadingAnchorPrecedence(src, _) and // avoid double reporting
  exists(RegExpTerm term, RegExpSequence tld, int i | term = src.getRegExpTerm() |
    not isConstantInvalidInsideOrigin(term.getAChild*()) and
    tld = term.getAChild*() and
    hasTopLevelDomainEnding(tld, i) and
    isFinalRegExpTerm(tld.getChild(i)) and // nothing is matched after the TLD
    tld.getChild(0) instanceof RegExpCaret and
    msg =
      "This hostname pattern may match any domain name, as it is missing a '\\z' or '/' at the end."
  )
}

/**
 * Holds if `src` is an unanchored pattern for a URL, indicating a
 * mistake explained by `msg`.
 */
predicate isUnanchoredHostnameRegExp(RegExpPatternSource src, string msg) {
  exists(RegExpTerm term, RegExpSequence tld | term = src.getRegExpTerm() |
    alwaysMatchesHostname(term) and
    tld = term.getAChild*() and
    hasTopLevelDomainEnding(tld) and
    not isConstantInvalidInsideOrigin(term.getAChild*()) and
    not term.getAChild*() instanceof RegExpAnchor and
    // that is not used for string replacement
    not exists(DataFlow::CallNode mcn, DataFlow::Node arg, string name |
      name = mcn.getMethodName() and
      arg = mcn.getArgument(0)
    |
      (
        src.getAParse().(DataFlow::LocalSourceNode).flowsTo(arg) or
        src.getAParse() = arg
      ) and
      name = ["sub", "sub!", "gsub", "gsub!"]
    ) and
    msg =
      "When this is used as a regular expression on a URL, it may match anywhere, and arbitrary hosts may come before or after it."
  )
}

from DataFlow::Node nd, string msg
where
  isUnanchoredHostnameRegExp(nd, msg) or
  isSemiAnchoredHostnameRegExp(nd, msg) or
  isLineAnchoredHostnameRegExp(nd, msg) or
  hasMisleadingAnchorPrecedence(nd, msg)
select nd, msg
