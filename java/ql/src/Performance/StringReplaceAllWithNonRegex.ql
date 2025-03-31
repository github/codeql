/**
 * @id java/string-replace-all-with-non-regex
 * @name Use of `String#replaceAll` with a first argument which is not a regular expression
 * @description Using `String#replaceAll` with a first argument which is not a regular expression
 *              is less efficient than using `String#replace`.
 * @kind problem
 * @precision very-high
 * @problem.severity recommendation
 * @tags performance
 *       quality
 *       external/cwe/cwe-1176
 */

import java

from StringReplaceAllCall replaceAllCall, StringLiteral firstArg
where
  firstArg = replaceAllCall.getArgument(0) and
  //only contains characters that could be a simple string
  firstArg.getValue().regexpMatch("^[a-zA-Z0-9]+$")
select replaceAllCall,
  "This call to 'replaceAll' should be a call to 'replace' as its $@ is not a regular expression.",
  firstArg, "first argument"
