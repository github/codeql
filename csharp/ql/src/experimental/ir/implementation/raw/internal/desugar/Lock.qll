/**
 * File that provides the desugaring of a `lock` stmt.
 * The statement:
 *    ```csharp
 *      lock (anExpr) ...
 *    ```
 * gets desugared to:
 *    ```csharp
 *      SomeRefType lockedVar = anExpr;
 *      bool __lockWasTaken = false;
 *      try {
 *        System.Threading.Monitor.Enter(lockedVar, ref __lockWasTaken);
 *        ...
 *      }
 *      finally {
 *        if (__lockWasTaken) System.Threading.Monitor.Exit(lockedVar);
 *      }
 *    ```
 */

import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.TempVariableTag
private import experimental.ir.implementation.raw.internal.TranslatedExpr
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.TranslatedStmt
private import experimental.ir.implementation.raw.internal.common.TranslatedExprBase
private import experimental.ir.implementation.raw.internal.common.TranslatedConditionBase
private import experimental.ir.implementation.raw.internal.InstructionTag
private import experimental.ir.internal.IRCSharpLanguage as Language
private import Common
private import internal.TranslatedCompilerGeneratedStmt
private import internal.TranslatedCompilerGeneratedCall
private import internal.TranslatedCompilerGeneratedDeclaration
private import internal.TranslatedCompilerGeneratedCondition
private import internal.TranslatedCompilerGeneratedElement
private import internal.TranslatedCompilerGeneratedExpr

/**
 * Module that exposes the functions needed for the translation of the `lock` stmt.
 */
module LockElements {
  TranslatedLockedVarDecl getLockedVarDecl(LockStmt generatedBy) { result.getAST() = generatedBy }

  TranslatedLockTry getTry(LockStmt generatedBy) { result.getAST() = generatedBy }

  TranslatedLockWasTakenDecl getLockWasTakenDecl(LockStmt generatedBy) {
    result.getAST() = generatedBy
  }

  int noGeneratedElements() { result = 14 }
}

/**
 * The translation of the `try` stmt.
 */
private class TranslatedLockTry extends TranslatedCompilerGeneratedTry,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedLockTry() { this = TTranslatedCompilerGeneratedElement(generatedBy, 0) }

  override TranslatedElement getFinally() {
    exists(TranslatedLockFinally fin |
      fin.getAST() = generatedBy and
      result = fin
    )
  }

  override TranslatedElement getBody() {
    exists(TranslatedLockTryBody ltb |
      ltb.getAST() = generatedBy and
      result = ltb
    )
  }
}

/**
 * The translation of the `lock` stmt's body.
 */
private class TranslatedLockTryBody extends TranslatedCompilerGeneratedBlock,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedLockTryBody() { this = TTranslatedCompilerGeneratedElement(generatedBy, 1) }

  override TranslatedElement getStmt(int index) {
    index = 0 and
    exists(TranslatedMonitorEnter me |
      me.getAST() = generatedBy and
      result = me
    )
    or
    index = 1 and
    result = getTranslatedStmt(generatedBy.getBlock())
  }
}

/**
 * The translation of the finally block.
 */
private class TranslatedLockFinally extends TranslatedCompilerGeneratedBlock,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedLockFinally() { this = TTranslatedCompilerGeneratedElement(generatedBy, 2) }

  override TranslatedElement getStmt(int index) {
    index = 0 and
    exists(TranslatedFinallyIf fif |
      fif.getAST() = generatedBy and
      result = fif
    )
  }
}

/**
 * The translation of the call to dispose (inside the finally block)
 */
private class TranslatedMonitorExit extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedMonitorExit() { this = TTranslatedCompilerGeneratedElement(generatedBy, 3) }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    exists(Callable exit |
      exit.getQualifiedName() = "System.Threading.Monitor.Exit" and
      result = exit
    )
  }

  final override Type getCallResultType() { result instanceof VoidType }

  override TranslatedExprBase getArgument(int id) {
    id = 0 and
    exists(TranslatedMonitorExitVarAcc var |
      var.getAST() = generatedBy and
      result = var
    )
  }

  override TranslatedExprBase getQualifier() { none() }

  override Instruction getQualifierResult() { none() }
}

/**
 * The translation of the call to dispose (inside the finally block)
 */
private class TranslatedMonitorEnter extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedMonitorEnter() { this = TTranslatedCompilerGeneratedElement(generatedBy, 4) }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    exists(Callable dispose |
      dispose.getQualifiedName() = "System.Threading.Monitor.Enter" and
      result = dispose
    )
  }

  final override Type getCallResultType() { result instanceof VoidType }

  override TranslatedExprBase getArgument(int id) {
    id = 0 and
    exists(TranslatedMonitorEnterVarAcc var |
      var.getAST() = generatedBy and
      result = var
    )
    or
    id = 1 and
    exists(TranslatedLockWasTakenRefArg refArg |
      refArg.getAST() = generatedBy and
      result = refArg
    )
  }

  override TranslatedExprBase getQualifier() { none() }

  override Instruction getQualifierResult() { none() }
}

/**
 * The translation of the condition of the `if` present in the `finally` clause.
 */
private class TranslatedIfCondition extends TranslatedCompilerGeneratedValueCondition,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedIfCondition() { this = TTranslatedCompilerGeneratedElement(generatedBy, 5) }

  override TranslatedCompilerGeneratedExpr getValueExpr() {
    exists(TranslatedLockWasTakenCondVarAcc condVar |
      condVar.getAST() = generatedBy and
      result = condVar
    )
  }

  override Instruction valueExprResult() { result = getValueExpr().getResult() }
}

/**
 * The translation of the `if` stmt present in the `finally` clause.
 */
private class TranslatedFinallyIf extends TranslatedCompilerGeneratedIfStmt,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedFinallyIf() { this = TTranslatedCompilerGeneratedElement(generatedBy, 6) }

  override TranslatedCompilerGeneratedValueCondition getCondition() {
    exists(TranslatedIfCondition cond |
      cond.getAST() = generatedBy and
      result = cond
    )
  }

  override TranslatedCompilerGeneratedCall getThen() {
    exists(TranslatedMonitorExit me |
      me.getAST() = generatedBy and
      result = me
    )
  }

  override TranslatedCompilerGeneratedCall getElse() { none() }
}

/**
 * Represents the translation of the constant that is part of the initialization for the
 * bool temp variable.
 */
private class TranslatedWasTakenConst extends TranslatedCompilerGeneratedConstant,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedWasTakenConst() { this = TTranslatedCompilerGeneratedElement(generatedBy, 7) }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = "false"
  }

  override Instruction getResult() { result = getInstruction(OnlyInstructionTag()) }

  override Type getResultType() { result instanceof BoolType }
}

/**
 * Represents the translation of the `lockWasTaken` temp variable declaration.
 */
private class TranslatedLockWasTakenDecl extends TranslatedCompilerGeneratedDeclaration,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedLockWasTakenDecl() { this = TTranslatedCompilerGeneratedElement(generatedBy, 8) }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = LockWasTakenTemp() and
    type = getBoolType()
  }

  override IRTempVariable getIRVariable() {
    result = getIRTempVariable(generatedBy, LockWasTakenTemp())
  }

  override TranslatedCompilerGeneratedExpr getInitialization() {
    exists(TranslatedWasTakenConst const |
      const.getAST() = generatedBy and
      result = const
    )
  }

  override Type getVarType() { result = getInitialization().getResultType() }

  override Instruction getInitializationResult() { result = getInitialization().getResult() }
}

/**
 * Represents the translation of the declaration of the temp variable that is initialized to the
 * expression being locked.
 */
private class TranslatedLockedVarDecl extends TranslatedCompilerGeneratedDeclaration,
  TTranslatedCompilerGeneratedElement {
  override LockStmt generatedBy;

  TranslatedLockedVarDecl() { this = TTranslatedCompilerGeneratedElement(generatedBy, 9) }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = LockedVarTemp() and
    type = getTypeForPRValue(generatedBy.getExpr().getType())
  }

  override IRTempVariable getIRVariable() {
    result = getIRTempVariable(generatedBy, LockedVarTemp())
  }

  override TranslatedExprBase getInitialization() {
    result = getTranslatedExpr(generatedBy.getExpr())
  }

  override Type getVarType() { result = generatedBy.getExpr().getType() }

  override Instruction getInitializationResult() { result = getInitialization().getResult() }
}

/**
 * Represents the translation of access to the temp variable that is initialized to the
 * expression being locked.
 * Used as an argument for the `MonitorEnter` call.
 */
private class TranslatedMonitorEnterVarAcc extends TTranslatedCompilerGeneratedElement,
  TranslatedCompilerGeneratedVariableAccess {
  override LockStmt generatedBy;

  TranslatedMonitorEnterVarAcc() { this = TTranslatedCompilerGeneratedElement(generatedBy, 10) }

  override Type getResultType() { result = generatedBy.getExpr().getType() }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = LockedVarTemp() and
    type = getTypeForPRValue(getResultType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getTempVariable(LockedVarTemp())
  }

  override predicate needsLoad() { any() }
}

/**
 * Represents the translation of access to the temp variable that is initialized to the
 * expression being locked.
 * Used as an argument for the `MonitorExit` call.
 */
private class TranslatedMonitorExitVarAcc extends TTranslatedCompilerGeneratedElement,
  TranslatedCompilerGeneratedVariableAccess {
  override LockStmt generatedBy;

  TranslatedMonitorExitVarAcc() { this = TTranslatedCompilerGeneratedElement(generatedBy, 11) }

  override Type getResultType() { result = generatedBy.getExpr().getType() }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getTempVariable(LockedVarTemp())
  }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = LockedVarTemp() and
    type = getTypeForPRValue(getResultType())
  }

  override predicate needsLoad() { any() }
}

/**
 * Represents that translation of access to the temporary bool variable.
 * Used as an argument for the `MonitorEnter` call.
 */
private class TranslatedLockWasTakenCondVarAcc extends TTranslatedCompilerGeneratedElement,
  TranslatedCompilerGeneratedVariableAccess {
  override LockStmt generatedBy;

  TranslatedLockWasTakenCondVarAcc() { this = TTranslatedCompilerGeneratedElement(generatedBy, 12) }

  override Type getResultType() { result instanceof BoolType }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = LockWasTakenTemp() and
    type = getTypeForPRValue(getResultType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getTempVariable(LockWasTakenTemp())
  }

  override predicate needsLoad() { any() }
}

/**
 * That represents that translation of access to the temporary bool variable. Its value is used
 * as the `if` condition in the finally clause.
 */
private class TranslatedLockWasTakenRefArg extends TTranslatedCompilerGeneratedElement,
  TranslatedCompilerGeneratedVariableAccess {
  override LockStmt generatedBy;

  TranslatedLockWasTakenRefArg() { this = TTranslatedCompilerGeneratedElement(generatedBy, 13) }

  override Type getResultType() { result instanceof BoolType }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = LockWasTakenTemp() and
    type = getTypeForPRValue(getResultType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getTempVariable(LockWasTakenTemp())
  }

  override predicate needsLoad() { none() }
}
