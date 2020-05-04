/**
 * @name Unsafe expansion of shorthand HTML tag
 * @description Using regular expressions to expand shorthand HTML
 *              tags may lead to cross-site scripting vulnerabilities.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id js/unsafe-html-expansion
 * @tags correctness
 *       security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript

/**
 * A regular expression that captures the name and content of a shorthand HTML tag such as `<div id='foo'/>`.
 */
class ShorthandTagRecognizer extends RegExpLiteral {
  ShorthandTagRecognizer() {
    exists(RegExpSequence seq, RegExpGroup name, RegExpGroup content |
      // `/.../g`
      this.isGlobal() and
      this = seq.getLiteral() and
      // `/<.../`
      seq.getChild(0).getConstantValue() = "<" and
      // `/...\/>/`
      seq.getLastChild().getPredecessor().getConstantValue() = "/" and
      seq.getLastChild().getConstantValue() = ">" and
      // `/...((...)...).../`
      seq.getAChild() = content and
      content.getNumber() = 1 and
      name.getNumber() = 2 and
      name = content.getChild(0).(RegExpSequence).getChild(0) and
      // `/...(([a-z]+)...).../` or `/...(([a-z][...]*)...).../`
      exists(RegExpQuantifier quant | name.getAChild*() = quant |
        quant instanceof RegExpStar or
        quant instanceof RegExpPlus
      ) and
      // `/...((...)[^>]*).../`
      exists(RegExpCharacterClass lazy |
        name.getSuccessor().(RegExpStar).getChild(0) = lazy and
        lazy.isInverted() and
        lazy.getAChild().getConstantValue() = ">"
      )
    )
  }

  /**
   * Gets a data flow node that may refer to this regular expression.
   */
  DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
    t.start() and
    result = this.flow()
    or
    exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
  }
}

from ShorthandTagRecognizer regexp, StringReplaceCall replace
where
  regexp.ref(DataFlow::TypeTracker::end()).flowsTo(replace.getArgument(0)) and
  replace.getRawReplacement().mayHaveStringValue("<$1></$2>")
select replace,
  "This HTML tag expansion may disable earlier sanitizations as $@ may match unintended strings.",
  regexp, "this regular expression"
