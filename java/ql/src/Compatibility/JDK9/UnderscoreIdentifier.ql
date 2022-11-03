/**
 * @name Underscore used as identifier
 * @description Use of a single underscore character as an identifier
 *              results in a compiler error with Java source level 9 or later.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/underscore-identifier
 * @tags maintainability
 */

import java

class IdentifierElement extends Element {
  IdentifierElement() {
    this instanceof CompilationUnit or
    this.(RefType).isSourceDeclaration() or
    this.(Callable).isSourceDeclaration() or
    this instanceof Variable
  }
}

from IdentifierElement e, string msg
where
  e.fromSource() and
  not e.(Constructor).isDefaultConstructor() and
  (
    e.getName() = "_" and
    msg = "."
    or
    e.(CompilationUnit).getPackage().getName().splitAt(".") = "_" and
    msg = " in package name '" + e.(CompilationUnit).getPackage().getName() + "'."
  )
select e, "Use of underscore as a one-character identifier" + msg
