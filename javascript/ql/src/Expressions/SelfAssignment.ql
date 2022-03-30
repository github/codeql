/**
 * @name Self assignment
 * @description Assigning a variable to itself has no effect.
 * @kind problem
 * @problem.severity warning
 * @id js/redundant-assignment
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision high
 */

import Clones
import Expressions.DOMProperties

/**
 * Gets a description of expression `e`, which is assumed to be the left-hand
 * side of an assignment.
 *
 * For variable accesses, the description is the variable name. For property
 * accesses, the description is of the form `"property <name>"`, where
 * `<name>` is the name of the property, except if `<name>` is a numeric index,
 * in which case `element <name>` is used instead.
 */
string describe(Expr e) {
  exists(VarAccess va | va = e | result = "variable " + va.getName())
  or
  exists(string name | name = e.(PropAccess).getPropertyName() |
    if exists(name.toInt()) then result = "element " + name else result = "property " + name
  )
}

from SelfAssignment e, string dsc
where
  e.same(_) and
  dsc = describe(e) and
  // exclude properties for which there is an accessor somewhere
  not exists(string propName | propName = e.(PropAccess).getPropertyName() |
    propName = any(PropertyAccessor acc).getName() or
    propName = any(AccessorMethodDeclaration amd).getName()
  ) and
  // exclude DOM properties
  not isDomProperty(e.(PropAccess).getPropertyName()) and
  // exclude self-assignments that have been inserted to satisfy the TypeScript JS-checker
  not e.getAssignment().getParent().(ExprStmt).getDocumentation().getATag().getTitle() = "type" and
  // exclude self-assignments in speculatively parsed template files
  // named arguments may be incorrectly parsed as assignments
  not e.getTopLevel() instanceof Templating::TemplateTopLevel
select e.getParent(), "This expression assigns " + dsc + " to itself."
