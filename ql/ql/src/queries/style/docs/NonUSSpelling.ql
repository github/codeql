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
import codeql_ql.style.docs.NonUSSpellingQuery

from QLDoc doc, string wrong, string right
where contains_non_us_spelling(doc.getContents().toLowerCase(), wrong, right)
select doc,
  "This QLDoc comment contains the non-US spelling '" + wrong + "', which should instead be '" +
    right + "'."
