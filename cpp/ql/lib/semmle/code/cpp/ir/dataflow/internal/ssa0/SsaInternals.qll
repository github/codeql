private import SsaImplCommon as Ssa
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.models.interfaces.Allocation as Alloc
private import semmle.code.cpp.models.interfaces.DataFlow as DataFlow
private import semmle.code.cpp.ir.implementation.raw.internal.SideEffects as SideEffects
private import semmle.code.cpp.ir.internal.IRCppLanguage
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.SsaInternalsCommon

private module SourceVariables {
  newtype TBaseSourceVariable =
    TBaseIRVariable(IRVariable var) or
    TBaseCallVariable(CallInstruction call)

  abstract class BaseSourceVariable extends TBaseSourceVariable {
    abstract string toString();
  }

  class BaseIRVariable extends BaseSourceVariable, TBaseIRVariable {
    IRVariable var;

    IRVariable getIRVariable() { result = var }

    BaseIRVariable() { this = TBaseIRVariable(var) }

    override string toString() { result = var.toString() }
  }

  class BaseCallVariable extends BaseSourceVariable, TBaseCallVariable {
    CallInstruction call;

    BaseCallVariable() { this = TBaseCallVariable(call) }

    CallInstruction getCallInstruction() { result = call }

    override string toString() { result = call.toString() }
  }

  private newtype TSourceVariable =
    TSourceIRVariable(BaseIRVariable baseVar) or
    TCallVariable(CallInstruction call)

  abstract class SourceVariable extends TSourceVariable {
    abstract string toString();

    abstract BaseSourceVariable getBaseVariable();
  }

  class SourceIRVariable extends SourceVariable, TSourceIRVariable {
    BaseIRVariable var;

    SourceIRVariable() { this = TSourceIRVariable(var) }

    IRVariable getIRVariable() { result = var.getIRVariable() }

    override BaseIRVariable getBaseVariable() { result.getIRVariable() = this.getIRVariable() }

    override string toString() { result = this.getIRVariable().toString() }
  }

  class CallVariable extends SourceVariable, TCallVariable {
    CallInstruction call;

    CallVariable() { this = TCallVariable(call) }

    CallInstruction getCall() { result = call }

    override BaseCallVariable getBaseVariable() { result.getCallInstruction() = call }

    override string toString() { result = "Call" }
  }
}

import SourceVariables

private newtype TDefOrUseImpl =
  TNonCallDef(Operand address) { isNonCallDef(_, _, address, _, _) } or
  TCallDef(Operand address) { isCallDef(_, address, _, _) } or
  TUseImpl(Operand operand) {
    isUse(_, operand, _) and
    not isNonCallDef(_, _, operand, _, _)
  }

abstract private class DefOrUseImpl extends TDefOrUseImpl {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the block of this definition or use. */
  abstract IRBlock getBlock();

  /** Holds if this definition or use has index `index` in block `block`. */
  abstract predicate hasIndexInBlock(IRBlock block, int index);

  final predicate hasIndexInBlock(IRBlock block, int index, SourceVariable sv) {
    this.hasIndexInBlock(block, index) and
    sv = this.getSourceVariable()
  }

  /** Gets the location of this element. */
  abstract Cpp::Location getLocation();

  abstract Instruction getBase();

  final BaseSourceVariable getBaseSourceVariable() {
    exists(IRVariable var |
      result.(BaseIRVariable).getIRVariable() = var and
      instructionHasIRVariable(this.getBase(), var)
    )
    or
    result.(BaseCallVariable).getCallInstruction() = this.getBase()
  }

  /** Gets the variable that is defined or used. */
  final SourceVariable getSourceVariable() {
    exists(BaseSourceVariable v |
      sourceVariableHasBaseAndIndex(result, v) and
      defOrUseHasSourceVariable(this, v)
    )
  }
}

pragma[noinline]
private predicate instructionHasIRVariable(VariableAddressInstruction vai, IRVariable var) {
  vai.getIRVariable() = var
}

private predicate defOrUseHasSourceVariable(DefOrUseImpl defOrUse, BaseSourceVariable bv) {
  defHasSourceVariable(defOrUse, bv)
  or
  useHasSourceVariable(defOrUse, bv)
}

pragma[noinline]
private predicate defHasSourceVariable(DefImpl def, BaseSourceVariable bv) {
  bv = def.getBaseSourceVariable()
}

pragma[noinline]
private predicate useHasSourceVariable(UseImpl use, BaseSourceVariable bv) {
  bv = use.getBaseSourceVariable()
}

pragma[noinline]
private predicate sourceVariableHasBaseAndIndex(SourceVariable v, BaseSourceVariable bv) {
  v.getBaseVariable() = bv
}

abstract class DefImpl extends DefOrUseImpl {
  abstract predicate isCertain();

  abstract Operand getAddressOperand();

  final Instruction getAddress() { result = this.getAddressOperand().getDef() }

  abstract Instruction getDefiningInstruction();

  abstract predicate addressDependsOnField();
}

class NonCallDef extends DefImpl, TNonCallDef {
  Operand address;

  NonCallDef() { this = TNonCallDef(address) }

  override Instruction getBase() { isNonCallDef(_, _, address, result, _) }

  override Operand getAddressOperand() { result = address }

  override Instruction getDefiningInstruction() { isNonCallDef(_, result, address, _, _) }

  override string toString() { result = address.toString() }

  override IRBlock getBlock() { result = this.getDefiningInstruction().getBlock() }

  override Cpp::Location getLocation() { result = this.getDefiningInstruction().getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getDefiningInstruction() = block.getInstruction(index)
  }

  override predicate isCertain() { isNonCallDef(true, _, address, _, _) }

  override predicate addressDependsOnField() { isNonCallDef(_, _, address, _, true) }
}

class CallDef extends DefImpl, TCallDef {
  Operand address;

  CallDef() { this = TCallDef(address) }

  override Instruction getBase() { isCallDef(_, address, result, _) }

  override Operand getAddressOperand() { result = address }

  override Instruction getDefiningInstruction() {
    exists(CallInstruction call | isCallDef(call, address, _, _) |
      instructionForfullyConvertedCall(result, call)
      or
      operandForfullyConvertedCall(any(Operand op | result = op.getDef()), call)
    )
  }

  override string toString() { result = address.toString() }

  override IRBlock getBlock() { result = this.getDefiningInstruction().getBlock() }

  override Cpp::Location getLocation() { result = address.getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getDefiningInstruction() = block.getInstruction(index)
  }

  override predicate isCertain() { none() }

  override predicate addressDependsOnField() { isCallDef(_, address, _, true) }
}

private module DefCached {
  predicate isCallDef(
    CallInstruction call, Operand address, Instruction base, boolean addressDependsOnField
  ) {
    exists(CppType addressType, int argumentIndex |
      if argumentIndex = -1
      then not call.getStaticCallTarget() instanceof Cpp::ConstMemberFunction
      else not SideEffects::isConstPointerLike(any(Type t | addressType.hasType(t, _)))
    |
      addressType = getLanguageType(address) and
      address = call.getArgumentOperand(argumentIndex) and
      isDefImpl(address, base, addressDependsOnField, _)
    )
  }

  predicate isNonCallDef(
    boolean certain, Instruction instr, Operand address, Instruction base,
    boolean addressDependsOnField
  ) {
    address =
      [
        instr.(StoreInstruction).getDestinationAddressOperand(),
        instr.(InitializeParameterInstruction).getAnOperand(),
        instr.(InitializeDynamicAllocationInstruction).getAllocationAddressOperand()
      ] and
    isDefImpl(address, base, addressDependsOnField, certain)
  }

  private predicate isPointerOrField(Instruction instr) {
    instr instanceof PointerArithmeticInstruction
    or
    instr instanceof FieldAddressInstruction
  }

  private predicate isDefImpl(
    Operand address, Instruction base, boolean addressDependsOnField, boolean certain
  ) {
    address.getDef() = base and
    isSourceVariableBase(base) and
    addressDependsOnField = false and
    certain = true
    or
    exists(Operand mid, boolean isField0, boolean isField1, boolean certain0 |
      isDefImpl(mid, base, isField0, certain0) and
      conversionFlow(mid, address, isField1, _) and
      addressDependsOnField = isField0.booleanOr(isField1) and
      if isPointerOrField(address.getDef()) then certain = false else certain = certain0
    )
    or
    isDefImpl(address.getDef().(LoadInstruction).getSourceAddressOperand(), base,
      addressDependsOnField, certain)
    or
    isDefImpl(address.getDef().(InitializeParameterInstruction).getAnOperand(), base,
      addressDependsOnField, certain)
  }
}

private import DefCached

class UseImpl extends DefOrUseImpl, TUseImpl {
  Operand operand;

  UseImpl() { this = TUseImpl(operand) }

  Operand getOperand() { result = operand }

  override string toString() { result = operand.toString() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    operand.getUse() = block.getInstruction(index)
  }

  final override IRBlock getBlock() { result = operand.getUse().getBlock() }

  final override Cpp::Location getLocation() { result = operand.getLocation() }

  override Instruction getBase() { isUse(_, operand, result) }
}

private module UseCached {
  predicate isUse(boolean certain, Operand op, Instruction base) {
    not ignoreOperand(op) and
    certain = true and
    isUseImpl(op, base)
  }

  private predicate isUseImpl(Operand operand, Instruction base) {
    operand.getDef() = base and
    isSourceVariableBase(base)
    or
    exists(Operand mid |
      isUseImpl(mid, base) and
      conversionFlowStepExcludeFields(mid, operand, false)
    )
    or
    isUseImpl(operand.getDef().(LoadInstruction).getSourceAddressOperand(), base)
    or
    isUseImpl(operand.getDef().(InitializeParameterInstruction).getAnOperand(), base)
  }
}

private import UseCached

private predicate isSourceVariableBase(Instruction i) {
  i instanceof VariableAddressInstruction or i instanceof CallInstruction
}

/**
 * Holds if the `i`'th write in block `bb` writes to the variable `v`.
 * `certain` is `true` if the write is guaranteed to overwrite the entire variable.
 */
predicate variableWrite(IRBlock bb, int i, SourceVariable v, boolean certain) {
  exists(DefImpl def |
    def.hasIndexInBlock(bb, i, v) and
    (if def.isCertain() then certain = true else certain = false)
  )
}

/**
 * Holds if the `i`'th read in block `bb` reads to the variable `v`.
 * `certain` is `true` if the read is guaranteed. For C++, this is always the case.
 */
predicate variableRead(IRBlock bb, int i, SourceVariable v, boolean certain) {
  exists(UseImpl use |
    use.hasIndexInBlock(bb, i, v) and
    certain = true
  )
  or
  exists(DefImpl def |
    def.hasIndexInBlock(bb, i, v) and
    not def.isCertain() and
    certain = false
  )
}

private newtype TSsaDefOrUse =
  TDefOrUse(DefOrUseImpl defOrUse) {
    defOrUse instanceof UseImpl
    or
    exists(Definition def, SourceVariable sv, IRBlock bb, int i |
      def.definesAt(sv, bb, i) and
      defOrUse.(DefImpl).hasIndexInBlock(bb, i, sv)
    )
  } or
  TPhi(PhiNode phi)

abstract private class SsaDefOrUse extends TSsaDefOrUse {
  string toString() { result = "SsaDefOrUse" }

  DefOrUseImpl asDefOrUse() { none() }

  PhiNode asPhi() { none() }

  abstract Location getLocation();
}

class DefOrUse extends TDefOrUse, SsaDefOrUse {
  DefOrUseImpl defOrUse;

  DefOrUse() { this = TDefOrUse(defOrUse) }

  final override DefOrUseImpl asDefOrUse() { result = defOrUse }

  final override Location getLocation() { result = defOrUse.getLocation() }

  final SourceVariable getSourceVariable() { result = defOrUse.getSourceVariable() }
}

class Phi extends TPhi, SsaDefOrUse {
  PhiNode phi;

  Phi() { this = TPhi(phi) }

  final override PhiNode asPhi() { result = phi }

  final override Location getLocation() { result = phi.getBasicBlock().getLocation() }
}

class UseOrPhi extends SsaDefOrUse {
  UseOrPhi() {
    this.asDefOrUse() instanceof UseImpl
    or
    this instanceof Phi
  }

  final override Location getLocation() {
    result = this.asDefOrUse().getLocation() or result = this.(Phi).getLocation()
  }

  override string toString() {
    result = this.asDefOrUse().toString()
    or
    this instanceof Phi and
    result = "Phi"
  }
}

class Def extends DefOrUse {
  override DefImpl defOrUse;

  Operand getAddressOperand() { result = defOrUse.getAddressOperand() }

  Instruction getAddress() { result = defOrUse.getAddress() }

  predicate addressDependsOnField() { defOrUse.addressDependsOnField() }

  Instruction getDefiningInstruction() { result = defOrUse.getDefiningInstruction() }

  override string toString() { result = this.asDefOrUse().toString() + " (def)" }
}

class PhiNode = Ssa::PhiNode;

class Definition = Ssa::Definition;
