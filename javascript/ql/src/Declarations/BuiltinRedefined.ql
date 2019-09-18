/**
 * @name Builtin redefined
 * @description Standard library functions can be redefined, but this should be avoided
 *              since it makes code hard to read and maintain.
 * @kind problem
 * @problem.severity recommendation
 * @id js/builtin-redefinition
 * @tags maintainability
 * @precision medium
 * @deprecated This query is prone to false positives. Deprecated since 1.17.
 */

import javascript
import Definitions

/**
 * Holds if `id` is a redefinition of a standard library function that is considered
 * acceptable since it merely introduces a local alias to the standard function of
 * the same name.
 */
predicate acceptableRedefinition(Identifier id) {
  // function(x, y, undefined) { ... }(23, 42)
  id.getName() = "undefined" and
  exists(ImmediatelyInvokedFunctionExpr iife |
    id = iife.getParameter(iife.getInvocation().getNumArgument())
  )
  or
  // Date = global.Date
  exists(AssignExpr assgn |
    id = assgn.getTarget() and
    id.getName() = assgn.getRhs().getUnderlyingValue().(PropAccess).getPropertyName()
  )
  or
  // var Date = global.Date
  exists(VariableDeclarator decl |
    id = decl.getBindingPattern() and
    id.getName() = decl.getInit().getUnderlyingValue().(PropAccess).getPropertyName()
  )
}

from DefiningIdentifier id, string name
where
  not id.inExternsFile() and
  name = id.getName() and
  name
      .regexpMatch("Object|Function|Array|String|Boolean|Number|Math|Date|RegExp|Error|" +
          "NaN|Infinity|undefined|eval|parseInt|parseFloat|isNaN|isFinite|" +
          "decodeURI|decodeURIComponent|encodeURI|encodeURIComponent") and
  not acceptableRedefinition(id)
select id, "Redefinition of " + name + "."
