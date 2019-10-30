/**
 * @name Double escaping or unescaping
 * @description When escaping special characters using a meta-character like backslash or
 *              ampersand, the meta-character has to be escaped first to avoid double-escaping,
 *              and conversely it has to be unescaped last to avoid double-unescaping.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/double-escaping
 * @tags correctness
 *       security
 *       external/cwe/cwe-116
 *       external/cwe/cwe-20
 */

import javascript

/**
 * Holds if `rl` is a simple constant, which is bound to the result of the predicate.
 *
 * For example, `/a/g` has string value `"a"` and `/abc/` has string value `"abc"`,
 * while `/ab?/` and `/a(?=b)/` do not have a string value.
 *
 * Flags are ignored, so `/a/i` is still considered to have string value `"a"`,
 * even though it also matches `"A"`.
 *
 * Note the somewhat subtle use of monotonic aggregate semantics, which makes the
 * `strictconcat` fail if one of the children of the root is not a constant (legacy
 * semantics would simply skip such children).
 */
language[monotonicAggregates]
string getStringValue(RegExpLiteral rl) {
  exists(RegExpTerm root | root = rl.getRoot() |
    result = root.(RegExpConstant).getValue()
    or
    result = strictconcat(RegExpTerm ch, int i |
        ch = root.(RegExpSequence).getChild(i)
      |
        ch.(RegExpConstant).getValue() order by i
      )
  )
}

/**
 * Gets a predecessor of `nd` that is not an SSA phi node.
 */
DataFlow::Node getASimplePredecessor(DataFlow::Node nd) {
  result = nd.getAPredecessor() and
  not nd.(DataFlow::SsaDefinitionNode).getSsaVariable().getDefinition() instanceof SsaPhiNode
}

/**
 * Holds if `metachar` is a meta-character that is used to escape special characters
 * into a form described by regular expression `regex`.
 */
predicate escapingScheme(string metachar, string regex) {
  metachar = "&" and regex = "&.*;"
  or
  metachar = "%" and regex = "%.*"
  or
  metachar = "\\" and regex = "\\\\.*"
}

/**
 * A method call that performs string replacement.
 */
abstract class Replacement extends DataFlow::Node {
  /**
   * Holds if this replacement replaces the string `input` with `output`.
   */
  abstract predicate replaces(string input, string output);

  /**
   * Gets the input of this replacement.
   */
  abstract DataFlow::Node getInput();

  /**
   * Gets the output of this replacement.
   */
  abstract DataFlow::SourceNode getOutput();

  /**
   * Holds if this replacement escapes `char` using `metachar`.
   *
   * For example, during HTML entity escaping `<` is escaped (to `&lt;`)
   * using `&`.
   */
  predicate escapes(string char, string metachar) {
    exists(string regexp, string repl |
      escapingScheme(metachar, regexp) and
      replaces(char, repl) and
      repl.regexpMatch(regexp)
    )
  }

  /**
   * Holds if this replacement unescapes `char` using `metachar`.
   *
   * For example, during HTML entity unescaping `<` is unescaped (from
   * `&lt;`) using `<`.
   */
  predicate unescapes(string metachar, string char) {
    exists(string regexp, string orig |
      escapingScheme(metachar, regexp) and
      replaces(orig, char) and
      orig.regexpMatch(regexp)
    )
  }

  /**
   * Gets the previous replacement in this chain of replacements.
   */
  Replacement getPreviousReplacement() {
    result.getOutput() = getASimplePredecessor*(getInput())
  }

  /**
   * Gets an earlier replacement in this chain of replacements that
   * performs an escaping.
   */
  Replacement getAnEarlierEscaping(string metachar) {
    exists(Replacement pred | pred = this.getPreviousReplacement() |
      if pred.escapes(_, metachar)
      then result = pred
      else result = pred.getAnEarlierEscaping(metachar)
    )
  }

  /**
   * Gets an earlier replacement in this chain of replacements that
   * performs a unescaping.
   */
  Replacement getALaterUnescaping(string metachar) {
    exists(Replacement succ | this = succ.getPreviousReplacement() |
      if succ.unescapes(metachar, _)
      then result = succ
      else result = succ.getALaterUnescaping(metachar)
    )
  }
}

/**
 * A call to `String.prototype.replace` that replaces all instances of a pattern.
 */
class GlobalStringReplacement extends Replacement, DataFlow::MethodCallNode {
  RegExpLiteral pattern;

  GlobalStringReplacement() {
    this.getMethodName() = "replace" and
    pattern.flow().(DataFlow::SourceNode).flowsTo(this.getArgument(0)) and
    this.getNumArgument() = 2 and
    pattern.isGlobal()
  }

  override predicate replaces(string input, string output) {
    input = getStringValue(pattern) and
    output = this.getArgument(1).getStringValue()
  }

  override DataFlow::Node getInput() {
    result = this.getReceiver()
  }

  override DataFlow::SourceNode getOutput() {
    result = this
  }
}

from Replacement primary, Replacement supplementary, string message, string metachar
where
  primary.escapes(metachar, _) and
  supplementary = primary.getAnEarlierEscaping(metachar) and
  message = "may double-escape '" + metachar + "' characters from $@"
  or
  primary.unescapes(_, metachar) and
  supplementary = primary.getALaterUnescaping(metachar) and
  message = "may produce '" + metachar + "' characters that are double-unescaped $@"
select primary, "This replacement " + message + ".", supplementary, "here"
