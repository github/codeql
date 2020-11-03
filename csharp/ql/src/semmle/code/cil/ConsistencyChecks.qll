/**
 * Provides checks for the consistency of the data model and database.
 */

private import CIL
private import csharp as CS

private newtype ConsistencyCheck =
  MissingEntityCheck() or
  TypeCheck(Type t) or
  CfgCheck(ControlFlowNode n) or
  DeclarationCheck(Declaration d) or
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
abstract class DisabledCheck extends ConsistencyViolation {
  DisabledCheck() { none() }
}

/**
 * A consistency violation on a control flow node.
 */
abstract class CfgViolation extends ConsistencyViolation, CfgCheck {
  ControlFlowNode node;

  CfgViolation() { this = CfgCheck(node) }

  override string toString() { result = node.toString() }
}

/**
 * A consistency violation in a specific instruction.
 */
abstract class InstructionViolation extends CfgViolation, CfgCheck {
  Instruction instruction;

  InstructionViolation() { this = CfgCheck(instruction) }

  private string getInstructionsUpTo() {
    result =
      concat(Instruction i |
        i.getIndex() <= instruction.getIndex() and
        i.getImplementation() = instruction.getImplementation()
      |
        i.toString() + " [push: " + i.getPushCount() + ", pop: " + i.getPopCount() + "]", "; "
        order by
          i.getIndex()
      )
  }

  override string toString() {
    result =
      instruction.getImplementation().getMethod().toStringWithTypes() + ": " +
        instruction.toString() + ", " + getInstructionsUpTo()
  }
}

/**
 * A literal that does not have exactly one `getValue()`.
 */
class MissingValue extends InstructionViolation {
  MissingValue() { exists(Literal l | l = instruction | count(l.getValue()) != 1) }

  override string getMessage() { result = "Literal has invalid getValue()" }
}

/**
 * A call that does not have exactly one `getTarget()`.
 */
class MissingCallTarget extends InstructionViolation {
  MissingCallTarget() { exists(Call c | c = instruction | count(c.getTarget()) != 1) }

  override string getMessage() { result = "Call has invalid target" }
}

/**
 * An instruction that has not been assigned a specific QL class.
 */
class MissingOpCode extends InstructionViolation {
  MissingOpCode() { not exists(instruction.getOpcodeName()) }

  override string getMessage() {
    result = "Opcode " + instruction.getOpcode() + " is missing a QL class"
  }

  override string toString() {
    result = "Unknown instruction in " + instruction.getImplementation().getMethod().toString()
  }
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
    exists(int op | op in [0 .. instruction.getPopCount() - 1] |
      not exists(instruction.getOperand(op)) and not instruction instanceof DeadInstruction
    )
  }

  int getMissingOperand() {
    result in [0 .. instruction.getPopCount() - 1] and
    not exists(instruction.getOperand(result))
  }

  override string getMessage() {
    result = "This instruction is missing operand " + getMissingOperand()
  }
}

/**
 * A dead instruction, not reachable from any entry point.
 * These should not exist, however it turns out that the Mono compiler sometimes
 * emits them.
 */
class DeadInstruction extends Instruction {
  DeadInstruction() { not exists(EntryPoint e | e.getASuccessor+() = this) }
}

/**
 * An instruction that is not reachable from any entry point.
 *
 * If this fails, it means that the calculation of the call graph is incorrect.
 * Disabled, because Mono compiler sometimes emits dead instructions.
 */
class DeadInstructionViolation extends InstructionViolation, DisabledCheck {
  DeadInstructionViolation() { instruction instanceof DeadInstruction }

  override string getMessage() { result = "This instruction is not reachable" }
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
    exists(YesNoBranch i | i = instruction | not count(i.getASuccessor()) in [1 .. 2])
  }

  override string getMessage() {
    result = "Conditional branch has " + count(instruction.getASuccessor()) + " successors"
  }
}

/**
 * An instruction that has a true/false successor but is not a branch.
 */
class OnlyYesNoBranchHasTrueFalseSuccessors extends InstructionViolation {
  OnlyYesNoBranchHasTrueFalseSuccessors() {
    (exists(instruction.getTrueSuccessor()) or exists(instruction.getFalseSuccessor())) and
    not instruction instanceof YesNoBranch
  }

  override string getMessage() { result = "This instruction has getTrue/FalseSuccessor()" }
}

/**
 * An unconditional branch instruction that has more than one successor.
 */
class UnconditionalBranchSuccessors extends InstructionViolation {
  UnconditionalBranchSuccessors() {
    exists(UnconditionalBranch i | i = instruction | count(i.getASuccessor()) != 1)
  }

  override string getMessage() {
    result = "Unconditional branch has " + count(instruction.getASuccessor()) + " successors"
  }
}

/**
 * A branch instruction that does not have a true successor.
 */
class NoTrueSuccessor extends InstructionViolation {
  NoTrueSuccessor() { exists(YesNoBranch i | i = instruction | not exists(i.getTrueSuccessor())) }

  override string getMessage() { result = "Missing a true successor" }
}

/**
 * A branch instruction that does not have a false successor.
 */
class NoFalseSuccessor extends InstructionViolation {
  NoFalseSuccessor() { exists(YesNoBranch i | i = instruction | not exists(i.getFalseSuccessor())) }

  override string getMessage() { result = "Missing a false successor" }
}

/**
 * An instruction whose true successor is not a successor.
 */
class TrueSuccessorIsSuccessor extends InstructionViolation {
  TrueSuccessorIsSuccessor() {
    exists(instruction.getTrueSuccessor()) and
    not instruction.getTrueSuccessor() = instruction.getASuccessor()
  }

  override string getMessage() { result = "True successor isn't a successor" }
}

/**
 * An instruction whose false successor is not a successor.
 */
class FalseSuccessorIsSuccessor extends InstructionViolation {
  FalseSuccessorIsSuccessor() {
    exists(instruction.getFalseSuccessor()) and
    not instruction.getFalseSuccessor() = instruction.getASuccessor()
  }

  override string getMessage() { result = "True successor isn't a successor" }
}

/**
 * An access that does not have exactly one target.
 */
class AccessMissingTarget extends InstructionViolation {
  AccessMissingTarget() { exists(Access i | i = instruction | count(i.getTarget()) != 1) }

  override string getMessage() { result = "Access has invalid getTarget()" }
}

/**
 * A catch handler that doesn't have a caught exception type.
 */
class CatchHandlerMissingType extends CfgViolation {
  CatchHandlerMissingType() { exists(CatchHandler h | h = node | not exists(h.getCaughtType())) }

  override string getMessage() { result = "Catch handler missing caught type" }
}

/**
 * A CFG node that does not have a stack size.
 */
class MissingStackSize extends CfgViolation {
  MissingStackSize() {
    (
      not exists(node.getStackSizeAfter()) or
      not exists(node.getStackSizeBefore())
    ) and
    not node instanceof DeadInstruction
  }

  override string getMessage() { result = "Inconsistent stack size" }
}

/**
 * A CFG node that does not have exactly one stack size.
 * Disabled because inconsistent stack sizes have been observed.
 */
class InvalidStackSize extends CfgViolation, DisabledCheck {
  InvalidStackSize() {
    (
      count(node.getStackSizeAfter()) != 1 or
      count(node.getStackSizeBefore()) != 1
    ) and
    not node instanceof DeadInstruction
  }

  override string getMessage() {
    result =
      "Inconsistent stack sizes " + count(node.getStackSizeBefore()) + " before and " +
        count(node.getStackSizeAfter()) + " after"
  }
}

/**
 * A CFG node that does not have exactly 1 `getPopCount()`.
 */
class InconsistentPopCount extends CfgViolation {
  InconsistentPopCount() { count(node.getPopCount()) != 1 }

  override string getMessage() {
    result = "Cfg node has " + count(node.getPopCount()) + " pop counts"
  }
}

/**
 * A CFG node that does not have exactly one `getPushCount()`.
 */
class InconsistentPushCount extends CfgViolation {
  InconsistentPushCount() { count(node.getPushCount()) != 1 }

  override string getMessage() {
    result = "Cfg node has " + count(node.getPushCount()) + " push counts"
  }
}

/**
 * A return instruction that does not have a stack size of 0 after it.
 */
class InvalidReturn extends InstructionViolation {
  InvalidReturn() { instruction instanceof Return and instruction.getStackSizeAfter() != 0 }

  override string getMessage() { result = "Return has invalid stack size" }
}

/**
 * A throw instruction that does not have a stack size of 0 after it.
 */
class InvalidThrow extends InstructionViolation, DisabledCheck {
  InvalidThrow() { instruction instanceof Throw and instruction.getStackSizeAfter() != 0 }

  override string getMessage() {
    result = "Throw has invalid stack size: " + instruction.getStackSizeAfter()
  }
}

/**
 * A field access where the field is "static" but the instruction is "instance".
 */
class StaticFieldTarget extends InstructionViolation {
  StaticFieldTarget() {
    exists(FieldAccess i | i = instruction |
      (i instanceof Opcodes::Stfld or i instanceof Opcodes::Stfld) and
      i.getTarget().isStatic()
    )
  }

  override string getMessage() { result = "Inconsistent static field" }
}

/**
 * A branch without a target.
 */
class BranchWithoutTarget extends InstructionViolation {
  BranchWithoutTarget() {
    instruction = any(Branch b | not exists(b.getTarget()) and not b instanceof Opcodes::Switch)
  }

  override string getMessage() { result = "Branch without target" }
}

/**
 * A consistency violation in a type.
 */
class TypeViolation extends ConsistencyViolation, TypeCheck {
  /** Gets the type containing the violation. */
  Type getType() { this = TypeCheck(result) }

  override string toString() { result = getType().toString() }

  abstract override string getMessage();
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
 * The location of a constructed generic type should be the same
 * as the location of its unbound generic type.
 */
class InconsistentTypeLocation extends TypeViolation {
  InconsistentTypeLocation() {
    this.getType().getLocation() != this.getType().getSourceDeclaration().getLocation()
  }

  override string getMessage() { result = "Inconsistent constructed type location" }
}

/**
 * A constructed type that does not match its unbound generic type.
 */
class TypeParameterMismatch extends TypeViolation {
  TypeParameterMismatch() {
    getType().(ConstructedGeneric).getNumberOfTypeArguments() !=
      getType().getUnboundType().(UnboundGeneric).getNumberOfTypeParameters()
  }

  override string getMessage() {
    result =
      "Constructed type (" + getType().toStringWithTypes() + ") has " +
        getType().(ConstructedGeneric).getNumberOfTypeArguments() +
        " type arguments and unbound type (" + getType().getUnboundType().toStringWithTypes() +
        ") has " + getType().getUnboundType().(UnboundGeneric).getNumberOfTypeParameters() +
        " type parameters"
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
 * The location of a constructed method should be equal to the
 * location of its unbound generic.
 */
class InconsistentMethodLocation extends MethodViolation {
  InconsistentMethodLocation() {
    this.getMethod().getLocation() != this.getMethod().getSourceDeclaration().getLocation()
  }

  override string getMessage() { result = "Inconsistent constructed method location" }
}

/**
 * A constructed method that does not match its unbound method.
 */
class ConstructedMethodTypeParams extends MethodViolation {
  ConstructedMethodTypeParams() {
    getMethod().(ConstructedGeneric).getNumberOfTypeArguments() !=
      getMethod().getSourceDeclaration().(UnboundGeneric).getNumberOfTypeParameters()
  }

  override string getMessage() {
    result =
      "The constructed method " + getMethod().toStringWithTypes() +
        " does not match unbound method " + getMethod().getSourceDeclaration().toStringWithTypes()
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
  MissingObjectViolation() {
    exists(this) and
    not exists(ObjectType o)
  }

  override string getMessage() { result = "Object missing" }
}

/**
 * An override that is invalid because the overridden method is not in a base class.
 */
class InvalidOverride extends MethodViolation {
  private Method base;

  InvalidOverride() {
    base = getMethod().getOverriddenMethod() and
    not getMethod().getDeclaringType().getABaseType+() = base.getDeclaringType() and
    base.getDeclaringType().isSourceDeclaration() // Bases classes of constructed types aren't extracted properly.
  }

  override string getMessage() {
    result =
      "Overridden method from " + base.getDeclaringType().getQualifiedName() +
        " is not in a base type"
  }
}

/**
 * A pointer type that does not have a pointee type.
 */
class InvalidPointerType extends TypeViolation {
  InvalidPointerType() { exists(PointerType p | p = getType() | count(p.getReferentType()) != 1) }

  override string getMessage() { result = "Invalid Pointertype.getPointeeType()" }
}

/**
 * An array with an invalid `getElementType`.
 */
class ArrayTypeMissingElement extends TypeViolation {
  ArrayTypeMissingElement() { exists(ArrayType t | t = getType() | count(t.getElementType()) != 1) }

  override string getMessage() { result = "Invalid ArrayType.getElementType()" }
}

/**
 * An array with an invalid `getRank`.
 */
class ArrayTypeInvalidRank extends TypeViolation {
  ArrayTypeInvalidRank() { exists(ArrayType t | t = getType() | not t.getRank() > 0) }

  override string getMessage() { result = "Invalid ArrayType.getRank()" }
}

/**
 * A type should have at most one kind, except for missing referenced types
 * where the interface/class is unknown.
 */
class KindViolation extends TypeViolation {
  KindViolation() {
    count(typeKind(this.getType())) != 1 and
    exists(this.getType().getLocation())
  }

  override string getMessage() {
    result = "Invalid kinds on type: " + concat(typeKind(this.getType()), " ")
  }
}

/**
 * The type of a kind must be consistent between a constructed generic and its
 * unbound generic.
 */
class InconsistentKind extends TypeViolation {
  InconsistentKind() { typeKind(this.getType()) != typeKind(this.getType().getSourceDeclaration()) }

  override string getMessage() { result = "Inconsistent type kind of source declaration" }
}

private string typeKind(Type t) {
  t instanceof Interface and result = "interface"
  or
  t instanceof Class and result = "class"
  or
  t instanceof TypeParameter and result = "type parameter"
  or
  t instanceof ArrayType and result = "array"
  or
  t instanceof PointerType and result = "pointer"
}

/**
 * A violation in a `Member`.
 */
abstract class DeclarationViolation extends ConsistencyViolation, DeclarationCheck {
  abstract override string getMessage();

  /** Gets the member containing the potential violation. */
  Declaration getDeclaration() { this = DeclarationCheck(result) }

  override string toString() { result = getDeclaration().toString() }
}

/**
 * Properties that have no accessors.
 */
class PropertyWithNoAccessors extends DeclarationViolation {
  PropertyWithNoAccessors() {
    exists(Property p | p = getDeclaration() | not exists(p.getAnAccessor()))
  }

  override string getMessage() { result = "Property has no accessors" }
}

/**
 * An expression that have an unexpected push count.
 */
class ExprPushCount extends InstructionViolation {
  ExprPushCount() {
    instruction instanceof Expr and
    not instruction instanceof Opcodes::Dup and
    if instruction instanceof Call
    then not instruction.getPushCount() in [0 .. 1]
    else instruction.(Expr).getPushCount() != 1
  }

  override string getMessage() {
    result = "Instruction has unexpected push count " + instruction.getPushCount()
  }
}

/**
 * An expression that does not have exactly one type.
 * Note that calls with no return have type `System.Void`.
 */
class ExprMissingType extends InstructionViolation {
  ExprMissingType() {
    // Don't have types for the following op codes:
    not instruction instanceof Opcodes::Ldftn and
    not instruction instanceof Opcodes::Localloc and
    not instruction instanceof Opcodes::Ldvirtftn and
    not instruction instanceof Opcodes::Arglist and
    not instruction instanceof Opcodes::Refanytype and
    instruction.getPushCount() = 1 and
    count(instruction.getType()) != 1
  }

  override string getMessage() { result = "Expression is missing getType()" }
}

/**
 * An instruction that has a push count of 0, yet is still used as an operand
 */
class InvalidExpressionViolation extends InstructionViolation {
  InvalidExpressionViolation() {
    instruction.getPushCount() = 0 and
    exists(Instruction expr | instruction = expr.getAnOperand())
  }

  override string getMessage() {
    result = "This instruction is used as an operand but pushes no values"
  }
}

/**
 * A type that has multiple entities with the same qualified name in `System`.
 * .NET Core does sometimes duplicate types, so this check is disabled.
 */
class TypeMultiplyDefined extends TypeViolation, DisabledCheck {
  TypeMultiplyDefined() {
    this.getType().getParent().getName() = "System" and
    not this.getType() instanceof ConstructedGeneric and
    not this.getType() instanceof ArrayType and
    this.getType().isPublic() and
    count(Type t |
      not t instanceof ConstructedGeneric and
      t.toStringWithTypes() = this.getType().toStringWithTypes()
    ) != 1
  }

  override string getMessage() {
    result =
      "This type (" + getType().toStringWithTypes() + ") has " +
        count(Type t |
          not t instanceof ConstructedGeneric and
          t.toStringWithTypes() = this.getType().toStringWithTypes()
        ) + " entities"
  }
}

/**
 * A C# declaration which is expected to have a corresponding CIL declaration, but for some reason does not.
 */
class MissingCilDeclaration extends ConsistencyViolation, MissingCSharpCheck {
  MissingCilDeclaration() {
    exists(CS::Declaration decl | this = MissingCSharpCheck(decl) |
      expectedCilDeclaration(decl) and
      not exists(Declaration d | decl = d.getCSharpDeclaration())
    )
  }

  CS::Declaration getDeclaration() { this = MissingCSharpCheck(result) }

  override string getMessage() {
    result =
      "Cannot locate CIL for " + getDeclaration().toStringWithTypes() + " of class " +
        getDeclaration().getAQlClass()
  }

  override string toString() { result = getDeclaration().toStringWithTypes() }
}

/**
 * Holds if the C# declaration is expected to have a CIl declaration.
 */
private predicate expectedCilDeclaration(CS::Declaration decl) {
  decl = decl.getSourceDeclaration() and
  not decl instanceof CS::ArrayType and
  decl.getALocation() instanceof CS::Assembly and
  not decl.(CS::Modifiable).isInternal() and
  not decl.(CS::Constructor).getNumberOfParameters() = 0 and // These are sometimes implicit
  not decl.(CS::Method).getReturnType() instanceof CS::UnknownType and
  not exists(CS::Parameter p | p = decl.(CS::Parameterizable).getAParameter() |
    not expectedCilDeclaration(p)
  ) and
  not decl instanceof CS::AnonymousClass and
  (decl instanceof CS::Parameter implies expectedCilDeclaration(decl.(CS::Parameter).getType())) and
  (decl instanceof CS::Parameter implies expectedCilDeclaration(decl.getParent())) and
  (decl instanceof CS::Member implies expectedCilDeclaration(decl.getParent())) and
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
      exists(name.indexOf(".")) and
      not name = ".ctor" and
      not name = ".cctor"
    )
  }

  override string getMessage() { result = "Invalid name " + getDeclaration().(Member).getName() }
}

class ConstructedSourceDeclarationMethod extends MethodViolation {
  Method method;

  ConstructedSourceDeclarationMethod() {
    method = getMethod() and
    method = method.getSourceDeclaration() and
    (
      method instanceof ConstructedGeneric or
      method.getDeclaringType() instanceof ConstructedGeneric
    )
  }

  override string getMessage() {
    result = "Source declaration " + method.toStringWithTypes() + " is constructed"
  }
}

/** A declaration with multiple labels. */
class DeclarationWithMultipleLabels extends DeclarationViolation {
  DeclarationWithMultipleLabels() {
    exists(Declaration d | this = DeclarationCheck(d) | strictcount(d.getLabel()) > 1)
  }

  override string getMessage() {
    result = "Multiple labels " + concat(getDeclaration().getLabel(), ", ")
  }
}

/** A declaration without a label. */
class DeclarationWithoutLabel extends DeclarationViolation {
  DeclarationWithoutLabel() {
    exists(Declaration d | this = DeclarationCheck(d) |
      d.isSourceDeclaration() and
      not d instanceof TypeParameter and
      not exists(d.getLabel()) and
      (d instanceof Callable or d instanceof Type)
    )
  }

  override string getMessage() { result = "No label" }
}
