/**
 * Provides checks for the consistency of the data model and database.
 */

private import CIL
private import csharp as CS

private newtype ConsistencyCheck =
  MissingEntityCheck()
  or
  TypeCheck(Type t)
  or
  CfgCheck(ControlFlowNode n)
  or
  DeclarationCheck(Declaration d)
  or
  MissingCSharpCheck(CS::Declaration d)

/**
 * A consistency violation in the database or data model.
 */
abstract class ConsistencyViolation extends ConsistencyCheck {
  abstract string toString();
  abstract string getMessage();
}

/**
 * A check that is deliberately disabled.
 */
abstract class DisabledCheck extends ConsistencyCheck {
  DisabledCheck() { none() }
  abstract string toString();
}

/**
 * A consistency violation on a control flow node.
 */
class CfgViolation extends ConsistencyViolation, CfgCheck {
  ControlFlowNode getNode() { this = CfgCheck(result) }
  override string toString() { result = getNode().toString() }
  override abstract string getMessage();
}

/**
 * A consistency violation in a specific instruction.
 */
class InstructionViolation extends CfgViolation, CfgCheck {
  InstructionViolation() { exists(Instruction i | this=CfgCheck(i)) }

  /** Gets the instruction containing the violation. */
  Instruction getInstruction() { this = CfgCheck(result) }

  private string getInstructionsUpTo() {
    result = concat(Instruction i |
      i.getIndex() <= this.getInstruction().getIndex() and
      i.getImplementation() = this.getInstruction().getImplementation() |
      i.toString() + " [push: " + i.getPushCount() + ", pop: " + i.getPopCount() + "]", "; " order by i.getIndex()
    )
  }

  override string toString() {
    result = getInstruction().getImplementation().getMethod().toStringWithTypes() + ": " + getInstruction().toString() + ", " + getInstructionsUpTo()
  }
  override abstract string getMessage();
}

/**
 * A literal that does not have exactly one `getValue()`.
 */
class MissingValue extends InstructionViolation {
  MissingValue() {
    exists(Literal l | l = this.getInstruction() | count(l.getValue()) != 1)
  }

  override string getMessage() { result = "Literal has invalid getValue()" }
}

/**
 * A call that does not have exactly one `getTarget()`.
 */
class MissingCallTarget extends InstructionViolation {
  MissingCallTarget() {
    exists(Call c | c = this.getInstruction() | count(c.getTarget())!=1)
  }

  override string getMessage() { result = "Call has invalid target" }
}


/**
 * An instruction that has not been assigned a specific QL class.
 */
class MissingOpCode extends InstructionViolation {
  MissingOpCode() { not exists(this.getInstruction().getOpcodeName()) }
  override string getMessage() { result = "Opcode " + this.getInstruction().getOpcode() + " is missing a QL class" }
  override string toString() { result = "Unknown instruction in " + getInstruction().getImplementation().getMethod().toString() }
}


/**
 * An instruction that is missing an operand. It means that there is no instruction which pushes
 * a value onto the stack for this instruction to pop.
 *
 * If this fails, it means that the `getPopCount`/`getPushCount`/control flow graph has failed.
 * It could also mean that the target of a call has failed and has not determined the
 * correct number of arguments.
 */
class MissingOperand extends InstructionViolation {
  MissingOperand() {
    exists(Instruction i, int op | i=getInstruction() and op in [0..i.getPopCount()-1] |
      not exists(i.getOperand(op)) and not i instanceof DeadInstruction)
  }

  int getMissingOperand() {
    result in [0..getInstruction().getPopCount()-1] and not exists(getInstruction().getOperand(result))
  }

  override string getMessage() { result = "This instruction is missing operand " + getMissingOperand() }
}

/**
 * A dead instruction, not reachable from any entry point.
 * These should not exist, however it turns out that the Mono compiler sometimes
 * emits them.
 */
class DeadInstruction extends Instruction
{
  DeadInstruction() {
    not exists(EntryPoint e | e.getASuccessor+() = this)
  }
}

/**
 * An instruction that is not reachable from any entry point.
 *
 * If this fails, it means that the calculation of the call graph is incorrect.
 * Disabled, because Mono compiler sometimes emits dead instructions.
 */
class DeadInstructionViolation extends InstructionViolation, DisabledCheck {
  DeadInstructionViolation() {
    getInstruction() instanceof DeadInstruction
  }

  override string getMessage() { result="This instruction is not reachable" }
  override string toString() { result = InstructionViolation.super.toString() }
}

class YesNoBranch extends ConditionalBranch {
  YesNoBranch() { not this instanceof Opcodes::Switch }
}

/**
 * A branch instruction that does not have exactly 2 successors.
 */
class InvalidBranchSuccessors extends InstructionViolation {
  InvalidBranchSuccessors() {
    // Mono compiler sometimes generates branches to the next instruction, which is just wrong.
    // However it is valid CIL.
    exists(YesNoBranch i | i = getInstruction() | not count(i.getASuccessor()) in [1..2])
  }

  override string getMessage() {
    result = "Conditional branch has " + count(this.getInstruction().getASuccessor()) + " successors"
  }
}

/**
 * An instruction that has a true/false successor but is not a branch.
 */
class OnlyYesNoBranchHasTrueFalseSuccessors extends InstructionViolation {
  OnlyYesNoBranchHasTrueFalseSuccessors() {
    exists(Instruction i | i = getInstruction() |
      (exists(i.getTrueSuccessor()) or exists(i.getFalseSuccessor())) and not i instanceof YesNoBranch
    )
  }

  override string getMessage() { result = "This instruction has getTrue/FalseSuccessor()" }
}

/**
 * An unconditional branch instruction that has more than one successor.
 */
class UnconditionalBranchSuccessors extends InstructionViolation {
  UnconditionalBranchSuccessors() {
    exists(UnconditionalBranch i | i = getInstruction() | count(i.getASuccessor()) != 1)
  }

  override string getMessage() { result = "Unconditional branch has " + count(getInstruction().getASuccessor()) + " successors" }
}

/**
 * A branch instruction that does not have a true successor.
 */
class NoTrueSuccessor extends InstructionViolation {
  NoTrueSuccessor() {
    exists(YesNoBranch i | i = getInstruction() | not exists(i.getTrueSuccessor()))
  }

  override string getMessage() { result = "Missing a true successor" }
}

/**
 * A branch instruction that does not have a false successor.
 */
class NoFalseSuccessor extends InstructionViolation {
  NoFalseSuccessor() {
    exists(YesNoBranch i | i = getInstruction() | not exists(i.getFalseSuccessor()))
  }
  override string getMessage() { result = "Missing a false successor" }
}

/**
 * An instruction whose true successor is not a successor.
 */
class TrueSuccessorIsSuccessor extends InstructionViolation {
  TrueSuccessorIsSuccessor() {
    exists(Instruction i | i = getInstruction() | exists(i.getTrueSuccessor()) and not i.getTrueSuccessor() = i.getASuccessor())
  }

  override string getMessage() { result = "True successor isn't a successor" }
}

/**
 * An instruction whose false successor is not a successor.
 */
class FalseSuccessorIsSuccessor extends InstructionViolation {
  FalseSuccessorIsSuccessor() {
    exists(Instruction i | i = getInstruction() | exists(i.getTrueSuccessor()) and not i.getTrueSuccessor() = i.getASuccessor())
  }

  override string getMessage() { result = "True successor isn't a successor" }
}

/**
 * An access that does not have exactly one target.
 */
class AccessMissingTarget extends InstructionViolation {
  AccessMissingTarget() {
    exists(Access i | i = getInstruction() | count(i.getTarget()) != 1)
  }

  override string getMessage() { result = "Access has invalid getTarget()" }
}

/**
 * A catch handler that doesn't have a caught exception type.
 */
class CatchHandlerMissingType extends CfgViolation {
  CatchHandlerMissingType() {
    exists(CatchHandler h | h = getNode() | not exists(h.getCaughtType()))
  }

  override string getMessage () { result = "Catch handler missing caught type" }
}

/**
 * A CFG node that does not have a stack size.
 */
class MissingStackSize extends CfgViolation {
  MissingStackSize() {
    exists(ControlFlowNode node | node=getNode() |
      not exists(node.getStackSizeAfter())
      or not exists(node.getStackSizeBefore())
    )
    and not getNode() instanceof DeadInstruction
  }

  override string getMessage() { result = "Inconsistent stack size" }
}


/**
 * A CFG node that does not have exactly one stack size.
 * Disabled because inconsistent stack sizes have been observed.
 */
class InvalidStackSize extends CfgViolation, DisabledCheck {
  InvalidStackSize() {
    exists(ControlFlowNode node | node=getNode() |
      count(node.getStackSizeAfter()) != 1
      or count(node.getStackSizeBefore()) != 1
    )
    and not getNode() instanceof DeadInstruction
  }

  override string getMessage() { result = "Inconsistent stack sizes " + count(getNode().getStackSizeBefore()) + " before and " + count(getNode().getStackSizeAfter()) + " after" }

  override string toString() { result = CfgViolation.super.toString() }
}

/**
 * A CFG node that does not have exactly 1 `getPopCount()`.
 */
class InconsistentPopCount extends CfgViolation {
  InconsistentPopCount() {
    exists(ControlFlowNode node | node = getNode() | count(node.getPopCount()) !=1 )
  }

  override string getMessage() { result = "Cfg node has " + count(getNode().getPopCount()) + " pop counts" }
}

/**
 * A CFG node that does not have exactly one `getPushCount()`.
 */
class InconsistentPushCount extends CfgViolation {
  InconsistentPushCount() {
    exists(ControlFlowNode node | node = getNode() | count(node.getPushCount()) != 1)
  }

  override string getMessage() { result = "Cfg node has " + count(getNode().getPushCount()) + " push counts" }
}

/**
 * A return instruction that does not have a stack size of 0 after it.
 */
class InvalidReturn extends CfgViolation {
  InvalidReturn() { getNode() instanceof Return and getNode().getStackSizeAfter()!=0 }
  override string getMessage() { result = "Return has invalid stack size" }
}

/**
 * A throw instruction that does not have a stack size of 0 after it.
 */
class InvalidThrow extends CfgViolation {
  InvalidThrow() { getNode() instanceof Throw and getNode().getStackSizeAfter()!=0 }
  override string getMessage() { result = "Throw has invalid stack size" }
}

/**
 * A field access where the field is "static" but the instruction is "instance".
 */
class StaticFieldTarget extends InstructionViolation {
  StaticFieldTarget() {
    exists(FieldAccess i | i=getInstruction() |
      (i instanceof Opcodes::Stfld or i instanceof Opcodes::Stfld) and i.getTarget().isStatic()
     )
  }

  override string getMessage() { result = "Inconsistent static field" }
}

/**
 * A branch without a target.
 */
class BranchWithoutTarget extends InstructionViolation {
  BranchWithoutTarget() {
    getInstruction() = any(Branch b | not exists(b.getTarget()) and not b instanceof Opcodes::Switch)
  }

  override string getMessage() { result = "Branch without target" }
}

/**
 * A consistency violation in a type.
 */
class TypeViolation extends ConsistencyViolation, TypeCheck {

  /** Gets the type containing the violation. */
  Type getType() { this=TypeCheck(result) }

  override string toString() { result = getType().toString() }
  override abstract string getMessage();
}

/**
 * A type that has both type arguments and type parameters.
 */
class TypeIsBothConstructedAndUnbound extends TypeViolation {
  TypeIsBothConstructedAndUnbound() {
    getType() instanceof ConstructedGeneric and getType() instanceof UnboundGeneric
  }

  override string getMessage() { result = "Type is both constructed and unbound" }
}

/**
 * A constructed type that does not match its unbound generic type.
 */
class TypeParameterMismatch extends TypeViolation {
  TypeParameterMismatch() {
    getType().(ConstructedGeneric).getNumberOfTypeArguments() != getType().getUnboundType().(UnboundGeneric).getNumberOfTypeParameters()
  }

  override string getMessage() {
    result = "Constructed type (" + getType().toStringWithTypes() + ") has " +
      getType().(ConstructedGeneric).getNumberOfTypeArguments() + " type arguments and unbound type (" +
      getType().getUnboundType().toStringWithTypes() + ") has " +
      getType().getUnboundType().(UnboundGeneric).getNumberOfTypeParameters() + " type parameters"
  }
}

/**
 * A consistency violation in a method.
 */
class MethodViolation extends ConsistencyViolation, DeclarationCheck {

  /** Gets the method containing the violation. */
  Method getMethod() { this = DeclarationCheck(result) }

  override string toString() { result = getMethod().toString() }
  override string getMessage() { none() }
}

/**
 * A constructed method that does not match its unbound method.
 */
class ConstructedMethodTypeParams extends MethodViolation {

  ConstructedMethodTypeParams() { getMethod().(ConstructedGeneric).getNumberOfTypeArguments() != getMethod().getSourceDeclaration().(UnboundGeneric).getNumberOfTypeParameters() }

  override string getMessage() {
    result = "The constructed method " + getMethod().toStringWithTypes() + " does not match unbound method " + getMethod().getSourceDeclaration().toStringWithTypes()
  }
}

/**
 * A violation marking an entity that should be present but is not.
 */
abstract class MissingEntityViolation extends ConsistencyViolation, MissingEntityCheck {
  override string toString() { result = "Missing entity" }
}

/**
 * The type `object` is missing from the database.
 */
class MissingObjectViolation extends MissingEntityViolation {
  MissingObjectViolation() { not exists(ObjectType o) }
  override string getMessage() { result = "Object missing" }
}

/**
 * An override that is invalid because the overridden method is not in a base class.
 */
class InvalidOverride extends MethodViolation {
  InvalidOverride() {
    exists(Method base | base = getMethod().getOverriddenMethod() |
      not getMethod().getDeclaringType().getABaseType+() = getMethod().getOverriddenMethod().getDeclaringType())
  }

  override string getMessage() { result = "Overridden method is not in a base type" }
}

/**
 * A pointer type that does not have a pointee type.
 */
class InvalidPointerType extends TypeViolation {
  InvalidPointerType() {
    exists(PointerType p | p = getType() | count(p.getReferentType()) != 1)
  }

  override string getMessage() { result = "Invalid Pointertype.getPointeeType()" }
}

/**
 * An array with an invalid `getElementType`.
 */
class ArrayTypeMissingElement extends TypeViolation {
  ArrayTypeMissingElement() {
    exists(ArrayType t | t = getType() | count(t.getElementType())!=1)
  }
  override string getMessage() { result = "Invalid ArrayType.getElementType()" }
}

/**
 * An array with an invalid `getRank`.
 */
class ArrayTypeInvalidRank extends TypeViolation {
  ArrayTypeInvalidRank() {
    exists(ArrayType t | t = getType() | not t.getRank() > 0)
  }
  override string getMessage() { result = "Invalid ArrayType.getRank()" }
}

/**
 * A violation in a `Member`.
 */
abstract class DeclarationViolation extends ConsistencyViolation, DeclarationCheck {
  override abstract string getMessage();

  /** Gets the member containing the potential violation. */
  Declaration getDeclaration() { this = DeclarationCheck(result) }

  override string toString() { result = getDeclaration().toString() }
}

/**
 * Properties that have no accessors.
 */
class PropertyWithNoAccessors extends DeclarationViolation {
  PropertyWithNoAccessors() {
    exists(Property p | p=getDeclaration() | not exists(p.getAnAccessor()))
  }

  override string getMessage() { result = "Property has no accessors" }
}

/**
 * An expression that have an unexpected push count.
 */
class ExprPushCount extends InstructionViolation {
  ExprPushCount() {
    this.getInstruction() instanceof Expr and
    not this.getInstruction() instanceof Opcodes::Dup and
    if
      this.getInstruction() instanceof Call
    then
      not this.getInstruction().getPushCount() in [0..1]
    else
      this.getInstruction().(Expr).getPushCount() != 1
  }

  override string getMessage() { result = "Instruction has unexpected push count " + this.getInstruction().getPushCount() }
}

/**
 * An expression that does not have exactly one type.
 * Note that calls with no return have type `System.Void`.
 */
class ExprMissingType extends InstructionViolation {
  ExprMissingType() {
    // Don't have types for the following op codes:
    not getInstruction() instanceof Opcodes::Ldftn
    and not getInstruction() instanceof Opcodes::Localloc
    and not getInstruction() instanceof Opcodes::Ldvirtftn
    and not getInstruction() instanceof Opcodes::Arglist
    and not getInstruction() instanceof Opcodes::Refanytype
    and this.getInstruction().getPushCount() = 1 and count(this.getInstruction().getType()) != 1
  }

  override string getMessage() { result = "Expression is missing getType()" }
}

/**
 * An instruction that has a push count of 0, yet is still used as an operand
 */
class InvalidExpressionViolation extends InstructionViolation {
  InvalidExpressionViolation() { getInstruction().getPushCount()=0 and exists(Instruction expr | getInstruction() = expr.getAnOperand()) }
  override string getMessage() { result = "This instruction is used as an operand but pushes no values" }
}

/**
 * A type that has multiple entities with the same qualified name in `System`.
 * .NET Core does sometimes duplicate types, so this check is disabled.
 */
class TypeMultiplyDefined extends TypeViolation, DisabledCheck {
  TypeMultiplyDefined() {
    this.getType().getParent().getName()="System"
    and
    not this.getType() instanceof ConstructedGeneric
    and
    not this.getType() instanceof ArrayType
    and
    this.getType().isPublic()
    and
    count(Type t | not t instanceof ConstructedGeneric and t.toStringWithTypes() = this.getType().toStringWithTypes()) != 1
  }

  override string getMessage() {
    result="This type (" + getType().toStringWithTypes() + ") has " +
    count(Type t | not t instanceof ConstructedGeneric and t.toStringWithTypes() = this.getType().toStringWithTypes()) +
    " entities"
  }

  override string toString() { result = TypeViolation.super.toString() }
}

/**
 * A C# declaration which is expected to have a corresponding CIL declaration, but for some reason does not.
 */
class MissingCilDeclaration extends ConsistencyViolation, MissingCSharpCheck {

  MissingCilDeclaration()
  {
    exists(CS::Declaration decl | this = MissingCSharpCheck(decl) |
      expectedCilDeclaration(decl)
      and not exists(Declaration d | decl = d.getCSharpDeclaration())
      )
  }

  CS::Declaration getDeclaration() { this=MissingCSharpCheck(result) }

  override string getMessage() { result = "Cannot locate CIL for " + getDeclaration().toStringWithTypes() + " of class " + getDeclaration().getAQlClass() }

  override string toString() { result = getDeclaration().toStringWithTypes() }
}

/**
 * Holds if the C# declaration is expected to have a CIl declaration.
 */
private predicate expectedCilDeclaration(CS::Declaration decl)
{
  decl=decl.getSourceDeclaration()
  and not decl instanceof CS::ArrayType
  and decl.getALocation() instanceof CS::Assembly
  and not decl.(CS::Modifiable).isInternal()
  and not decl.(CS::Constructor).getNumberOfParameters() = 0 // These are sometimes implicit
  and not decl.(CS::Method).getReturnType() instanceof CS::UnknownType
  and not exists(CS::Parameter p | p = decl.(CS::Parameterizable).getAParameter() | not expectedCilDeclaration(p))
  and not decl instanceof CS::AnonymousClass
  and (decl instanceof CS::Parameter implies expectedCilDeclaration(decl.(CS::Parameter).getType()))
  and (decl instanceof CS::Parameter implies expectedCilDeclaration(decl.getParent()))
  and (decl instanceof CS::Member implies expectedCilDeclaration(decl.getParent()))
  and
  (
    decl instanceof CS::Field
    or
    decl instanceof CS::Property
    or
    decl instanceof CS::ValueOrRefType
    or
    decl instanceof CS::Event
    or
    decl instanceof CS::Constructor
    or
    decl instanceof CS::Destructor
    or
    decl instanceof CS::Operator
    or
    decl instanceof CS::Method
    or
    decl instanceof CS::Parameter
  )
}

/** A member with an invalid name. */
class MemberWithInvalidName extends DeclarationViolation {
  MemberWithInvalidName() {
    exists(string name | name = getDeclaration().(Member).getName() |
      exists(name.indexOf("."))
      and not name = ".ctor"
      and not name = ".cctor"
      )
  }

  override string getMessage() { result = "Invalid name " + getDeclaration().(Member).getName() }
}

class ConstructedSourceDeclarationMethod extends MethodViolation {
  Method method;

  ConstructedSourceDeclarationMethod() {
    method = getMethod()
    and method = method.getSourceDeclaration()
    and (method instanceof ConstructedGeneric or method.getDeclaringType() instanceof ConstructedGeneric)
  }

  override string getMessage() { result= "Source declaration " + method.toStringWithTypes() + " is constructed" }
}

/** A declaration with multiple labels. */
class DeclarationWithMultipleLabels extends DeclarationViolation {
  DeclarationWithMultipleLabels() {
    exists(Declaration d |
      this = DeclarationCheck(d) |
      strictcount(d.getLabel()) > 1
    )
  }

  override string getMessage() { result = "Multiple labels " + concat(getDeclaration().getLabel(), ", ") }
}

/** A declaration without a label. */
class DeclarationWithoutLabel extends DeclarationViolation {
  DeclarationWithoutLabel() {
    exists(Declaration d |
      this = DeclarationCheck(d) |
      d.isSourceDeclaration() and
      not d instanceof TypeParameter and
      not exists(d.getLabel()) and
      (d instanceof Callable or d instanceof Type)
    )
  }

  override string getMessage() { result = "No label" }
}
