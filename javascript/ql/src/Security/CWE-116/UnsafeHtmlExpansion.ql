/**
 * @name Unsafe expansion of self-closing HTML tag
 * @description Using regular expressions to expand self-closing HTML
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
 * A regular expression that captures the name and content of a
 * self-closing HTML tag such as `<div id='foo'/>`.
 */
class SelfClosingTagRecognizer extends DataFlow::RegExpCreationNode {
  SelfClosingTagRecognizer() {
    exists(RegExpSequence seq, RegExpGroup name, RegExpGroup content |
      // `/.../g`
      RegExp::isGlobal(this.getFlags()) and
      this.getRoot() = seq.getRootTerm() and
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
}

from SelfClosingTagRecognizer regexp, StringReplaceCall replace
where
  regexp.getAReference().flowsTo(replace.getArgument(0)) and
  replace.getRawReplacement().mayHaveStringValue("<$1></$2>")
select replace,
  "This self-closing HTML tag expansion invalidates prior sanitization as $@ may match part of an attribute value.",
  regexp, "this regular expression"
