/**
 * @name Use of deprecated annotation
 * @description The library annotation is deprecated
 * @kind problem
 * @problem.severity warning
 * @id ql/deprecated-annotation
 * @tags maintainability
 * @precision very-high
 */

import ql

from AstNode n, Annotation library
where
  library = n.getAnAnnotation() and
  library.getName() = "library" and
  not n.hasAnnotation("deprecated")
select n, "Don't use the library annotation."
