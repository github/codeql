/**
 * @name Comment has repeated word
 * @description Comment has repeated word.
 * @kind problem
 * @problem.severity warning
 * @id ql/repeated-word
 * @precision very-high
 */

import ql

/** Gets a word used in `node` */
string getWord(Comment node) { result = node.getContents().regexpFind("\\b[A-Za-z]+\\b", _, _) }

Comment hasRepeatedWord(string word) {
  word = getWord(result) and
  result.getContents().regexpMatch(".*\\b" + word + "\\s+" + word + "\\b.*")
}

from Comment comment, string word
where comment = hasRepeatedWord(word)
select comment, "The comment repeats " + word + "."
