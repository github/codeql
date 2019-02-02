private import cpp
private import semmle.code.cpp.ir.implementation.TempVariableTag
private import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as Construction

newtype TIRVariable =
  TIRAutomaticUserVariable(LocalScopeVariable var, Function func) {
    var.getFunction() = func or
    var.(Parameter).getCatchBlock().getEnclosingFunction() = func
  } or
  TIRStaticUserVariable(Variable var, Function func) {
    (
      var instanceof GlobalOrNamespaceVariable or
      var instanceof MemberVariable and not var instanceof Field
    ) and
    exists(VariableAccess access |
      access.getTarget() = var and
      access.getEnclosingFunction() = func
    )
  } or
  TIRTempVariable(Function func, Locatable ast, TempVariableTag tag, Type type) {
    Construction::hasTempVariable(func, ast, tag, type)
  }

