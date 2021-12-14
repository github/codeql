/**
 * @name Character passed to StringBuilder constructor
 * @description A character value is passed to the constructor of 'StringBuilder'. This value will
 *              be converted to an integer and interpreted as the buffer's initial capacity, which is probably not intended.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/stringbuilder-initialized-with-character
 * @tags maintainability
 */

import semmle.code.csharp.frameworks.system.Text

from ObjectCreation c, Expr argument
where
  c.getObjectType() instanceof SystemTextStringBuilderClass and
  argument = c.getAnArgument().stripCasts() and
  argument.getType() instanceof CharType
select argument,
  "A character value passed to 'new StringBuilder()' is interpreted as the buffer capacity."
