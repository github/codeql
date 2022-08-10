private import SsaImplCommon as Ssa
private import semmle.code.cpp.ir.IR
private import DataFlowUtil
private import DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.cpp.models.interfaces.Allocation as Alloc
private import semmle.code.cpp.models.interfaces.DataFlow as DataFlow
private import semmle.code.cpp.ir.internal.IRCppLanguage
private import DataFlowPrivate
private import ssa0.SsaImplCommon as SsaImplCommon0
private import ssa0.SsaInternals as SsaInternals0
import semmle.code.cpp.ir.dataflow.internal.SsaInternalsCommon

private module SourceVariables {
  int getMaxIndirectionForIRVariable(IRVariable var) {
    exists(Type type, boolean isGLValue |
      var.getLanguageType().hasType(type, isGLValue) and
      if isGLValue = true
      then result = 1 + getMaxIndirectionsForType(type)
      else result = getMaxIndirectionsForType(type)
    )
  }

  class BaseSourceVariable = SsaInternals0::BaseSourceVariable;

  class BaseIRVariable = SsaInternals0::BaseIRVariable;

  class BaseCallVariable = SsaInternals0::BaseCallVariable;

  cached
  private newtype TSourceVariable =
    TSourceIRVariable(BaseIRVariable baseVar, int ind) {
      ind = [0 .. getMaxIndirectionForIRVariable(baseVar.getIRVariable())]
    } or
    TCallVariable(CallInstruction call, int ind) {
      ind = [0 .. countIndirectionsForCppType(getResultLanguageType(call))]
    }

  abstract class SourceVariable extends TSourceVariable {
    int ind;

    bindingset[ind]
    SourceVariable() { any() }

    abstract string toString();

    int getIndirection() { result = ind }

    abstract BaseSourceVariable getBaseVariable();
  }

  class SourceIRVariable extends SourceVariable, TSourceIRVariable {
    BaseIRVariable var;

    SourceIRVariable() { this = TSourceIRVariable(var, ind) }

    IRVariable getIRVariable() { result = var.getIRVariable() }

    override BaseIRVariable getBaseVariable() { result.getIRVariable() = this.getIRVariable() }

    override string toString() {
      ind = 0 and
      result = this.getIRVariable().toString()
      or
      ind > 0 and
      result = this.getIRVariable().toString() + " indirection"
    }
  }

  class CallVariable extends SourceVariable, TCallVariable {
    CallInstruction call;

    CallVariable() { this = TCallVariable(call, ind) }

    CallInstruction getCall() { result = call }

    override BaseCallVariable getBaseVariable() { result.getCallInstruction() = call }

    override string toString() {
      ind = 0 and
      result = "Call"
      or
      ind > 0 and
      result = "Call indirection"
    }
  }
}

import SourceVariables

predicate hasIndirectOperand(Operand op, int index) {
  exists(CppType type, int m |
    not ignoreOperand(op) and
    type = getLanguageType(op) and
    m = countIndirectionsForCppType(type) and
    index = [1 .. m]
  )
}

predicate hasIndirectInstruction(Instruction instr, int index) {
  exists(CppType type, int m |
    not ignoreInstruction(instr) and
    type = getResultLanguageType(instr) and
    m = countIndirectionsForCppType(type) and
    index = [1 .. m]
  )
}

cached
private newtype TDefOrUseImpl =
  TNonCallDef(Operand address, int index) { isNonCallDef(_, _, address, _, _, index, _) } or
  TCallDef(Operand address, int index) { isCallDef(_, address, _, _, index, _) } or
  TUseImpl(Operand operand, int index) {
    isUse(_, operand, _, _, index) and
    not isNonCallDef(_, _, operand, _, _, _, _)
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

  abstract int getIndex();

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
    exists(BaseSourceVariable v, int ind |
      sourceVariableHasBaseAndIndex(result, v, ind) and
      defOrUseHasSourceVariable(this, v, ind)
    )
  }
}

pragma[noinline]
private predicate instructionHasIRVariable(VariableAddressInstruction vai, IRVariable var) {
  vai.getIRVariable() = var
}

private predicate defOrUseHasSourceVariable(DefOrUseImpl defOrUse, BaseSourceVariable bv, int ind) {
  defHasSourceVariable(defOrUse, bv, ind)
  or
  useHasSourceVariable(defOrUse, bv, ind)
}

pragma[noinline]
private predicate defHasSourceVariable(DefImpl def, BaseSourceVariable bv, int ind) {
  bv = def.getBaseSourceVariable() and
  ind = def.getIndirection()
}

pragma[noinline]
private predicate useHasSourceVariable(UseImpl use, BaseSourceVariable bv, int ind) {
  bv = use.getBaseSourceVariable() and
  ind = use.getIndirection()
}

pragma[noinline]
private predicate sourceVariableHasBaseAndIndex(SourceVariable v, BaseSourceVariable bv, int ind) {
  v.getBaseVariable() = bv and
  v.getIndirection() = ind
}

abstract class DefImpl extends DefOrUseImpl {
  abstract predicate isCertain();

  abstract int getIndirection();

  abstract Operand getAddressOperand();

  final Instruction getAddress() { result = this.getAddressOperand().getDef() }

  abstract Instruction getDefiningInstruction();

  abstract predicate addressDependsOnField();

  abstract DefImpl incrementIndexBy(int d);
}

class NonCallDef extends DefImpl, TNonCallDef {
  Operand address;
  int ind;

  NonCallDef() { this = TNonCallDef(address, ind) }

  override Instruction getBase() { isNonCallDef(_, _, address, result, _, _, _) }

  override Operand getAddressOperand() { result = address }

  override int getIndirection() { isNonCallDef(_, _, address, _, result, ind, _) }

  override int getIndex() { result = ind }

  override Instruction getDefiningInstruction() { isNonCallDef(_, result, address, _, _, _, _) }

  override string toString() { result = "NonCallDef" }

  override IRBlock getBlock() { result = this.getDefiningInstruction().getBlock() }

  override Cpp::Location getLocation() { result = this.getDefiningInstruction().getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getDefiningInstruction() = block.getInstruction(index)
  }

  override predicate isCertain() { isNonCallDef(true, _, address, _, _, ind, _) }

  override predicate addressDependsOnField() { isNonCallDef(_, _, address, _, _, ind, true) }

  override NonCallDef incrementIndexBy(int d) {
    result.getAddressOperand() = address and
    result.getIndex() = ind + d
  }
}

class CallDef extends DefImpl, TCallDef {
  Operand address;
  int ind;

  CallDef() { this = TCallDef(address, ind) }

  override int getIndex() { result = ind }

  override Instruction getBase() { isCallDef(_, address, result, _, _, _) }

  override Operand getAddressOperand() { result = address }

  override Instruction getDefiningInstruction() {
    exists(CallInstruction call | isCallDef(call, address, _, _, _, _) |
      instructionForfullyConvertedCall(result, call)
      or
      operandForfullyConvertedCall(any(Operand op | result = op.getDef()), call)
    )
  }

  override int getIndirection() { isCallDef(_, address, _, result, ind, _) }

  override string toString() { result = "CallDef" }

  override IRBlock getBlock() { result = this.getDefiningInstruction().getBlock() }

  override Cpp::Location getLocation() { result = address.getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getDefiningInstruction() = block.getInstruction(index)
  }

  override predicate isCertain() { none() }

  override predicate addressDependsOnField() { isCallDef(_, address, _, _, _, true) }

  override CallDef incrementIndexBy(int d) {
    result.getAddressOperand() = address and
    result.getIndex() = ind + d
  }
}

class UseImpl extends DefOrUseImpl, TUseImpl {
  Operand operand;
  int ind;

  UseImpl() { this = TUseImpl(operand, ind) }

  Operand getOperand() { result = operand }

  override string toString() { result = "UseImpl" }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    operand.getUse() = block.getInstruction(index)
  }

  final override IRBlock getBlock() { result = operand.getUse().getBlock() }

  final override Cpp::Location getLocation() { result = operand.getLocation() }

  final int getIndirection() { isUse(_, operand, _, result, ind) }

  override int getIndex() { result = ind }

  override Instruction getBase() { isUse(_, operand, result, _, ind) }
}

private predicate adjacentDefRead0(DefOrUse defOrUse1, SsaDefOrUse defOrUse2) {
  exists(IRBlock bb1, int i1, SourceVariable v |
    defOrUse1.asDefOrUse().hasIndexInBlock(bb1, i1, v)
  |
    exists(IRBlock bb2, int i2 |
      adjacentDefRead(_, pragma[only_bind_into](bb1), pragma[only_bind_into](i1),
        pragma[only_bind_into](bb2), pragma[only_bind_into](i2)) and
      defOrUse2.asDefOrUse().hasIndexInBlock(bb2, i2, v)
    )
    or
    exists(PhiNode phi, Ssa::Definition inp |
      inp.definesAt(v, bb1, i1) and
      phiHasInputFromBlock(phi, inp, _) and
      defOrUse2.asPhi() = phi
    )
  )
}

private predicate adjacentDefReadStep(Def def, SsaDefOrUse defOrUse) {
  adjacentDefRead0(def, defOrUse)
}

predicate adjacentDefRead(DefOrUse defOrUse1, UseOrPhi use) {
  exists(SsaDefOrUse mid | adjacentDefRead0(defOrUse1, mid) |
    adjacentDefReadStep+(mid, use) // implies `mid instanceof Def`
    or
    mid = use // implies `mid instanceof Use` or `mid instanceof Phi`
  )
}

private predicate useToNode(UseOrPhi use, Node nodeTo) {
  exists(UseImpl useImpl | useImpl = use.asDefOrUse() |
    useImpl.getIndex() = 0 and
    // TODO: Can we use nodeTo.asOperand here to avoid going "backwards"?
    nodeTo.asInstruction() = useImpl.getOperand().getDef()
    or
    exists(int index |
      index = useImpl.getIndex() and
      index > 0 and
      hasOperandAndIndex(nodeTo, useImpl.getOperand(), index)
    )
  )
  or
  nodeTo.(SsaPhiNode).getPhiNode() = use.asPhi()
}

private predicate nodeToNonCallDef(Node nodeFrom, NonCallDef def) {
  def.getIndex() = 0 and
  def.getDefiningInstruction() = nodeFrom.asInstruction()
  or
  // implies def.getIndex() > 0
  hasInstructionAndIndex(nodeFrom, def.getDefiningInstruction(), def.getIndex())
}

private predicate outNodeToCallDef(IndirectArgumentOutNode nodeFrom, CallDef def) {
  nodeFrom.getDef() = def
}

private predicate defToNode(Node nodeFrom, DefOrUse def) {
  defToNodeImpl(nodeFrom, def.asDefOrUse())
}

predicate defToNodeImpl(Node nodeFrom, DefOrUseImpl def) {
  nodeToNonCallDef(nodeFrom, def)
  or
  outNodeToCallDef(nodeFrom, def)
}

predicate nodeToDefOrUse(Node nodeFrom, SsaDefOrUse defOrUse) {
  // Node -> Def
  defToNode(nodeFrom, defOrUse)
  or
  // Node -> Use
  useToNode(defOrUse, nodeFrom)
}

predicate defUseFlow(Node nodeFrom, Node nodeTo) {
  exists(DefOrUse defOrUse1, UseOrPhi use |
    not defOrUse1.asDefOrUse().(DefImpl).addressDependsOnField() and
    nodeToDefOrUse(nodeFrom, defOrUse1) and
    adjacentDefRead(defOrUse1, use) and
    useToNode(use, nodeTo)
  )
}

predicate postNodeDefUseFlow(PostFieldUpdateNode pfun, Node nodeTo) {
  exists(DefImpl defImpl, Def def, UseOrPhi use |
    not isQualifierFor(any(FieldAddress fa), pfun.getFieldAddress()) and
    defImpl = pfun.getDef() and
    def.asDefOrUse() = defImpl and
    adjacentDefRead(def, use) and
    useToNode(use, nodeTo)
  )
}

predicate fromPhiNode(SsaPhiNode nodeFrom, Node nodeTo) {
  exists(UseOrPhi use, IRBlock bb2, int i2, PhiNode phi, SourceVariable v |
    use.asDefOrUse().hasIndexInBlock(bb2, i2, v) and
    phi = nodeFrom.getPhiNode() and
    phi.getSourceVariable() = v and
    adjacentDefRead(phi, _, -1, bb2, i2) and
    useToNode(use, nodeTo)
  )
  or
  exists(PhiNode phiFrom, PhiNode phiTo |
    nodeFrom.getPhiNode() = phiFrom and
    phiHasInputFromBlock(phiTo, phiFrom, _) and
    nodeTo.(SsaPhiNode).getPhiNode() = phiTo
  )
}

SsaInternals0::SourceVariable getOldSourceVariable(SourceVariable v) {
  v.getBaseVariable().(BaseIRVariable).getIRVariable() =
    result.getBaseVariable().(SsaInternals0::BaseIRVariable).getIRVariable()
  or
  v.getBaseVariable().(BaseCallVariable).getCallInstruction() =
    result.getBaseVariable().(SsaInternals0::BaseCallVariable).getCallInstruction()
}

predicate variableWriteCand(IRBlock bb, int i, SourceVariable v) {
  exists(SsaInternals0::Def def, SsaInternals0::SourceVariable v0 |
    def.asDefOrUse().hasIndexInBlock(bb, i, v0) and
    v0 = getOldSourceVariable(v)
  )
}

/**
 * Holds if the `i`'th write in block `bb` writes to the variable `v`.
 * `certain` is `true` if the write is guaranteed to overwrite the entire variable.
 */
predicate variableWrite(IRBlock bb, int i, SourceVariable v, boolean certain) {
  DataFlowImplCommon::forceCachingInSameStage() and
  variableWriteCand(bb, i, v) and
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

cached
module SsaCached {
  cached
  predicate phiHasInputFromBlock(PhiNode phi, Definition inp, IRBlock bb) {
    Ssa::phiHasInputFromBlock(phi, inp, bb)
  }

  cached
  predicate adjacentDefRead(Definition def, IRBlock bb1, int i1, IRBlock bb2, int i2) {
    Ssa::adjacentDefRead(def, bb1, i1, bb2, i2)
  }
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
}

class Def extends DefOrUse {
  override DefImpl defOrUse;

  Operand getAddressOperand() { result = defOrUse.getAddressOperand() }

  Instruction getAddress() { result = defOrUse.getAddress() }

  pragma[inline]
  int getIndex() { pragma[only_bind_into](result) = pragma[only_bind_out](defOrUse).getIndex() }

  predicate addressDependsOnField() { defOrUse.addressDependsOnField() }

  Instruction getDefiningInstruction() { result = defOrUse.getDefiningInstruction() }
}

import SsaCached

class PhiNode = Ssa::PhiNode;

class Definition = Ssa::Definition;
