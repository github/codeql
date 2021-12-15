/**
 * @name String 'enum' used as identifier
 * @description Using 'enum' as an identifier makes the code incompatible with Java 5 and later.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/enum-identifier
 * @tags portability
 *       readability
 *       naming
 */

import java

Element elementNamedEnum() {
  result.(CompilationUnit).getPackage().getName().regexpMatch("(.*\\.|)enum(\\..*|)") or
  result.getName() = "enum"
}

select elementNamedEnum(),
  "Code using 'enum' as an identifier will not compile with a recent version of Java."
