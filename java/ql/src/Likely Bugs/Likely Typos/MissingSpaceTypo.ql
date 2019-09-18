/**
 * @name Missing space in string literal
 * @description Joining strings at compile-time to construct a string literal
 *              so that two words are concatenated without a separating space
 *              usually indicates a text error.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id java/missing-space-in-concatenation
 * @tags readability
 */

import java

class SourceStringLiteral extends StringLiteral {
  SourceStringLiteral() { this.getCompilationUnit().fromSource() }
}

from SourceStringLiteral s, string word
where
  // Match ` word" + "word2` taking punctuation after `word` into account.
  // `word2` is only matched on the first character whereas `word` is matched
  // completely to distinguish grammatical punctuation after which a space is
  // needed, and intra-identifier punctuation in, for example, a fully
  // qualified java class name.
  s
      .getLiteral()
      .regexpCapture(".* (([-A-Za-z/'\\.:,]*[a-zA-Z]|[0-9]+)[\\.:,;!?']*)\"[^\"]*\\+[^\"]*\"[a-zA-Z].*",
        1) = word and
  not word.regexpMatch(".*[,\\.:].*[a-zA-Z].*[^a-zA-Z]")
select s, "This string appears to be missing a space after '" + word + "'."
