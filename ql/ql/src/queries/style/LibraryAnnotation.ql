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

from AstNode n
where n.hasAnnotation("library") and not n.hasAnnotation("deprecated")
select n, "Don't use the library annotation."
