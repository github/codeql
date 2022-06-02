/**
 * Provides classes that represent variables accessed by the IR.
 */

private import internal.IRInternal
import IRFunction
private import internal.IRVariableImports as Imports
import Imports::TempVariableTag
private import Imports::IRUtilities
private import Imports::TTempVariableTag
private import Imports::TIRVariable
private import Imports::IRType

/**
 * A variable referenced by the IR for a function.
 *
 * The variable may be a user-declared variable (`IRUserVariable`) or a temporary variable generated
 * by the AST-to-IR translation (`IRTempVariable`).
 */
class IRVariable extends TIRVariable {
  Language::Function func;

  IRVariable() {
    this = TIRUserVariable(_, _, func) or
    this = TIRTempVariable(func, _, _, _) or
    this = TIRStringLiteral(func, _, _, _) or
    this = TIRDynamicInitializationFlag(func, _, _)
  }

  /** Gets a textual representation of this element. */
  string toString() { none() }

  /**
   * Holds if this variable's value cannot be changed within a function. Currently used for string
   * literals, but could also apply to `const` global and static variables.
   */
  predicate isReadOnly() { none() }

  /**
   * Gets the type of the variable.
   */
  final Language::Type getType() { getLanguageType().hasType(result, false) }

  /**
   * Gets the language-neutral type of the variable.
   */
  final IRType getIRType() { result = getLanguageType().getIRType() }

  /**
   * Gets the type of the variable.
   */
  Language::LanguageType getLanguageType() { none() }

  /**
   * Gets the AST node that declared this variable, or that introduced this
   * variable as part of the AST-to-IR translation.
   */
  Language::AST getAst() { none() }

  /** DEPRECATED: Alias for getAst */
  deprecated Language::AST getAST() { result = getAst() }

  /**
   * Gets an identifier string for the variable. This identifier is unique
   * within the function.
   */
  string getUniqueId() { none() }

  /**
   * Gets the source location of this variable.
   */
  final Language::Location getLocation() { result = getAst().getLocation() }

  /**
   * Gets the IR for the function that references this variable.
   */
  final IRFunction getEnclosingIRFunction() { result.getFunction() = func }

  /**
   * Gets the function that references this variable.
   */
  final Language::Function getEnclosingFunction() { result = func }
}

/**
 * A user-declared variable referenced by the IR for a function.
 */
class IRUserVariable extends IRVariable, TIRUserVariable {
  Language::Variable var;
  Language::LanguageType type;

  IRUserVariable() { this = TIRUserVariable(var, type, func) }

  final override string toString() { result = getVariable().toString() }

  final override Language::AST getAst() { result = var }

  /** DEPRECATED: Alias for getAst */
  deprecated override Language::AST getAST() { result = getAst() }

  final override string getUniqueId() {
    result = getVariable().toString() + " " + getVariable().getLocation().toString()
  }

  final override Language::LanguageType getLanguageType() { result = type }

  /**
   * Gets the original user-declared variable.
   */
  Language::Variable getVariable() { result = var }
}

/**
 * A variable (user-declared or temporary) that is allocated on the stack. This includes all
 * parameters, non-static local variables, and temporary variables.
 */
class IRAutomaticVariable extends IRVariable {
  IRAutomaticVariable() {
    exists(Language::Variable var |
      this = TIRUserVariable(var, _, func) and
      Language::isVariableAutomatic(var)
    )
    or
    this = TIRTempVariable(func, _, _, _)
  }
}

/**
 * A user-declared variable that is allocated on the stack. This includes all parameters and
 * non-static local variables.
 */
class IRAutomaticUserVariable extends IRUserVariable, IRAutomaticVariable {
  override Language::AutomaticVariable var;

  final override Language::AutomaticVariable getVariable() { result = var }
}

/**
 * A user-declared variable that is not allocated on the stack. This includes all global variables,
 * namespace-scope variables, static fields, and static local variables.
 */
class IRStaticUserVariable extends IRUserVariable {
  override Language::StaticVariable var;

  IRStaticUserVariable() { not Language::isVariableAutomatic(var) }

  final override Language::StaticVariable getVariable() { result = var }
}

/**
 * A variable that is not user-declared. This includes temporary variables generated as part of IR
 * construction, as well as string literals.
 */
class IRGeneratedVariable extends IRVariable {
  Language::AST ast;
  Language::LanguageType type;

  IRGeneratedVariable() {
    this = TIRTempVariable(func, ast, _, type) or
    this = TIRStringLiteral(func, ast, type, _) or
    this = TIRDynamicInitializationFlag(func, ast, type)
  }

  final override Language::LanguageType getLanguageType() { result = type }

  final override Language::AST getAst() { result = ast }

  /** DEPRECATED: Alias for getAst */
  deprecated override Language::AST getAST() { result = getAst() }

  override string toString() { result = getBaseString() + getLocationString() }

  override string getUniqueId() { none() }

  /**
   * INTERNAL: Do not use.
   *
   * Gets a string containing the source code location of the AST that generated this variable.
   *
   * This is used by debugging and printing code only.
   */
  final string getLocationString() {
    result =
      ast.getLocation().getStartLine().toString() + ":" +
        ast.getLocation().getStartColumn().toString()
  }

  /**
   * INTERNAL: Do not use.
   *
   * Gets the string that is combined with the location of the variable to generate the string
   * representation of this variable.
   *
   * This is used by debugging and printing code only.
   */
  string getBaseString() { none() }
}

/**
 * A temporary variable introduced by IR construction. The most common examples are the variable
 * generated to hold the return value of a function, or the variable generated to hold the result of
 * a condition operator (`a ? b : c`).
 */
class IRTempVariable extends IRGeneratedVariable, IRAutomaticVariable, TIRTempVariable {
  TempVariableTag tag;

  IRTempVariable() { this = TIRTempVariable(func, ast, tag, type) }

  final override string getUniqueId() {
    result = "Temp: " + Construction::getTempVariableUniqueId(this)
  }

  /**
   * Gets the "tag" object that differentiates this temporary variable from other temporary
   * variables generated for the same AST.
   */
  final TempVariableTag getTag() { result = tag }

  override string getBaseString() { result = "#temp" }
}

/**
 * A temporary variable generated to hold the return value of a function.
 */
class IRReturnVariable extends IRTempVariable {
  IRReturnVariable() { tag = ReturnValueTempVar() }

  final override string toString() { result = "#return" }
}

/**
 * A temporary variable generated to hold the exception thrown by a `ThrowValue` instruction.
 */
class IRThrowVariable extends IRTempVariable {
  IRThrowVariable() { tag = ThrowTempVar() }

  final override string getBaseString() { result = "#throw" }
}

/**
 * A temporary variable generated to hold the contents of all arguments passed to the `...` of a
 * function that accepts a variable number of arguments.
 */
class IREllipsisVariable extends IRTempVariable, IRParameter {
  IREllipsisVariable() { tag = EllipsisTempVar() }

  final override string toString() { result = "#ellipsis" }

  final override int getIndex() { result = func.getNumberOfParameters() }
}

/**
 * A temporary variable generated to hold the `this` pointer.
 */
class IRThisVariable extends IRTempVariable, IRParameter {
  IRThisVariable() { tag = ThisTempVar() }

  final override string toString() { result = "#this" }

  final override int getIndex() { result = -1 }
}

/**
 * A variable generated to represent the contents of a string literal. This variable acts much like
 * a read-only global variable.
 */
class IRStringLiteral extends IRGeneratedVariable, TIRStringLiteral {
  Language::StringLiteral literal;

  IRStringLiteral() { this = TIRStringLiteral(func, ast, type, literal) }

  final override predicate isReadOnly() { any() }

  final override string getUniqueId() {
    result = "String: " + getLocationString() + "=" + Language::getStringLiteralText(literal)
  }

  final override string getBaseString() { result = "#string" }

  /**
   * Gets the AST of the string literal represented by this `IRStringLiteral`.
   */
  final Language::StringLiteral getLiteral() { result = literal }
}

/**
 * A variable generated to track whether a specific non-stack variable has been initialized. This is
 * used to model the runtime initialization of static local variables in C++, as well as static
 * fields in C#.
 */
class IRDynamicInitializationFlag extends IRGeneratedVariable, TIRDynamicInitializationFlag {
  Language::Variable var;

  IRDynamicInitializationFlag() {
    this = TIRDynamicInitializationFlag(func, var, type) and ast = var
  }

  final override string toString() { result = var.toString() + "#init" }

  /**
   * Gets variable whose initialization is guarded by this flag.
   */
  final Language::Variable getVariable() { result = var }

  final override string getUniqueId() {
    result = "Init: " + getVariable().toString() + " " + getVariable().getLocation().toString()
  }

  final override string getBaseString() { result = "#init:" + var.toString() + ":" }
}

/**
 * An IR variable which acts like a function parameter, including positional parameters and the
 * temporary variables generated for `this` and ellipsis parameters.
 */
class IRParameter extends IRAutomaticVariable {
  IRParameter() {
    this.(IRAutomaticUserVariable).getVariable() instanceof Language::Parameter
    or
    this = TIRTempVariable(_, _, ThisTempVar(), _)
    or
    this = TIRTempVariable(_, _, EllipsisTempVar(), _)
  }

  /**
   * Gets the zero-based index of this parameter. The `this` parameter has index -1.
   */
  int getIndex() { none() }
}

/**
 * An IR variable representing a positional parameter.
 */
class IRPositionalParameter extends IRParameter, IRAutomaticUserVariable {
  final override int getIndex() { result = getVariable().(Language::Parameter).getIndex() }
}
