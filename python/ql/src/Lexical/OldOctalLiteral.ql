/**
 * @name Confusing octal literal
 * @description Octal literal with a leading 0 is easily misread as a decimal value
 * @kind problem
 * @tags readability
 * @problem.severity recommendation
 * @sub-severity low
 * @precision high
 * @id py/old-style-octal-literal
 */

import python

predicate is_old_octal(IntegerLiteral i) {
  exists(string text | text = i.getText() |
    text.charAt(0) = "0" and
    not text = "00" and
    exists(text.charAt(1).toInt()) and
    /* Do not flag file permission masks */
    exists(int len | len = text.length() |
      len != 4 and
      len != 5 and
      len != 7
    )
  )
}

from IntegerLiteral i
where is_old_octal(i)
select i, "Confusing octal literal, use 0o" + i.getText().suffix(1) + " instead."
