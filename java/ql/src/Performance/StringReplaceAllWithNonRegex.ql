/**
 * @id java/string-replace-all-with-non-regex
 * @name Use of `String#replaceAll` with a first argument which is not a regular expression
 * @description Using `String#replaceAll` is less performant than `String#replace` when the first
 *              argument is not a regular expression.
 * @kind problem
 * @precision very-high
 * @problem.severity recommendation
 * @tags performance
 */

import java

from StringReplaceAllCall replaceAllCall
where
  //only contains characters that could be a simple string
  replaceAllCall.getArgument(0).(StringLiteral).getValue().regexpMatch("^[a-zA-Z0-9]+$")
select replaceAllCall,
  "Call to 'replaceAll' uses an argument comprised of plain string characters only."
