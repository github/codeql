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
  result.getContents().regexpMatch(".*[\\s]" + word + "\\s+" + word + "[\\s.,].*")
}

from Comment comment, string word
where
  comment = hasRepeatedWord(word) and
  // lots of these, and I can't just change old dbschemes.
  not (word = "type" and comment.getLocation().getFile().getExtension() = "dbscheme")
select comment, "The comment repeats " + word + "."
