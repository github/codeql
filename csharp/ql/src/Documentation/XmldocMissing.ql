/**
 * @name Missing documentation for public class or method
 * @description A public class, method or constructor that does not have a documentation comment affects
 *              maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/xmldoc/missing-xmldoc
 * @tags maintainability
 */

import Documentation

/** Generate a user-friendly string for the declaration */
string declarationDescription(Declaration d) {
  d instanceof Class and result = "class"
  or
  d instanceof Interface and result = "interface"
  or
  d instanceof Method and result = "method"
  or
  d instanceof Constructor and result = "constructor"
  or
  d instanceof Struct and result = "struct"
}

from Declaration decl
where
  isDocumentationNeeded(decl) and
  not declarationHasXmlComment(decl)
select decl, "Public " + declarationDescription(decl) + " should be documented."
