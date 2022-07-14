/**
 * @name Comment has repeated word
 * @description Comment has repeated word.
 * @kind problem
 * @problem.severity warning
 * @id ql/repeated-word
 * @precision very-high
 */

import ql

string getComment(AstNode node) {
  result = node.(QLDoc).getContents()
  or
  result = node.(BlockComment).getContents()
  or
  result = node.(LineComment).getContents()
}

/** Gets a word used in `node` */
string getWord(AstNode node) { result = getComment(node).regexpFind("\\b[A-Za-z]+\\b", _, _) }

AstNode hasRepeatedWord(string word) {
  word = getWord(result) and
  getComment(result).regexpMatch(".*\\b" + word + "\\s+" + word + "\\b.*")
}

from AstNode comment, string word
where comment = hasRepeatedWord(word)
select comment, "The comment repeats " + word + "."
