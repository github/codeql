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
    TCallVariable(AllocationInstruction call, int ind) {
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
    AllocationInstruction call;

    CallVariable() { this = TCallVariable(call, ind) }

    AllocationInstruction getCall() { result = call }

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
  TDefImpl(Operand address, int index) {
    isDef(_, _, address, _, _, index) and
    any(SsaInternals0::Def def).getAddressOperand() = address
  } or
  TUseImpl(Operand operand, int index) {
    isUse(_, operand, _, _, index) and
    not isDef(_, _, operand, _, _, _)
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

class DefImpl extends DefOrUseImpl, TDefImpl {
  Operand address;
  int ind;

  DefImpl() { this = TDefImpl(address, ind) }

  override Instruction getBase() { isDef(_, _, address, result, _, _) }

  Operand getAddressOperand() { result = address }

  int getIndirection() { isDef(_, _, address, _, result, ind) }

  override int getIndex() { result = ind }

  Instruction getDefiningInstruction() { isDef(_, result, address, _, _, _) }

  override string toString() { result = "DefImpl" }

  override IRBlock getBlock() { result = this.getDefiningInstruction().getBlock() }

  override Cpp::Location getLocation() { result = this.getDefiningInstruction().getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getDefiningInstruction() = block.getInstruction(index)
  }

  predicate isCertain() { isDef(true, _, address, _, _, ind) }
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

  predicate isCertain() { isUse(true, operand, _, _, ind) }

  predicate isUncertain() { isUse(false, operand, _, _, ind) }
}

predicate adjacentDefRead(DefOrUse defOrUse1, UseOrPhi use) {
  exists(IRBlock bb1, int i1, SourceVariable v |
    defOrUse1.asDefOrUse().hasIndexInBlock(bb1, i1, v)
  |
    exists(IRBlock bb2, int i2 |
      adjacentDefRead(_, pragma[only_bind_into](bb1), pragma[only_bind_into](i1),
        pragma[only_bind_into](bb2), pragma[only_bind_into](i2))
    |
      use.asDefOrUse().(UseImpl).hasIndexInBlock(bb2, i2, v)
    )
    or
    exists(PhiNode phi |
      lastRefRedef(_, bb1, i1, phi) and
      use.asPhi() = phi and
      phi.getSourceVariable() = v
    )
  )
}

private predicate useToNode(UseOrPhi use, Node nodeTo) {
  exists(UseImpl useImpl | useImpl = use.asDefOrUse() |
    useImpl.getIndex() = 0 and
    nodeTo.asOperand() = useImpl.getOperand()
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

private predicate nodeToDef(Node nodeFrom, DefImpl def) {
  def.getIndex() = 0 and
  def.getDefiningInstruction() = nodeFrom.asInstruction()
  or
  // implies def.getIndex() > 0
  hasInstructionAndIndex(nodeFrom, def.getDefiningInstruction(), def.getIndex())
}

pragma[noinline]
predicate outNodeHasAddressAndIndex(IndirectArgumentOutNode out, Operand address, int index) {
  out.getAddressOperand() = address and
  out.getIndex() = index
}

private predicate defToNode(Node nodeFrom, DefOrUse def) {
  defToNodeImpl(nodeFrom, def.asDefOrUse())
}

predicate defToNodeImpl(Node nodeFrom, DefOrUseImpl def) { nodeToDef(nodeFrom, def) }

private predicate nodeToDefOrUse(Node nodeFrom, SsaDefOrUse defOrUse) {
  // Node -> Def
  defToNode(nodeFrom, defOrUse)
  or
  // Node -> Use
  useToNode(defOrUse, nodeFrom)
}

predicate indirectConversionFlowStepExcludeFieldsStep(Node opFrom, Node opTo) {
  not exists(UseOrPhi defOrUse |
    nodeToDefOrUse(opTo, defOrUse) and
    adjacentDefRead(defOrUse, _)
  ) and
  exists(Operand op1, Operand op2, int index |
    hasOperandAndIndex(opFrom, op1, pragma[only_bind_into](index)) and
    hasOperandAndIndex(opTo, op2, pragma[only_bind_into](index)) and
    conversionFlowStepExcludeFields(op1, op2, _)
  )
}

private predicate adjustForPointerArith(
  Node nodeFrom, Node adjusted, DefOrUse defOrUse, UseOrPhi use
) {
  nodeFrom = any(PostUpdateNode pun).getPreUpdateNode() and
  indirectConversionFlowStepExcludeFieldsStep*(adjusted, nodeFrom) and
  nodeToDefOrUse(adjusted, defOrUse) and
  adjacentDefRead(defOrUse, use)
}

predicate defUseFlow(Node nodeFrom, Node nodeTo) {
  // "nodeFrom is a pre-update node of some post-update node" is implied by adjustedForPointerArith.
  exists(DefOrUse defOrUse1, UseOrPhi use, Node node |
    adjustForPointerArith(nodeFrom, node, defOrUse1, use) and
    useToNode(use, nodeTo)
  )
  or
  not nodeFrom = any(PostUpdateNode pun).getPreUpdateNode() and
  exists(DefOrUse defOrUse1, UseOrPhi use |
    nodeToDefOrUse(nodeFrom, defOrUse1) and
    adjacentDefRead(defOrUse1, use) and
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
  exists(DefImpl def | def.hasIndexInBlock(bb, i, v) |
    if def.isCertain() then certain = true else certain = false
  )
}

/**
 * Holds if the `i`'th read in block `bb` reads to the variable `v`.
 * `certain` is `true` if the read is guaranteed. For C++, this is always the case.
 */
predicate variableRead(IRBlock bb, int i, SourceVariable v, boolean certain) {
  exists(UseImpl use | use.hasIndexInBlock(bb, i, v) |
    if use.isCertain() then certain = true else certain = false
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

  cached
  predicate lastRefRedef(Definition def, IRBlock bb, int i, Definition next) {
    Ssa::lastRefRedef(def, bb, i, next)
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
  string toString() { none() }

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

  override string toString() { result = defOrUse.toString() }
}

class Phi extends TPhi, SsaDefOrUse {
  PhiNode phi;

  Phi() { this = TPhi(phi) }

  final override PhiNode asPhi() { result = phi }

  final override Location getLocation() { result = phi.getBasicBlock().getLocation() }

  override string toString() { result = "Phi" }
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

  Instruction getAddress() { result = this.getAddressOperand().getDef() }

  pragma[inline]
  int getIndex() { pragma[only_bind_into](result) = pragma[only_bind_out](defOrUse).getIndex() }

  Instruction getDefiningInstruction() { result = defOrUse.getDefiningInstruction() }
}

import SsaCached

class PhiNode = Ssa::PhiNode;

class Definition = Ssa::Definition;
