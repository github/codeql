/**
 * @name Dead reference types
 * @description Finds non-public reference types (classes, interfaces) that are not accessed anywhere in the codebase.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/unused-reftype
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import csharp
import semmle.code.csharp.commons.Util
import semmle.code.csharp.frameworks.Test
import semmle.code.csharp.metrics.Coupling

predicate potentiallyUsedFromXaml(RefType t) {
  exists(string name | name = t.getABaseType*().getQualifiedName() |
    name = "System.Windows.Data.IValueConverter" or
    name = "System.Windows.Data.IMultiValueConverter"
  )
}

class ExportAttribute extends Attribute {
  ExportAttribute() {
    getType().hasQualifiedName("System.ComponentModel.Composition.ExportAttribute")
  }
}

from RefType t
where
  not extractionIsStandalone() and
  t.fromSource() and
  t = t.getSourceDeclaration() and
  not t instanceof AnonymousClass and
  not (t.isPublic() or t.isProtected()) and
  not exists(ValueOrRefType dependent | depends(dependent, t) and dependent != t) and
  not exists(ConstructedType ct | usesType(ct, t)) and
  not exists(MethodCall call | usesType(call.getTarget().(ConstructedMethod).getATypeArgument(), t)) and
  not t.getAMethod() instanceof MainMethod and
  not potentiallyUsedFromXaml(t) and
  not exists(TypeofExpr typeof | typeof.getTypeAccess().getTarget() = t) and
  not t instanceof TestClass and
  // MemberConstant nodes are compile-time constant and can appear in various contexts
  // where they don't have enclosing callables or types (e.g. in attribute values).
  // Classes that are declared purely to hold member constants which are used are,
  // therefore, not dead.
  not exists(t.getAMember().(MemberConstant).getAnAccess()) and
  not t.getAnAttribute() instanceof ExportAttribute
select t, "Unused reference type " + t + "."
