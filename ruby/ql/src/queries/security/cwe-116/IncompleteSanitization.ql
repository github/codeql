/**
 * @name Incomplete string escaping or encoding
 * @description A string transformer that does not replace or escape all occurrences of a
 *              meta-character may be ineffective.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id rb/incomplete-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 *       external/cwe/cwe-080
 *       external/cwe/cwe-116
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.frameworks.core.String
import codeql.ruby.Regexp as RE
import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/** Gets a character that is commonly used as a meta-character. */
string metachar() { result = "'\"\\&<>\n\r\t*|{}[]%$".charAt(_) }

/** Holds if `t` is simple, that is, a union of constants. */
predicate isSimple(RE::RegExpTerm t) {
  t instanceof RE::RegExpConstant
  or
  isSimple(t.(RE::RegExpGroup).getAChild()) // N.B. a group has only one child
  or
  isSimpleCharacterClass(t)
  or
  isSimpleAlt(t)
}

/** Holds if `t` is a non-inverted character class that contains no ranges. */
predicate isSimpleCharacterClass(RE::RegExpCharacterClass t) {
  not t.isInverted() and
  forall(RE::RegExpTerm ch | ch = t.getAChild() | isSimple(ch))
}

/** Holds if `t` is an alternation of simple terms. */
predicate isSimpleAlt(RE::RegExpAlt t) {
  forall(RE::RegExpTerm ch | ch = t.getAChild() | isSimple(ch))
}

/**
 * Holds if `sub` is of the form `x.gsub[!](pattern, replacement)`, where
 * `pattern` has a known constant value (either a string or a regexp), and
 * `replacement` prefixes the matched string with a backslash.
 */
predicate isBackslashEscape(StringSubstitutionCall sub) {
  sub.isGlobal() and
  (exists(sub.getPatternString()) or exists(sub.getPatternRegExp().getRegExpTerm())) and
  (
    // Replacement with `\` followed by a backref such as `\&`, `\1`, etc. The
    // replacement argument to the substitution call will look like '\\\\\0',
    // '\\\\\\0', or "\\\\\\0". Those examples all have the same string value
    // (i.e. after Ruby's unescaping) of `\\\0`. Then, to account for the
    // backslash escaping in both QL's string syntax and its regexp engine, each
    // of those three backslashes becomes `\\\\` in the following:
    sub.getReplacementString().regexpMatch("\\\\\\\\\\\\(&|\\d)")
    or
    // replacement of `c` with `\c`
    exists(string c | sub.replaces(c, "\\" + c))
  )
}

/**
 * Holds if data flowing into `node` has no un-escaped backslashes.
 */
predicate allBackslashesEscaped(DataFlow::Node node) {
  exists(StringSubstitutionCall sub | node = sub |
    // check whether `sub` itself escapes backslashes
    isBackslashEscape(sub) and
    (
      sub.getAReplacedString() = "\\"
      or
      // if it's a complex regexp, we conservatively assume that it probably escapes backslashes
      exists(RE::RegExpTerm root | root = sub.getPatternRegExp().getRegExpTerm() |
        not isSimple(root)
      )
    )
  )
  or
  // flow through string methods
  exists(ExprNodes::MethodCallCfgNode mc, string m, DataFlow::Node receiver |
    m =
      [
        "sub", "gsub", "slice", "[]", "strip", "lstrip", "rstrip", "chomp", "chop", "downcase",
        "upcase", "sub!", "gsub!", "slice!", "strip!", "lstrip!", "rstrip!", "chomp!", "chop!",
        "downcase!", "upcase!",
      ]
  |
    mc = node.asExpr() and
    m = mc.getExpr().getMethodName() and
    receiver.asExpr() = mc.getReceiver() and
    allBackslashesEscaped(receiver)
  )
  or
  // general data flow
  allBackslashesEscaped(node.getAPredecessor())
  or
  // general data flow from a (destructive) [g]sub!
  exists(DataFlow::PostUpdateNode post, StringSubstitutionCall sub |
    sub.isDestructive() and
    allBackslashesEscaped(sub) and
    post.getPreUpdateNode() = sub.getReceiver() and
    post.getASuccessor() = node
  )
}

/**
 * Holds if `sub` looks like a string substitution call that deliberately
 * removes the first occurrence of `str`.
 */
predicate removesFirstOccurence(StringSubstitutionCall sub, string str) {
  not sub.isGlobal() and sub.replaces(str, "")
}

/**
 * Gets a method call where the receiver is the result of a string substitution
 * call.
 */
DataFlow::CallNode getAMethodCall(StringSubstitutionCall call) {
  exists(DataFlow::Node receiver |
    receiver = result.getReceiver() and
    (
      // for a non-destructive string substitution, is there flow from it to the
      // receiver of another method call?
      not call.isDestructive() and call.(DataFlow::LocalSourceNode).flowsTo(receiver)
      or
      // for a destructive string substitution, is there flow from its
      // post-update receiver to the receiver of another method call?
      call.isDestructive() and
      exists(DataFlow::PostUpdateNode post | post.getPreUpdateNode() = call.getReceiver() |
        post.(DataFlow::LocalSourceNode).flowsTo(receiver)
      )
    )
  )
}

/**
 * Holds if `leftUnwrap` and `rightUnwrap` unwraps a string from a pair of
 * surrounding delimiters.
 */
predicate isDelimiterUnwrapper(StringSubstitutionCall leftUnwrap, StringSubstitutionCall rightUnwrap) {
  exists(string left, string right |
    left = "[" and right = "]"
    or
    left = "{" and right = "}"
    or
    left = "(" and right = ")"
    or
    left = "\"" and right = "\""
    or
    left = "'" and right = "'"
  |
    removesFirstOccurence(leftUnwrap, left) and
    removesFirstOccurence(rightUnwrap, right) and
    rightUnwrap = getAMethodCall(leftUnwrap)
  )
}

/**
 * Holds if `sub` is a standalone use of a string substitution to remove a single
 * newline, dollar or percent character.
 *
 * This is often done on inputs that are known to only contain a single instance
 * of the character, such as output from a shell command that is known to end
 * with a single newline, or strings like "$1.20" or "50%".
 */
predicate whitelistedRemoval(StringSubstitutionCall sub) {
  not sub.isGlobal() and
  exists(string s | s = "\n" or s = "%" or s = "$" |
    sub.replaces(s, "") and
    not exists(StringSubstitutionCall other |
      other = getAMethodCall(sub) or
      sub = getAMethodCall(other)
    )
  )
}

from StringSubstitutionCall sub, DataFlow::Node old, string msg
where
  old = sub.getPatternArgument() and
  (
    not sub.isGlobal() and
    msg = "This replaces only the first occurrence of " + old + "." and
    // only flag if this is likely to be a sanitizer or URL encoder or decoder
    exists(string m | m = sub.getAReplacedString() |
      // sanitizer
      m = metachar()
      or
      exists(string urlEscapePattern | urlEscapePattern = "(%[0-9A-Fa-f]{2})+" |
        // URL decoder
        m.regexpMatch(urlEscapePattern)
        or
        // URL encoder
        sub.getReplacementString().regexpMatch(urlEscapePattern)
      )
      or
      // path sanitizer
      (m = ".." or m = "/.." or m = "../" or m = "/../")
    ) and
    // don't flag replace operations in a loop
    not sub.asExpr().(ExprNodes::MethodCallCfgNode).getReceiver() = sub.asExpr().getASuccessor+() and
    // don't flag unwrapper
    not isDelimiterUnwrapper(sub, _) and
    not isDelimiterUnwrapper(_, sub) and
    // don't flag replacements of certain characters with whitespace
    not whitelistedRemoval(sub)
    or
    isBackslashEscape(sub) and
    not allBackslashesEscaped(sub) and
    msg = "This does not escape backslash characters in the input."
  )
select sub, msg
