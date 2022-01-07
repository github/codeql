/**
 * @name Class QLDoc style.
 * @description The QLDoc for a class should start with "A", "An", or "The".
 * @kind problem
 * @problem.severity warning
 * @id ql/class-doc-style
 * @tags maintainability
 * @precision very-high
 */

import ql

bindingset[s]
predicate badStyle(string s) {
  not s.replaceAll("/**", "")
      .replaceAll("*", "")
      .splitAt("\n")
      .trim()
      .matches(["A %", "An %", "The %", "INTERNAL%", "DEPRECATED%"])
}

from Class c
where
  badStyle(c.getQLDoc().getContents()) and
  not c.isPrivate()
select c.getQLDoc(), "The QLDoc for a class should start with 'A', 'An', or 'The'."
