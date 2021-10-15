/**
 * @name Non US spelling
 * @description QLDocs shold use US spelling.
 * @kind problem
 * @problem.severity warning
 * @id ql/non-us-spelling
 * @tags maintainability
 * @precision very-high
 */

import ql

predicate non_us_word(string wrong, string right) {
  exists(string s |
    wrong = s.splitAt("/", 0) and
    right = s.splitAt("/", 1) and
    s = ["colour/color", "authorise/authorize", "analyse/analyze"]
  )
}

bindingset[s]
predicate contains_non_us_spelling(string s, string wrong, string right) {
  non_us_word(wrong, right) and
  (
    s.matches("%" + wrong + "%") and
    wrong != "analyse"
    or
    // analyses (as a noun) is fine
    s.regexpMatch(".*analyse[^s].*") and
    wrong = "analyse"
  )
}

from QLDoc doc, string wrong, string right
where contains_non_us_spelling(doc.getContents().toLowerCase(), wrong, right)
select doc,
  "This QLDoc comment contains the non-US spelling '" + wrong + "', which should instead be '" +
    right + "'."
