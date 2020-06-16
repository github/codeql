/**
 * Provides classes for reasoning about character escapes in literals.
 */

import javascript

module CharacterEscapes {
  /**
   * Provides sets of characters (as strings) with specific string/regexp characteristics.
   */
  private module Sets {
    string sharedEscapeChars() { result = "fnrtvux0\\" }

    string regexpAssertionChars() { result = "bB" }

    string regexpCharClassChars() { result = "cdDpPsSwW" }

    string regexpBackreferenceChars() { result = "123456789k" }

    string regexpMetaChars() { result = "^$*+?.()|{}[]-" }
  }

  /**
   * Gets the `i`th character of `raw`, which is preceded by an uneven number of backslashes.
   */
  bindingset[raw]
  string getAnEscapedCharacter(string raw, int i) {
    result = raw.regexpFind("(?<=(^|[^\\\\])\\\\(\\\\{2}){0,10}).", _, i)
  }

  /**
   * Holds if `n` is delimited by `delim` and contains `rawStringNode` with the raw string value `raw`.
   */
  private predicate hasRawStringAndQuote(
    DataFlow::ValueNode n, string delim, ASTNode rawStringNode, string raw
  ) {
    rawStringNode = n.asExpr() and
    raw = rawStringNode.(StringLiteral).getRawValue() and
    delim = raw.charAt(0)
    or
    rawStringNode = n.asExpr().(TemplateLiteral).getAnElement() and
    raw = rawStringNode.(TemplateElement).getRawValue() and
    delim = "`"
    or
    rawStringNode = n.asExpr() and
    raw = rawStringNode.(RegExpLiteral).getRawValue() and
    delim = "/"
  }

  /**
   * Gets a character in `n` that is preceded by a single useless backslash.
   *
   * The character is the `i`th character of `rawStringNode`'s raw string value.
   */
  string getAnIdentityEscapedCharacter(DataFlow::Node n, ASTNode rawStringNode, int i) {
    exists(string delim, string raw, string additionalEscapeChars |
      hasRawStringAndQuote(n, delim, rawStringNode, raw) and
      if rawStringNode instanceof RegExpLiteral
      then
        additionalEscapeChars =
          Sets::regexpMetaChars() + Sets::regexpAssertionChars() + Sets::regexpCharClassChars() +
            Sets::regexpBackreferenceChars()
      else additionalEscapeChars = "b"
    |
      result = getAnEscapedCharacter(raw, i) and
      not result = (Sets::sharedEscapeChars() + delim + additionalEscapeChars).charAt(_)
    )
  }

  /**
   * Holds if `src` likely contains a regular expression mistake, to be reported by `js/useless-regexp-character-escape`.
   */
  predicate hasALikelyRegExpPatternMistake(RegExpPatternSource src) {
    exists(getALikelyRegExpPatternMistake(src, _, _, _))
  }

  /**
   * Gets a character in `n` that is preceded by a single useless backslash, resulting in a likely regular expression mistake explained by `mistake`.
   *
   * The character is the `i`th character of the raw string value of `rawStringNode`.
   */
  string getALikelyRegExpPatternMistake(
    RegExpPatternSource src, string mistake, ASTNode rawStringNode, int i
  ) {
    result = getAnIdentityEscapedCharacter(src, rawStringNode, i) and
    (
      result = Sets::regexpAssertionChars().charAt(_) and mistake = "is not an assertion"
      or
      result = Sets::regexpCharClassChars().charAt(_) and mistake = "is not a character class"
      or
      result = Sets::regexpBackreferenceChars().charAt(_) and mistake = "is not a backreference"
      or
      // conservative formulation: we do not know in general if the sequence is enclosed in a character class `[...]`
      result = Sets::regexpMetaChars().charAt(_) and
      mistake = "may still represent a meta-character"
    ) and
    // avoid the benign case where preceding escaped backslashes turns into backslashes when the regexp is constructed
    not exists(string raw |
      not rawStringNode instanceof RegExpLiteral and
      hasRawStringAndQuote(_, _, rawStringNode, raw) and
      result = raw.regexpFind("(?<=(^|[^\\\\])((\\\\{3})|(\\\\{7}))).", _, i)
    )
  }
}
