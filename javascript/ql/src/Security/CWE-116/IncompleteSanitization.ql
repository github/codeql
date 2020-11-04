/**
 * @name Incomplete string escaping or encoding
 * @description A string transformer that does not replace or escape all occurrences of a
 *              meta-character may be ineffective.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/incomplete-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-116
 *       external/cwe/cwe-020
 */

import javascript

/**
 * Gets a character that is commonly used as a meta-character.
 */
string metachar() { result = "'\"\\&<>\n\r\t*|{}[]%$".charAt(_) }

/** Gets a string matched by `e` in a `replace` call. */
string getAMatchedString(DataFlow::Node e) {
  result = e.(DataFlow::RegExpLiteralNode).getRoot().getAMatchedString()
  or
  result = e.getStringValue()
}

/** Holds if `t` is simple, that is, a union of constants. */
predicate isSimple(RegExpTerm t) {
  t instanceof RegExpConstant
  or
  isSimple(t.(RegExpGroup).getAChild())
  or
  isSimpleCharacterClass(t)
  or
  isSimpleAlt(t)
}

/** Holds if `t` is a non-inverted character class that contains no ranges. */
predicate isSimpleCharacterClass(RegExpCharacterClass t) {
  not t.isInverted() and
  forall(RegExpTerm ch | ch = t.getAChild() | isSimple(ch))
}

/** Holds if `t` is an alternation of simple terms. */
predicate isSimpleAlt(RegExpAlt t) { forall(RegExpTerm ch | ch = t.getAChild() | isSimple(ch)) }

/**
 * Holds if `mce` is of the form `x.replace(re, new)`, where `re` is a global
 * regular expression and `new` prefixes the matched string with a backslash.
 */
predicate isBackslashEscape(StringReplaceCall mce, DataFlow::RegExpLiteralNode re) {
  mce.isGlobal() and
  re = mce.getRegExp() and
  (
    // replacement with `\$&`, `\$1` or similar
    mce.getRawReplacement().getStringValue().regexpMatch("\\\\\\$(&|\\d)")
    or
    // replacement of `c` with `\c`
    exists(string c | mce.replaces(c, "\\" + c))
  )
}

/**
 * Holds if data flowing into `nd` has no un-escaped backslashes.
 */
predicate allBackslashesEscaped(DataFlow::Node nd) {
  // `JSON.stringify` escapes backslashes
  nd instanceof JsonStringifyCall
  or
  // check whether `nd` itself escapes backslashes
  exists(DataFlow::RegExpLiteralNode rel | isBackslashEscape(nd, rel) |
    // if it's a complex regexp, we conservatively assume that it probably escapes backslashes
    not isSimple(rel.getRoot()) or
    getAMatchedString(rel) = "\\"
  )
  or
  // flow through string methods
  exists(DataFlow::MethodCallNode mc, string m |
    m = "replace" or
    m = "replaceAll" or
    m = "slice" or
    m = "substr" or
    m = "substring" or
    m = "toLowerCase" or
    m = "toUpperCase" or
    m = "trim"
  |
    mc = nd and m = mc.getMethodName() and allBackslashesEscaped(mc.getReceiver())
  )
  or
  // general data flow
  allBackslashesEscaped(nd.getAPredecessor())
}

/**
 * Holds if `repl` looks like a call to "String.prototype.replace" that deliberately removes the first occurrence of `str`.
 */
predicate removesFirstOccurence(StringReplaceCall repl, string str) {
  not exists(repl.getRegExp()) and repl.replaces(str, "")
}

/**
 * Holds if `leftUnwrap` and `rightUnwrap` unwraps a string from a pair of surrounding delimiters.
 */
predicate isDelimiterUnwrapper(
  DataFlow::MethodCallNode leftUnwrap, DataFlow::MethodCallNode rightUnwrap
) {
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
    leftUnwrap.getAMethodCall() = rightUnwrap
  )
}

/*
 * Holds if `repl` is a standalone use of `String.prototype.replace` to remove a single newline,
 * dollar or percent character.
 *
 * This is often done on inputs that are known to only contain a single instance of the character,
 * such as output from a shell command that is known to end with a single newline, or strings
 * like "$1.20" or "50%".
 */

predicate whitelistedRemoval(StringReplaceCall repl) {
  not repl.isGlobal() and
  exists(string s | s = "\n" or s = "%" or s = "$" |
    repl.replaces(s, "") and
    not exists(StringReplaceCall other |
      repl.getAMethodCall() = other or
      other.getAMethodCall() = repl
    )
  )
}

from StringReplaceCall repl, DataFlow::Node old, string msg
where
  (old = repl.getArgument(0) or old = repl.getRegExp()) and
  (
    not repl.isGlobal() and
    msg = "This replaces only the first occurrence of " + old + "." and
    // only flag if this is likely to be a sanitizer or URL encoder or decoder
    exists(string m | m = getAMatchedString(old) |
      // sanitizer
      m = metachar()
      or
      exists(string urlEscapePattern | urlEscapePattern = "(%[0-9A-Fa-f]{2})+" |
        // URL decoder
        m.regexpMatch(urlEscapePattern)
        or
        // URL encoder
        repl.getArgument(1).getStringValue().regexpMatch(urlEscapePattern)
      )
      or
      // path sanitizer
      (m = ".." or m = "/.." or m = "../" or m = "/../")
    ) and
    // don't flag replace operations in a loop
    not repl.getReceiver() = repl.getASuccessor+() and
    // dont' flag unwrapper
    not isDelimiterUnwrapper(repl, _) and
    not isDelimiterUnwrapper(_, repl) and
    // don't flag replacements of certain characters with whitespace
    not whitelistedRemoval(repl)
    or
    exists(DataFlow::RegExpLiteralNode rel |
      isBackslashEscape(repl, rel) and
      not allBackslashesEscaped(repl) and
      msg = "This does not escape backslash characters in the input."
    )
  )
select repl.getCalleeNode(), msg
