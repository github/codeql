/**
 * Provides classes and predicates for reasoning about the mode
 * of file system entry creations.
 */

import javascript

/**
 * Gets the overpermissive mode mask for file creations.
 * This detects world write/execute permission.
 */
Mask getOverpermissiveFileMask() { result = 3 /* 003 o+wx */ }

/**
 * Get the overpermissive mode mask for directory creations.
 * This detects world write permission.
 */
Mask getOverpermissiveDirectoryMask() { result = 2 /* 002 o+w */ }

/**
 * Gets the overpermissive mode constants for file creations.
 * This detects world write/execute permission.
 */
string getAnOverpermissiveFileConstant() { result = ["S_IRWXO", "S_IWOTH", "S_IXOTH"] }

/**
 * Gets the overpermissive mode constants for directory creations.
 * This detects world write permission.
 */
string getAnOverpermissiveDirectoryConstant() { result = ["S_IRWXO", "S_IWOTH"] }

/**
 * An expression that can modify a value.
 *
 * Either an arithmetic operator (`ArithmeticExpr`), a bitwise operator (`BitwiseExpr`),
 * a compound assignment (`CompoundAssignExpr`), a unary operator (`UnaryExpr`),
 * or a function invocation (`InvokeExpr`).
 */
class ModifyExpr extends Expr {
  ModifyExpr() {
    this instanceof ArithmeticExpr or
    this instanceof BitwiseExpr or
    this instanceof CompoundAssignExpr or
    this instanceof UnaryExpr or
    this instanceof InvokeExpr
  }

  /** Gets an input to this expression. */
  Expr getAnInput() {
    this instanceof UnaryExpr and result = this.(UnaryExpr).getOperand()
    or
    this instanceof BinaryExpr and result = this.(BinaryExpr).getAnOperand()
    or
    this instanceof CompoundAssignExpr and result = [
      this.(CompoundAssignExpr).getLhs(),
      this.(CompoundAssignExpr).getRhs()
    ]
    or
    this instanceof InvokeExpr and result = this.(InvokeExpr).getAnArgument()
  }
}

/**
 * An expression that performs bitwise inclusive disjunction.
 *
 * Either a bitwise or (`BitOrExpr`) or a bitwise or assignment (`AssignOrExpr`).
 *
 * Examples:
 * ```js
 * a | b
 * c |= d
 * ```
 */
class InclusiveDisjunction extends Expr {
  InclusiveDisjunction() {
    this instanceof BitOrExpr or
    this instanceof AssignOrExpr
  }

  /** Gets an input to this expression. */
  Expr getAnInput() {
    this instanceof BitOrExpr and result = this.(BitOrExpr).getAnOperand()
    or
    this instanceof AssignOrExpr and result = [
      this.(AssignOrExpr).getLhs(),
      this.(AssignOrExpr).getRhs()
    ]
  }
}

/**
 * An expression that performs bitwise exclusive disjunction.
 *
 * Either a bitwise xor (`XOrExpr`) or a bitwise xor assignment (`AssignXOrExpr`).
 *
 * Examples:
 * ```js
 * a ^ b
 * c ^= d
 * ```
 */
class ExclusiveDisjunction extends Expr {
  ExclusiveDisjunction() {
    this instanceof XOrExpr or
    this instanceof AssignXOrExpr
  }

  /** Gets an input to this expression. */
  Expr getAnInput() {
    this instanceof XOrExpr and result = this.(XOrExpr).getAnOperand()
    or
    this instanceof AssignXOrExpr and result = [
      this.(AssignXOrExpr).getLhs(),
      this.(AssignXOrExpr).getRhs()
    ]
  }
}

/**
 * An expression that masks with an inverse, commonly used to clear bits in a bit field.
 *
 * For example:
 * ```js
 * 0o777 & ~fs.constants.S_IRWXO
 * ```
 */
class MaskInverseExpr extends BitAndExpr {
  MaskInverseExpr() { this.getAnOperand() instanceof BitNotExpr }

  /** Gets an input to this expression. */
  Expr getAnInput() {
    result = [
      this.getAnOperand(),
      this.getAnOperand().(BitNotExpr).getOperand(),
      this.getAnOperand().(BitNotExpr).getOperand().(ParExpr).getExpression()
    ]
  }
}

/** A bitwise negation that is used in a mask inverse expression. */
class MaskInverseNotExpr extends BitNotExpr {
  MaskInverseNotExpr() {
    exists(BitAndExpr conjunction | this = conjunction.getAnOperand())
  }
}

/**
 * An expression that clears bits in a bit field.
 *
 * Either a mask inverse epxression (`MaskInverseExpr`)
 * or an exclusive disjunction (`ExclusiveDisjunction`).
 *
 * Examples:
 * ```js
 * 0o777 & ~fs.constants.S_IRWXO
 * 0o777 ^ fs.constants.S_IRWXO
 * ```
 */
class ClearBitExpr extends Expr {
  ClearBitExpr() {
    this instanceof MaskInverseExpr or
    this instanceof ExclusiveDisjunction
  }

  Expr getAnInput() {
    this instanceof MaskInverseExpr and result = this.(MaskInverseExpr).getAnInput()
    or
    this instanceof ExclusiveDisjunction and result = this.(ExclusiveDisjunction).getAnInput()
  }
}

/**
 * An expression that corrupts mode construction by inclusion.
 *
 * Any modify expression other than inclusive disjunctions.
 *
 * For example:
 * ```js
 * const mode = fs.constants.S_IRWXU | fs.constants.S_IRWXG
 * fs.writeFile('/tmp/file', '', { mode: mode + 1 })
 * ```
 */
class InclusionCorruptingExpr extends ModifyExpr {
  InclusionCorruptingExpr() { not this instanceof InclusiveDisjunction }
}

/**
 * An expression that corrupts mode construction by exclusion.
 *
 * Any modify expression other than a XOR, a mask inverse expression,
 * or the negation component of a mask inverse expression.
 */
class ExclusionCorruptingExpr extends ModifyExpr {
  ExclusionCorruptingExpr() {
    not this instanceof ClearBitExpr and
    not this instanceof MaskInverseNotExpr
  }
}

/** A flow label signaling mode construction has been corrupted. */
class CorruptLabel extends DataFlow::FlowLabel {
  CorruptLabel() { this = "corrupt" }
}

/**
 * Gets the integer value of `specifier`,
 * or the maximum integer if the specifier is larger than that.
 */
private int getNumberMode(NumberLiteral specifier) {
  result = specifier.getFloatValue().ceil()
}

/**
 * Gets the integer value of the low 3 digits of `specifier`,
 * interpreted as an octal numeric string.
 */
private int getStringMode(StringLiteral specifier) {
  result = fromOctalString(getRelevantDigits(specifier))
}

/** Gets the low 3 digits of the octal numeric string `specifier`. */
private string getRelevantDigits(StringLiteral specifier) {
  result = specifier.getStringValue().regexpCapture("^[0-7]*([0-7]{1,3})$", 1)
}

/** Gets the integer value of `digits`, interpreted as an octal numeric string. */
bindingset[digits]
private int fromOctalString(string digits) {
  result = sum(int i | i in [0 .. digits.length()] |
    digits.charAt(i).toInt().bitShiftLeft(3 * (digits.length() - i - 1))
  )
}

/** Gets the mode represented by `specifier`. */
private int getMode(LiteralSpecifier specifier) {
  specifier instanceof NumberLiteral and result = getNumberMode(specifier)
  or
  specifier instanceof StringLiteral and result = getStringMode(specifier)
}

/**
 * Holds if the mode represented by `specifier` is overpermissive.
 * `mask` specifies which bits are considered overpermissive.
 */
predicate specifierOverpermissive(LiteralSpecifier specifier, Mask mask) {
  getMode(specifier).bitAnd(mask) != 0
}

/** An integer usable as a mode mask. */
class Mask extends int {
  Mask() { this in [0 .. 511] /* 000-777 */ }
}

/**
 * A literal capable of representing a mode.
 *
 * Either a number (`NumberLiteral`) or a string (`StringLiteral`).
 *
 * Examples:
 * ```js
 * 0o777
 * '777'
 * ```
 */
class LiteralSpecifier extends Literal {
  LiteralSpecifier() {
    this instanceof NumberLiteral or
    this instanceof StringLiteral
  }
}

/** An invocation that can create a file system entry. */
abstract class EntryCreation extends DataFlow::InvokeNode {}

/** An entry creation whose mode can be evaluated statically. */
abstract class EvaluableEntryCreation extends EntryCreation {
  /** Holds if the invocation can create a file system entry with insecure permissions. */
  abstract predicate isOverpermissive();
}

/** An entry creation that cannot be secured, because it offers no way to specify mode. */
abstract class UnsecurableEntryCreation extends EvaluableEntryCreation {
  override predicate isOverpermissive() { any() }
}

/** An entry creation that offers a way to specify mode. */
abstract class ModableEntryCreation extends EntryCreation {
  /** Gets the argument through which mode is specified. */
  cached
  abstract Expr getArgument();

  /** Gets the mode specifier. */
  cached
  abstract Expr getSpecifier();

  /** Gets the type of the argument through which mode is specified. */
  cached
  string getArgumentType() {
    result = this.getArgument().flow().analyze().getAType().getTypeofTag()
  }

  /** Holds if the invocation provides the mode argument. */
  predicate hasArgument() { exists(this.getArgument()) }

  /** Holds if the invocation does not provide the mode argument. */
  predicate hasElidedArgument() { not this.hasArgument() }

  /** Holds if the invocation provides `undefined` for the mode argument. */
  predicate hasUndefinedArgument() {
    this.getArgument().analyze().getAValue() instanceof AbstractUndefined
  }

  /** Holds if the invocation provides a mode argument that is not `undefined`. */
  predicate hasDefinedArgument() { this.hasArgument() and not this.hasUndefinedArgument() }

  /** Holds if the invocation provides a mode specifier. */
  predicate hasSpecifier() { exists(this.getSpecifier()) }

  /** Holds if the invocation does not provide a mode specifier. */
  predicate hasElidedSpecifier() { not this.hasSpecifier() }

  /** Holds if the invocation provides `undefined` for the mode specifier. */
  predicate hasUndefinedSpecifier() {
    this.getSpecifier().analyze().getAValue() instanceof AbstractUndefined
  }

  /** Holds if the invocation provides a mode specifier that is not `undefined`. */
  predicate hasDefinedSpecifier() { this.hasSpecifier() and not this.hasUndefinedSpecifier() }

  /** Holds if the invocation does not specify mode. */
  predicate isModeless() {
    this.hasElidedArgument() or
    this.hasUndefinedArgument() or
    this.hasElidedSpecifier() or
    this.hasUndefinedSpecifier()
  }

  /** Holds if the invocation specifies mode. */
  predicate isModal() {
    this.hasDefinedArgument() and
    this.hasDefinedSpecifier()
  }
}

/** An entry creation that takes mode through argument 1. */
abstract class Argument1EntryCreation extends ModableEntryCreation {
  override Expr getArgument() { result = this.getArgument(1).asExpr() }
}

/** An entry creation that takes mode through argument 2. */
abstract class Argument2EntryCreation extends ModableEntryCreation {
  override Expr getArgument() { result = this.getArgument(2).asExpr() }
}

/**
 * An entry creation that takes an immediate mode specifier.
 *
 * For example:
 * ```js
 * fs.open('/tmp/file', 'r', 0o700)
 * ```
 */
abstract class ImmediateSpecifierEntryCreation extends ModableEntryCreation {
  override Expr getSpecifier() { this.hasModeArgument() and result = this.getArgument() }

  private predicate hasModeArgument() { this.getArgumentType() = ["number", "string"] }
}

/**
 * An entry creation that takes mode specifier in an object property named `mode`.
 *
 * For example:
 * ```js
 * fs.writeFile('/tmp/file', '', { mode: 0o700 })
 * ```
 */
abstract class PropertySpecifierEntryCreation extends ModableEntryCreation {
  override Expr getSpecifier() {
    this.getArgumentType() = "object" and
    result = this.getArgument().(ObjectExpr).getPropertyByName("mode").getInit()
  }
}

/**
 * An entry creation that takes mode specifier either as an immediate value
 * or in an object property named `mode`.
 *
 * For example:
 * ```js
 * fs.mkdir('/tmp/dir', 0o700)
 * fs.mkdir('/tmp/dir', { mode: 0o700 })
 * ```
 */
abstract class ImmediateOrPropertySpecifierEntryCreation extends ModableEntryCreation {
  override Expr getSpecifier() {
    this.hasImmediateMode() and result = this.getImmediateSpecifier()
    or
    this.hasPropertyMode() and result = this.getPropertySpecifier()
  }

  /** Holds if the invocation provides an immediate mode. */
  private predicate hasImmediateMode() { this.getArgumentType() = ["number", "string"] }

  /** Holds if the invocation provides an object for the mode argument. */
  private predicate hasPropertyMode() { this.getArgumentType() = "object" }

  /** Gets the mode specifier provided as an immediate value. */
  private Expr getImmediateSpecifier() { result = this.getArgument() }

  /** Gets the mode specifier provided in an object property name `mode`. */
  private Expr getPropertySpecifier() {
    result = this.getArgument().(ObjectExpr).getPropertyByName("mode").getInit()
  }
}

/**
 * An entry creation that provides a literal mode specifier.
 *
 * Examples:
 * ```js
 * fs.writeFile('/tmp/file', '', { mode: 0o700 })
 * fs.open('/tmp/file', 'r', '777')
 * ```
 */
abstract class LiteralEntryCreation extends ModableEntryCreation, EvaluableEntryCreation {
  LiteralEntryCreation() { this.getSpecifier() instanceof LiteralSpecifier }

  /** Gets the overpermissive mask for this invocation. */
  abstract Mask getMask();

  override predicate isOverpermissive() {
    specifierOverpermissive(this.getSpecifier(), this.getMask())
  }
}

/** An entry creation that can create a file. */
abstract class FileCreation extends EntryCreation {}

/** An entry creation that can create a directory. */
abstract class DirectoryCreation extends EntryCreation {}

/**
 * A taint tracking configuration for file system entry creation
 * with an overpermissive mode computed by including mode constants.
 */
abstract class OverpermissiveIncludedEntryCreation extends TaintTracking::Configuration {
  OverpermissiveIncludedEntryCreation() { this = "OverpermissiveIncludedEntryCreation" }

  override predicate isAdditionalTaintStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor
  ) {
    exists(InclusiveDisjunction disjunction |
      predecessor.asExpr() = disjunction.getAnInput() and
      successor = disjunction.flow()
    )
  }
}

/** A data flow configuration for a file system mode computed by excluding mode constants. */
abstract class ExcludedEntryModeConstruction extends DataFlow::Configuration {
  ExcludedEntryModeConstruction() { this = "ExcludedEntryModeConstruction" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof NumberLiteral and
    node.asExpr().(NumberLiteral).getFloatValue().ceil() >= 511 // >= 0o777
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor
  ) {
    exists(ClearBitExpr clear |
      predecessor.asExpr() = clear.getAnInput() and
      successor = clear.flow()
    )
  }
}

/** A data flow configuration for corruption of mode construction. */
abstract class EntryModeCorruption extends DataFlow::Configuration {
  EntryModeCorruption() { this = "EntryModeCorruption" }

  override predicate isSource(DataFlow::Node node) { any() }
}

/** A data flow configuration for corruption of a mode computed by including mode constants. */
abstract class IncludedEntryModeCorruption extends EntryModeCorruption {
  IncludedEntryModeCorruption() { this = "EntryModeCorruption" }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor,
    DataFlow::FlowLabel predLabel,
    DataFlow::FlowLabel succLabel
  ) {
    exists(ModifyExpr modification |
      predecessor.asExpr() = modification.getAnInput() and
      successor = modification.flow() and
      if predLabel instanceof CorruptLabel or modification instanceof InclusionCorruptingExpr
      then succLabel instanceof CorruptLabel
      else not succLabel instanceof CorruptLabel
    )
  }
}

/** A data flow configuration for corruption of a mode copmuted by excluding mode constants. */
abstract class ExcludedEntryModeCorruption extends EntryModeCorruption {
  ExcludedEntryModeCorruption() { this = "EntryModeCorruption" }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor,
    DataFlow::FlowLabel predLabel,
    DataFlow::FlowLabel succLabel
  ) {
    exists(ModifyExpr modification |
      predecessor.asExpr() = modification.getAnInput() and
      successor = modification.flow() and
      if predLabel instanceof CorruptLabel or modification instanceof ExclusionCorruptingExpr
      then succLabel instanceof CorruptLabel
      else not succLabel instanceof CorruptLabel
    )
  }
}

/**
 * A data flow configuration for entry creation with a computed mode
 * from which world write permission has been excluded.
 */
class WorldWriteExcludedEntryCreation extends DataFlow::Configuration {
  WorldWriteExcludedEntryCreation() { this = "WorldWriteExcludedEntryCreation" }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = ["S_IWOTH", "S_IRWXO"]
  }

  override predicate isAdditionalFlowStep(DataFlow::Node predecessor, DataFlow::Node successor) {
    exists(ClearBitExpr clear |
      predecessor.asExpr() = clear.getAnInput() and
      successor = clear.flow()
    )
  }
}

/**
 * A data flow configuration for entry creation with a computed mode
 * from which world execute permission has been excluded.
 */
class WorldExecuteExcludedEntryCreation extends DataFlow::Configuration {
  WorldExecuteExcludedEntryCreation() { this = "WorldExecuteExcludedEntryCreation" }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = ["S_IXOTH", "S_IRWXO"]
  }

  override predicate isAdditionalFlowStep(DataFlow::Node predecessor, DataFlow::Node successor) {
    exists(ClearBitExpr clear |
      predecessor.asExpr() = clear.getAnInput() and
      successor = clear.flow()
    )
  }
}
