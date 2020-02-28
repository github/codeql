private import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.ir.internal.IRUtilities
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedInitialization

/**
 * Gets the `TranslatedDeclarationEntry` that represents the declaration
 * `entry`.
 */
TranslatedDeclarationEntry getTranslatedDeclarationEntry(DeclarationEntry entry) {
  result.getAST() = entry
}

/**
 * Represents the IR translation of a declaration within the body of a function.
 * Most often, this is the declaration of an automatic local variable, although
 * it can also be the declaration of a static local variable. Declarations of extern variables and
 * functions do not have a `TranslatedDeclarationEntry`.
 */
abstract class TranslatedDeclarationEntry extends TranslatedElement, TTranslatedDeclarationEntry {
  DeclarationEntry entry;

  TranslatedDeclarationEntry() { this = TTranslatedDeclarationEntry(entry) }

  final override Function getFunction() {
    exists(DeclStmt stmt |
      stmt.getADeclarationEntry() = entry and
      result = stmt.getEnclosingFunction()
    )
  }

  final override string toString() { result = entry.toString() }

  final override Locatable getAST() { result = entry }
}

/**
 * Represents the IR translation of the declaration of a local variable,
 * including its initialization, if any.
 */
abstract class TranslatedLocalVariableDeclaration extends TranslatedVariableInitialization {
  /**
   * Gets the local variable being declared.
   */
  abstract LocalVariable getVariable();

  final override Type getTargetType() { result = getVariableType(getVariable()) }

  final override TranslatedInitialization getInitialization() {
    result =
      getTranslatedInitialization(getVariable().getInitializer().getExpr().getFullyConverted())
  }

  final override Instruction getInitializationSuccessor() {
    result = getParent().getChildSuccessor(this)
  }

  final override IRVariable getIRVariable() {
    result = getIRUserVariable(getFunction(), getVariable())
  }
}

/**
 * Represents the IR translation of a local variable declaration within a declaration statement.
 */
class TranslatedVariableDeclarationEntry extends TranslatedLocalVariableDeclaration,
  TranslatedDeclarationEntry {
  LocalVariable var;

  TranslatedVariableDeclarationEntry() { var = entry.getDeclaration() }

  override LocalVariable getVariable() { result = var }
}

/**
 * Gets the `TranslatedRangeBasedForVariableDeclaration` that represents the declaration of
 * `var`.
 */
TranslatedRangeBasedForVariableDeclaration getTranslatedRangeBasedForVariableDeclaration(
  LocalVariable var
) {
  result.getVariable() = var
}

/**
 * Represents the IR translation of a compiler-generated variable in a range-based `for` loop.
 */
class TranslatedRangeBasedForVariableDeclaration extends TranslatedLocalVariableDeclaration,
  TTranslatedRangeBasedForVariableDeclaration {
  RangeBasedForStmt forStmt;
  LocalVariable var;

  TranslatedRangeBasedForVariableDeclaration() {
    this = TTranslatedRangeBasedForVariableDeclaration(forStmt, var)
  }

  override string toString() { result = var.toString() }

  override Locatable getAST() { result = var }

  override Function getFunction() { result = forStmt.getEnclosingFunction() }

  override LocalVariable getVariable() { result = var }
}

TranslatedConditionDecl getTranslatedConditionDecl(ConditionDeclExpr expr) {
  result.getAST() = expr
}

/**
 * Represents the IR translation of the declaration portion of a `ConditionDeclExpr`, which
 * represents the variable declared in code such as:
 * ```
 * if (int* p = &x) {
 * }
 * ```
 */
class TranslatedConditionDecl extends TranslatedLocalVariableDeclaration, TTranslatedConditionDecl {
  ConditionDeclExpr conditionDeclExpr;

  TranslatedConditionDecl() { this = TTranslatedConditionDecl(conditionDeclExpr) }

  override string toString() { result = "decl: " + conditionDeclExpr.toString() }

  override Locatable getAST() { result = conditionDeclExpr }

  override Function getFunction() { result = conditionDeclExpr.getEnclosingFunction() }

  override LocalVariable getVariable() { result = conditionDeclExpr.getVariable() }
}
