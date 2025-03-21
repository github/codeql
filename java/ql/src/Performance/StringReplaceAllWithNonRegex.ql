/**
 * @id java/string-replace-all-with-non-regex
 * @name J-STR-001: Use of `String#replaceAll` with a first argument of a non regular expression
 * @description Using `String#replaceAll` is less performant than `String#replace` when the first
 *              argument is not a regular expression.
 * @kind problem
 * @precision very-high
 * @problem.severity recommendation
 * @tags performance
 */

import java

from MethodCall replaceAllCall
where
  replaceAllCall.getMethod().hasQualifiedName("java.lang", "String", "replaceAll") and
  //only contains characters that could be a simple string
  replaceAllCall.getArgument(0).(StringLiteral).getValue().regexpMatch("^[a-zA-Z0-9]+$")
select replaceAllCall,
  "Call to 'replaceAll' uses an argument comprised of plain string characters only."
