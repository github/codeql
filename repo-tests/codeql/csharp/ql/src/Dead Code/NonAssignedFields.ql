/**
 * @name Field is never assigned a non-default value
 * @description Fields are automatically initialised with the default values for their type, which may not be the intent: prefer explicit initialisation.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/unassigned-field
 * @tags reliability
 *       maintainability
 *       useless-code
 *       external/cwe/cwe-457
 */

import csharp
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.frameworks.system.runtime.InteropServices

// Any field transitively contained in t.
Field getANestedField(ValueOrRefType t) {
  result.getDeclaringType() = t
  or
  exists(Field mid |
    mid = getANestedField(t) and
    mid.getType() = result.getDeclaringType()
  )
}

// Any ValueOrRefType referenced by a Type, including TypeParameters.
ValueOrRefType getAReferencedType(Type t) {
  result = t
  or
  result = t.(TypeParameter).getASuppliedType()
}

predicate isTypeExternallyInitialized(ValueOrRefType t) {
  // The type got created via a call to PtrToStructure().
  exists(MethodCall mc, Type t0, Expr arg |
    mc.getTarget() = any(SystemRuntimeInteropServicesMarshalClass c).getPtrToStructureTypeMethod() and
    t = getAReferencedType(t0) and
    arg = mc.getArgument(1)
  |
    t0 = arg.(TypeofExpr).getTypeAccess().getTarget()
    or
    t0 = arg.getType()
  )
  or
  // An extern method exists which could initialize the type.
  exists(Method m, Parameter p |
    isExternMethod(m) and
    p = m.getAParameter() and
    t = p.getType()
  |
    p.isOut() or p.isRef()
  )
  or
  // The data structure has been cast to a pointer - all bets are off.
  exists(CastExpr c | t = getAReferencedType(c.getTargetType().(PointerType).getReferentType()))
}

// The type is potentially marshaled using an extern or interop.
predicate isFieldExternallyInitialized(Field f) {
  exists(ValueOrRefType t |
    f = getANestedField(t) and
    isTypeExternallyInitialized(t)
  )
}

predicate isExternMethod(Method externMethod) {
  externMethod.isExtern()
  or
  externMethod.getAnAttribute().getType() instanceof
    SystemRuntimeInteropServicesDllImportAttributeClass
  or
  externMethod.getDeclaringType().getAnAttribute().getType() instanceof
    SystemRuntimeInteropServicesComImportAttributeClass
}

from Field f, FieldRead fa
where
  f.fromSource() and
  not extractionIsStandalone() and
  not f.isReadOnly() and
  not f.isConst() and
  not f.getDeclaringType() instanceof Enum and
  not f.getType() instanceof Struct and
  not exists(Assignment ae, Field g |
    ae.getLValue().(FieldAccess).getTarget() = g and
    g.getUnboundDeclaration() = f and
    not ae.getRValue() instanceof NullLiteral
  ) and
  not exists(MethodCall mc, int i, Field g |
    exists(Parameter p | mc.getTarget().getParameter(i) = p | p.isOut() or p.isRef()) and
    mc.getArgument(i) = g.getAnAccess() and
    g.getUnboundDeclaration() = f
  ) and
  not isFieldExternallyInitialized(f) and
  not exists(f.getAnAttribute()) and
  not exists(Expr init, Field g |
    g.getUnboundDeclaration() = f and
    g.getInitializer() = init and
    not init instanceof NullLiteral
  ) and
  not exists(AssignOperation ua, Field g |
    ua.getLValue().(FieldAccess).getTarget() = g and
    g.getUnboundDeclaration() = f
  ) and
  not exists(MutatorOperation op |
    op.getAnOperand().(FieldAccess).getTarget().getUnboundDeclaration() = f
  ) and
  exists(Field g |
    fa.getTarget() = g and
    g.getUnboundDeclaration() = f
  )
select f,
  "The field '" + f.getName() + "' is never explicitly assigned a value, yet it is read $@.", fa,
  "here"
