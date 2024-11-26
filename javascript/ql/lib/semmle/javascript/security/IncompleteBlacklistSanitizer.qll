/**
 * Provides classes and predicates for working with incomplete blacklist sanitizers.
 */

import javascript

/**
 * An incomplete black-list sanitizer.
 */
abstract class IncompleteBlacklistSanitizer extends DataFlow::Node {
  /**
   * Gets a relevant character that is not sanitized by this sanitizer.
   */
  abstract string getAnUnsanitizedCharacter();

  /**
   * Gets the kind of sanitization this sanitizer performs.
   */
  abstract string getKind();
}

/**
 * Describes the characters represented by `rep`.
 */
string describeCharacters(string rep) {
  rep = "\"" and result = "double quotes"
  or
  rep = "'" and result = "single quotes"
  or
  rep = "&" and result = "ampersands"
  or
  rep = "<" and result = "less-thans"
  or
  rep = ">" and result = "greater-thans"
}

/**
 * A local sequence of calls to `String.prototype.replace`,
 * represented by the last call.
 */
class StringReplaceCallSequence extends DataFlow::CallNode instanceof StringReplaceCall {
  StringReplaceCallSequence() {
    not exists(getAStringReplaceMethodCall(this)) // terminal
  }

  /**
   * Gets a member of this sequence.
   */
  StringReplaceCall getAMember() { this = getAStringReplaceMethodCall*(result) }

  /** Gets a string that is the replacement of this call. */
  string getAReplacementString() {
    this.getAMember().replaces(_, result)
    or
    // StringReplaceCall::replaces/2 can't always find the `old` string, so this is added as a fallback.
    this.getAMember().getRawReplacement().getStringValue() = result
  }

  /** Gets a string that is being replaced by this call. */
  string getAReplacedString() { this.getAMember().getAReplacedString() = result }
}

/**
 * A specialized version of `DataFlow::Node::getAMethodCall` that is
 * restricted to `StringReplaceCall`-nodes.
 */
private StringReplaceCall getAStringReplaceMethodCall(StringReplaceCall n) {
  n.getAMethodCall() = result
}

/**
 * Provides predicates and classes for reasoning about HTML sanitization.
 */
module HtmlSanitization {
  private predicate fixedGlobalReplacement(StringReplaceCallSequence chain) {
    forall(StringReplaceCall member | member = chain.getAMember() |
      member.maybeGlobal() and member.getArgument(0) instanceof DataFlow::RegExpCreationNode
    )
  }

  /**
   * Gets an HTML-relevant character that is replaced by `chain`.
   */
  private string getALikelyReplacedCharacter(StringReplaceCallSequence chain) {
    result = "\"" and
    (
      chain.getAReplacedString() = result or
      chain.getAReplacementString() = "&quot;" or
      chain.getAReplacementString() = "&#34;"
    )
    or
    result = "'" and
    (
      chain.getAReplacedString() = result or
      chain.getAReplacementString() = "&#39;"
    )
    or
    result = "&" and
    (
      chain.getAReplacedString() = result or
      chain.getAReplacementString() = "&amp;" or
      chain.getAReplacementString() = "&#40;"
    )
    or
    result = "<" and
    (
      chain.getAReplacedString() = result or
      chain.getAReplacementString() = "&lt;" or
      chain.getAReplacementString() = "&#60;"
    )
    or
    result = ">" and
    (
      chain.getAReplacedString() = result or
      chain.getAReplacementString() = "&gt;" or
      chain.getAReplacementString() = "&#62;"
    )
  }

  /**
   * An incomplete sanitizer for HTML-relevant characters.
   */
  class IncompleteSanitizer extends IncompleteBlacklistSanitizer instanceof StringReplaceCallSequence
  {
    string unsanitized;

    IncompleteSanitizer() {
      fixedGlobalReplacement(this) and
      not getALikelyReplacedCharacter(this) = unsanitized and
      (
        // replaces `<` and `>`
        getALikelyReplacedCharacter(this) = "<" and
        getALikelyReplacedCharacter(this) = ">" and
        unsanitized = ["\"", "'", "&"]
        or
        // replaces '&' and either `<` or `>`
        getALikelyReplacedCharacter(this) = "&" and
        (
          getALikelyReplacedCharacter(this) = ">" and
          unsanitized = ">"
          or
          getALikelyReplacedCharacter(this) = "<" and
          unsanitized = "<"
        )
      ) and
      // does not replace special characters that the browser doesn't care for
      not super.getAReplacedString() = ["!", "#", "*", "?", "@", "|", "~"] and
      /// only replaces explicit characters: exclude character ranges and negated character classes
      not exists(RegExpTerm t | t = super.getAMember().getRegExp().getRoot().getAChild*() |
        t.(RegExpCharacterClass).isInverted() or
        t instanceof RegExpCharacterRange
      ) and
      // the replacements are either empty or HTML entities
      super.getAReplacementString().regexpMatch("(?i)(|(&[#a-z0-9]+;))")
    }

    override string getKind() { result = "HTML" }

    override string getAnUnsanitizedCharacter() { result = unsanitized }
  }
}
