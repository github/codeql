import javascript

// 003 o+wx
Mask getOverpermissiveFileMask() { result = 3 }

// 002 o+w
Mask getOverpermissiveDirectoryMask() { result = 2 }

// Group/world, write/execute
string getAnOverpermissiveFileConstant() {
  result = "S_IRWXO" or
  result = "S_IWOTH" or
  result = "S_IXOTH"
}

// Group/world, write
string getAnOverpermissiveDirectoryConstant() {
  result = "S_IRWXO" or
  result = "S_IWOTH"
}

class ModifyExpr extends Expr {
  ModifyExpr() {
    this instanceof AddExpr or
    this instanceof ArithmeticExpr or
    this instanceof BitwiseExpr or
    this instanceof CompoundAssignExpr or
    this instanceof UnaryExpr or
    this instanceof InvokeExpr
  }

  Expr getAFactor() {
    (this instanceof UnaryExpr and result = this.(UnaryExpr).getOperand()) or
    (this instanceof BinaryExpr and result = this.(BinaryExpr).getAnOperand()) or
    (this instanceof CompoundAssignExpr and (
      result = this.(CompoundAssignExpr).getLhs() or
      result = this.(CompoundAssignExpr).getRhs()
    )) or
    (this instanceof InvokeExpr and result = this.(InvokeExpr).getAnArgument())
  }
}

class InclusiveDisjunction extends Expr {
  InclusiveDisjunction() {
    this instanceof BitOrExpr or
    this instanceof AssignOrExpr
  }

  Expr getAFactor() {
    (this instanceof BitOrExpr and result = this.(BitOrExpr).getAnOperand()) or
    (this instanceof AssignOrExpr and (
      result = this.(AssignOrExpr).getLhs() or
      result = this.(AssignOrExpr).getRhs()
    ))
  }
}

class ExclusiveDisjunction extends Expr {
  ExclusiveDisjunction() {
    this instanceof XOrExpr or
    this instanceof AssignXOrExpr
  }

  Expr getAFactor() {
    (this instanceof XOrExpr and result = this.(XOrExpr).getAnOperand()) or
    (this instanceof AssignXOrExpr and (
      result = this.(AssignXOrExpr).getLhs() or
      result = this.(AssignXOrExpr).getRhs()
    ))
  }
}

class MaskInverseExpr extends BitAndExpr {
  MaskInverseExpr() { this.getAnOperand() instanceof BitNotExpr }

  Expr getAFactor() {
    result = this.getAnOperand() or
    result = this.getAnOperand().(BitNotExpr).getOperand() or
    result = this.getAnOperand().(BitNotExpr).getOperand().(ParExpr).getExpression()
  }
}

class MaskInverseNotExpr extends BitNotExpr {
  MaskInverseNotExpr() {
    exists(BitAndExpr conjunction | this = conjunction.getAnOperand())
  }
}

class ClearBitExpr extends Expr {
  ClearBitExpr() {
    this instanceof MaskInverseExpr or
    this instanceof ExclusiveDisjunction
  }

  Expr getAFactor() {
    (this instanceof MaskInverseExpr and result = this.(MaskInverseExpr).getAFactor()) or
    (this instanceof ExclusiveDisjunction and result = this.(ExclusiveDisjunction).getAFactor())
  }
}

class ExclusionCorruptingExpr extends ModifyExpr {
  ExclusionCorruptingExpr() {
    not this instanceof ClearBitExpr and
    not this instanceof MaskInverseNotExpr
  }
}

class CorruptLabel extends DataFlow::FlowLabel {
  CorruptLabel() { this = "corrupt" }
}

/**
 * Gets the integer value of the mode specifier,
 * or the maximum integer if the specifier is larger than that.
 */
private int getNumberMode(NumberLiteral specifier) {
  result = specifier.getFloatValue().ceil()
}

private int getStringMode(StringLiteral specifier) {
  result = fromOctalString(getRelevantDigits(specifier))
}

private string getRelevantDigits(StringLiteral specifier) {
  result = specifier
    .getStringValue()
    .regexpCapture("^[0-7]*([0-7]{1,3})$", 1)
}

bindingset[digits]
private int fromOctalString(string digits) {
  result = sum(int i | |
    digits
      .charAt(i)
      .toInt()
      .bitShiftLeft(3 * (digits.length() - i - 1))
  )
}

private int getMode(LiteralSpecifier specifier) {
  (specifier instanceof NumberLiteral and result = getNumberMode(specifier)) or
  (specifier instanceof StringLiteral and result = getStringMode(specifier))
}

predicate specifierOverpermissive(LiteralSpecifier specifier, Mask mask) {
  getMode(specifier).bitAnd(mask) != 0
}

// 000-777
class Mask extends int { Mask() { this in [0..511] } }

class LiteralSpecifier extends Literal {
  LiteralSpecifier() {
    this instanceof NumberLiteral or
    this instanceof StringLiteral
  }
}

abstract class EntryCreation extends DataFlow::InvokeNode {}

abstract class EvaluableEntryCreation extends EntryCreation {
  abstract predicate isOverpermissive();
}

abstract class UnsecurableEntryCreation extends EvaluableEntryCreation {
  override predicate isOverpermissive() { any() }
}

abstract class ModableEntryCreation extends EntryCreation {
  cached abstract Expr getArgument();
  cached abstract Expr getSpecifier();

  cached string getArgumentType() {
    result = this.getArgument().flow().analyze().getAType().getTypeofTag()
  }

  predicate hasArgument() { exists(this.getArgument()) }
  predicate hasElidedArgument() { not this.hasArgument() }

  predicate hasUndefinedArgument() {
    this.getArgument().analyze().getAValue() instanceof AbstractUndefined
  }

  predicate hasDefinedArgument() {
    this.hasArgument() and not this.hasUndefinedArgument()
  }

  predicate hasSpecifier() { exists(this.getSpecifier()) }
  predicate hasElidedSpecifier() { not this.hasSpecifier() }

  predicate hasUndefinedSpecifier() {
    this.getSpecifier().analyze().getAValue() instanceof AbstractUndefined
  }

  predicate hasDefinedSpecifier() {
    this.hasSpecifier() and not this.hasUndefinedSpecifier()
  }

  predicate isModeless() {
    this.hasElidedArgument() or
    this.hasUndefinedArgument() or
    this.hasElidedSpecifier() or
    this.hasUndefinedSpecifier()
  }

  predicate isModal() {
    this.hasDefinedArgument() and
    this.hasDefinedSpecifier()
  }
}

abstract class Argument1EntryCreation extends ModableEntryCreation {
  override Expr getArgument() { result = this.getArgument(1).asExpr() }
}

abstract class Argument2EntryCreation extends ModableEntryCreation {
  override Expr getArgument() { result = this.getArgument(2).asExpr() }
}

abstract class ImmediateSpecifierEntryCreation extends ModableEntryCreation {
  override Expr getSpecifier() {
    this.hasModeArgument() and result = this.getArgument()
  }

  private predicate hasModeArgument() {
    this.getArgumentType() = "number" or
    this.getArgumentType() = "string"
  }
}

abstract class PropertySpecifierEntryCreation extends ModableEntryCreation {
  override Expr getSpecifier() {
    this.getArgumentType() = "object" and
    result = this.getArgument().(ObjectExpr).getPropertyByName("mode").getInit()
  }
}

abstract class ImmediateOrPropertySpecifierEntryCreation extends
  ModableEntryCreation
{
  override Expr getSpecifier() {
    (this.hasModeArgument() and result = this.getImmediateSpecifier()) or
    (this.hasObjectArgument() and result = this.getPropertySpecifier())
  }

  private predicate hasModeArgument() {
    this.getArgumentType() = "number" or
    this.getArgumentType() = "string"
  }

  private predicate hasObjectArgument() { this.getArgumentType() = "object" }
  private Expr getImmediateSpecifier() { result = this.getArgument() }

  private Expr getPropertySpecifier() {
    result = this.getArgument().(ObjectExpr).getPropertyByName("mode").getInit()
  }
}

abstract class LiteralEntryCreation extends
  ModableEntryCreation,
  EvaluableEntryCreation
{
  LiteralEntryCreation() { this.getSpecifier() instanceof LiteralSpecifier }

  abstract Mask getMask();

  override predicate isOverpermissive() {
    specifierOverpermissive(this.getSpecifier(), this.getMask())
  }
}

abstract class FileCreation extends EntryCreation {}
abstract class DirectoryCreation extends EntryCreation {}

abstract class OverpermissiveIncludedEntryCreation extends
  TaintTracking::Configuration
{
  OverpermissiveIncludedEntryCreation() {
    this = "OverpermissiveIncludedEntryCreation"
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor
  ) {
    exists(InclusiveDisjunction disjunction |
      predecessor.asExpr() = disjunction.getAFactor() and
      successor.asExpr() = disjunction
    )
  }
}

abstract class EntryModeFromLiteral extends DataFlow::Configuration {
  EntryModeFromLiteral() { this = "EntryModeFromLiteral" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof NumberLiteral and
    node.asExpr().(NumberLiteral).getFloatValue().ceil() >= 511 // >= 0o777
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor
  ) {
    exists(ClearBitExpr clear |
      predecessor.asExpr() = clear.getAFactor() and
      successor.asExpr() = clear
    )
  }
}

abstract class EntryCreationCorruption extends DataFlow::Configuration {
  EntryCreationCorruption() { this = "EntryCreationCorruption" }

  override predicate isSource(DataFlow::Node node) { any() }
}

abstract class IncludedEntryCreationCorruption extends
  EntryCreationCorruption
{
  IncludedEntryCreationCorruption() { this = "EntryCreationCorruption" }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor,
    DataFlow::FlowLabel predLabel,
    DataFlow::FlowLabel succLabel
  ) {
    exists(ModifyExpr modification |
      predecessor.asExpr() = modification.getAFactor() and
      successor.asExpr() = modification and (
        (predLabel instanceof CorruptLabel and succLabel instanceof CorruptLabel) or
        (not modification instanceof InclusiveDisjunction and succLabel instanceof CorruptLabel) or
        not succLabel instanceof CorruptLabel
      )
    )
  }
}

abstract class ExcludedEntryCreationCorruption extends
  EntryCreationCorruption
{
  ExcludedEntryCreationCorruption() { this = "EntryCreationCorruption" }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor,
    DataFlow::FlowLabel predLabel,
    DataFlow::FlowLabel succLabel
  ) {
    exists(ModifyExpr modification |
      predecessor.asExpr() = modification.getAFactor() and
      successor.asExpr() = modification and (
        (predLabel instanceof CorruptLabel and succLabel instanceof CorruptLabel) or
        (modification instanceof ExclusionCorruptingExpr and succLabel instanceof CorruptLabel) or
        not succLabel instanceof CorruptLabel
      )
    )
  }
}

class WorldWriteExcludedEntryCreation extends DataFlow::Configuration
{
  WorldWriteExcludedEntryCreation() {
    this = "WorldWriteExcludedEntryCreation"
  }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = this.getOverpermissiveConstants()
  }

  private string getOverpermissiveConstants() {
    result = "S_IWOTH" or
    result = "S_IRWXO"
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor
  ) {
    exists(ClearBitExpr clear |
      predecessor.asExpr() = clear.getAFactor() and
      successor.asExpr() = clear
    )
  }
}

class WorldExecuteExcludedEntryCreation extends DataFlow::Configuration
{
  WorldExecuteExcludedEntryCreation() {
    this = "WorldExecuteExcludedEntryCreation"
  }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = this.getOverpermissiveConstants()
  }

  private string getOverpermissiveConstants() {
    result = "S_IXOTH" or
    result = "S_IRWXO"
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor
  ) {
    exists(ClearBitExpr clear |
      predecessor.asExpr() = clear.getAFactor() and
      successor.asExpr() = clear
    )
  }
}
