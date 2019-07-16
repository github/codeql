private import csharp
private import semmle.code.csharp.ir.implementation.TempVariableTag
private import semmle.code.csharp.ir.implementation.raw.internal.IRConstruction as Construction
private import semmle.code.csharp.ir.Util

newtype TIRVariable =
  TIRAutomaticUserVariable(LocalScopeVariable var, Callable callable) {
    Construction::callableHasIR(callable) and
    var.getCallable() = callable
  } or
  TIRStaticUserVariable(Variable var, Callable callable) {
    Construction::callableHasIR(callable) and
// TODO: CHECK FOR CORRESPONDENCE HERE
//    (
//      var instanceof GlobalOrNamespaceVariable or
//      var instanceof MemberVariable and not var instanceof Field
//    ) and
    exists(VariableAccess access |
      access.getTarget() = var and
      access.getEnclosingCallable() = callable
    )
  } or
  TIRTempVariable(Callable callable, Locatable ast, TempVariableTag tag, Type type) {
    Construction::hasTempVariable(callable, ast, tag, type)
  }

