private import codeql.ssa.Ssa as SsaImplCommon
private import semmle.code.cpp.ir.IR
private import DataFlowUtil
private import DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.cpp.models.interfaces.Allocation as Alloc
private import semmle.code.cpp.models.interfaces.DataFlow as DataFlow
private import semmle.code.cpp.ir.internal.IRCppLanguage
private import DataFlowPrivate
private import ssa0.SsaInternals as SsaInternals0
import SsaInternalsCommon

private module SourceVariables {
  int getMaxIndirectionForIRVariable(IRVariable var) {
    exists(Type type, boolean isGLValue |
      var.getLanguageType().hasType(type, isGLValue) and
      if isGLValue = true
      then result = 1 + getMaxIndirectionsForType(type)
      else result = getMaxIndirectionsForType(type)
    )
  }

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

/**
 * Holds if the `(operand, indirectionIndex)` columns should be
 * assigned a `RawIndirectOperand` value.
 */
predicate hasRawIndirectOperand(Operand op, int indirectionIndex) {
  exists(CppType type, int m |
    not ignoreOperand(op) and
    type = getLanguageType(op) and
    m = countIndirectionsForCppType(type) and
    indirectionIndex = [1 .. m] and
    not exists(getIRRepresentationOfIndirectOperand(op, indirectionIndex))
  )
}

/**
 * Holds if the `(instr, indirectionIndex)` columns should be
 * assigned a `RawIndirectInstruction` value.
 */
predicate hasRawIndirectInstruction(Instruction instr, int indirectionIndex) {
  exists(CppType type, int m |
    not ignoreInstruction(instr) and
    type = getResultLanguageType(instr) and
    m = countIndirectionsForCppType(type) and
    indirectionIndex = [1 .. m] and
    not exists(getIRRepresentationOfIndirectInstruction(instr, indirectionIndex))
  )
}

cached
private newtype TDefOrUseImpl =
  TDefImpl(Operand address, int indirectionIndex) {
    isDef(_, _, address, _, _, indirectionIndex) and
    // We only include the definition if the SSA pruning stage
    // concluded that the definition is live after the write.
    any(SsaInternals0::Def def).getAddressOperand() = address
  } or
  TUseImpl(Operand operand, int indirectionIndex) {
    isUse(_, operand, _, _, indirectionIndex) and
    not isDef(_, _, operand, _, _, _)
  } or
  TIteratorDef(
    Operand iteratorDerefAddress, BaseSourceVariableInstruction container, int indirectionIndex
  ) {
    isIteratorDef(container, iteratorDerefAddress, _, _, indirectionIndex) and
    any(SsaInternals0::Def def | def.isIteratorDef()).getAddressOperand() = iteratorDerefAddress
  } or
  TIteratorUse(
    Operand iteratorAddress, BaseSourceVariableInstruction container, int indirectionIndex
  ) {
    isIteratorUse(container, iteratorAddress, _, indirectionIndex)
  } or
  TFinalParameterUse(Parameter p, int indirectionIndex) {
    // Avoid creating parameter nodes if there is no definitions of the variable other than the initializaion.
    exists(SsaInternals0::Def def |
      def.getSourceVariable().getBaseVariable().(BaseIRVariable).getIRVariable().getAst() = p and
      not def.getValue().asInstruction() instanceof InitializeParameterInstruction
    ) and
    // If the type is modifiable
    exists(CppType cppType |
      cppType.hasUnspecifiedType(p.getUnspecifiedType(), _) and
      isModifiableAt(cppType, indirectionIndex + 1)
    ) and
    (
      exists(Indirection indirection |
        indirection.getType() = p.getUnspecifiedType() and
        indirectionIndex = [1 .. indirection.getNumberOfIndirections()]
      )
      or
      // Array types don't have indirections. So we need to special case them here.
      exists(Cpp::ArrayType arrayType, CppType cppType |
        arrayType = p.getUnspecifiedType() and
        cppType.hasUnspecifiedType(arrayType, _) and
        indirectionIndex = [1 .. countIndirectionsForCppType(cppType)]
      )
    )
  }

abstract private class DefOrUseImpl extends TDefOrUseImpl {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the block of this definition or use. */
  final IRBlock getBlock() { this.hasIndexInBlock(result, _) }

  /** Holds if this definition or use has index `index` in block `block`. */
  abstract predicate hasIndexInBlock(IRBlock block, int index);

  final predicate hasIndexInBlock(IRBlock block, int index, SourceVariable sv) {
    this.hasIndexInBlock(block, index) and
    sv = this.getSourceVariable()
  }

  /** Gets the location of this element. */
  abstract Cpp::Location getLocation();

  /**
   * Gets the index (i.e., the number of loads required) of this
   * definition or use.
   *
   * Note that this is _not_ the definition's (or use's) index in
   * the enclosing basic block. To obtain this index, use
   * `DefOrUseImpl::hasIndexInBlock/2` or `DefOrUseImpl::hasIndexInBlock/3`.
   */
  abstract int getIndirectionIndex();

  /**
   * Gets the instruction that computes the base of this definition or use.
   * This is always a `VariableAddressInstruction` or an `AllocationInstruction`.
   */
  abstract BaseSourceVariableInstruction getBase();

  final BaseSourceVariable getBaseSourceVariable() {
    this.getBase().getBaseSourceVariable() = result
  }

  /** Gets the variable that is defined or used. */
  final SourceVariable getSourceVariable() {
    exists(BaseSourceVariable v, int ind |
      sourceVariableHasBaseAndIndex(result, v, ind) and
      defOrUseHasSourceVariable(this, v, ind)
    )
  }
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
  Operand address;
  int ind;

  bindingset[ind]
  DefImpl() { any() }

  abstract int getIndirection();

  abstract Node0Impl getValue();

  abstract predicate isCertain();

  Operand getAddressOperand() { result = address }

  override int getIndirectionIndex() { result = ind }

  override string toString() { result = "DefImpl" }

  override Cpp::Location getLocation() { result = this.getAddressOperand().getUse().getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getAddressOperand().getUse() = block.getInstruction(index)
  }
}

private class DirectDef extends DefImpl, TDefImpl {
  DirectDef() { this = TDefImpl(address, ind) }

  override BaseSourceVariableInstruction getBase() { isDef(_, _, address, result, _, _) }

  override int getIndirection() { isDef(_, _, address, _, result, ind) }

  override Node0Impl getValue() { isDef(_, result, address, _, _, _) }

  override predicate isCertain() { isDef(true, _, address, _, _, ind) }
}

private class IteratorDef extends DefImpl, TIteratorDef {
  BaseSourceVariableInstruction container;

  IteratorDef() { this = TIteratorDef(address, container, ind) }

  override BaseSourceVariableInstruction getBase() { result = container }

  override int getIndirection() { isIteratorDef(container, address, _, result, ind) }

  override Node0Impl getValue() { isIteratorDef(container, address, result, _, _) }

  override predicate isCertain() { none() }
}

abstract class UseImpl extends DefOrUseImpl {
  int ind;

  bindingset[ind]
  UseImpl() { any() }

  /** Gets the node associated with this use. */
  abstract Node getNode();

  override string toString() { result = "UseImpl" }

  /** Gets the indirection index of this use. */
  final override int getIndirectionIndex() { result = ind }

  /** Gets the number of loads that precedence this use. */
  abstract int getIndirection();

  /**
   * Holds if this use is guaranteed to read the
   * associated variable.
   */
  abstract predicate isCertain();
}

abstract private class OperandBasedUse extends UseImpl {
  Operand operand;

  bindingset[ind]
  OperandBasedUse() { any() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    operand.getUse() = block.getInstruction(index)
  }

  final override Cpp::Location getLocation() { result = operand.getLocation() }
}

private class DirectUse extends OperandBasedUse, TUseImpl {
  DirectUse() { this = TUseImpl(operand, ind) }

  override int getIndirection() { isUse(_, operand, _, result, ind) }

  override BaseSourceVariableInstruction getBase() { isUse(_, operand, result, _, ind) }

  override predicate isCertain() { isUse(true, operand, _, _, ind) }

  override Node getNode() { nodeHasOperand(result, operand, ind) }
}

private class IteratorUse extends OperandBasedUse, TIteratorUse {
  BaseSourceVariableInstruction container;

  IteratorUse() { this = TIteratorUse(operand, container, ind) }

  override int getIndirection() { isIteratorUse(container, operand, result, ind) }

  override BaseSourceVariableInstruction getBase() { result = container }

  override predicate isCertain() { none() }

  override Node getNode() { nodeHasOperand(result, operand, ind) }
}

class FinalParameterUse extends UseImpl, TFinalParameterUse {
  Parameter p;

  FinalParameterUse() { this = TFinalParameterUse(p, ind) }

  Parameter getParameter() { result = p }

  override Node getNode() {
    result.(FinalParameterNode).getParameter() = p and
    result.(FinalParameterNode).getIndirectionIndex() = ind
  }

  override int getIndirection() { result = ind + 1 }

  override predicate isCertain() { any() }

  override predicate hasIndexInBlock(IRBlock block, int index) {
    // Ideally, this should always be a `ReturnInstruction`, but if
    // someone forgets to write a `return` statement in a function
    // with a non-void return type we generate an `UnreachedInstruction`.
    // In this case we still want to generate flow out of such functions
    // if they write to a parameter. So we pick the index of the
    // `UnreachedInstruction` as the index of this use.
    // Note that a function may have both a `ReturnInstruction` and an
    // `UnreachedInstruction`. If that's the case this predicate will
    // return multiple results. I don't think this is detrimental to
    // performance, however.
    exists(Instruction return |
      return instanceof ReturnInstruction or
      return instanceof UnreachedInstruction
    |
      block.getInstruction(index) = return and
      return.getEnclosingFunction() = p.getFunction()
    )
  }

  override Cpp::Location getLocation() {
    // Parameters can have multiple locations. When there's a unique location we use
    // that one, but if multiple locations exist we default to an unknown location.
    result = unique( | | p.getLocation())
    or
    not exists(unique( | | p.getLocation())) and
    result instanceof UnknownDefaultLocation
  }

  override BaseSourceVariableInstruction getBase() {
    exists(InitializeParameterInstruction init |
      init.getParameter() = p and
      // This is always a `VariableAddressInstruction`
      result = init.getAnOperand().getDef()
    )
  }
}

/**
 * Holds if `defOrUse1` is a definition which is first read by `use`,
 * or if `defOrUse1` is a use and `use` is a next subsequent use.
 *
 * In both cases, `use` can either be an explicit use written in the
 * source file, or it can be a phi node as computed by the SSA library.
 */
predicate adjacentDefRead(DefOrUse defOrUse1, UseOrPhi use) {
  exists(IRBlock bb1, int i1, SourceVariable v |
    defOrUse1.asDefOrUse().hasIndexInBlock(bb1, i1, v)
  |
    exists(IRBlock bb2, int i2, Definition def |
      adjacentDefRead(pragma[only_bind_into](def), pragma[only_bind_into](bb1),
        pragma[only_bind_into](i1), pragma[only_bind_into](bb2), pragma[only_bind_into](i2)) and
      def.getSourceVariable() = v and
      use.asDefOrUse().(UseImpl).hasIndexInBlock(bb2, i2, v)
    )
    or
    exists(PhiNode phi |
      lastRefRedef(_, bb1, i1, phi) and
      use.asPhi() = phi and
      phi.getSourceVariable() = pragma[only_bind_into](v)
    )
  )
}

private predicate useToNode(UseOrPhi use, Node nodeTo) { nodeTo = use.getNode() }

pragma[noinline]
predicate outNodeHasAddressAndIndex(
  IndirectArgumentOutNode out, Operand address, int indirectionIndex
) {
  out.getAddressOperand() = address and
  out.getIndirectionIndex() = indirectionIndex
}

private predicate defToNode(Node nodeFrom, Def def, boolean uncertain) {
  (
    nodeHasOperand(nodeFrom, def.getValue().asOperand(), def.getIndirectionIndex())
    or
    nodeHasInstruction(nodeFrom, def.getValue().asInstruction(), def.getIndirectionIndex())
  ) and
  if def.isCertain() then uncertain = false else uncertain = true
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if `nodeFrom` is the node that correspond to the definition or use `defOrUse`.
 */
predicate nodeToDefOrUse(Node nodeFrom, SsaDefOrUse defOrUse, boolean uncertain) {
  // Node -> Def
  defToNode(nodeFrom, defOrUse, uncertain)
  or
  // Node -> Use
  useToNode(defOrUse, nodeFrom) and
  uncertain = false
}

/**
 * Perform a single conversion-like step from `nFrom` to `nTo`. This relation
 * only holds when there is no use-use relation out of `nTo`.
 */
private predicate indirectConversionFlowStep(Node nFrom, Node nTo) {
  not exists(UseOrPhi defOrUse |
    nodeToDefOrUse(nTo, defOrUse, _) and
    adjacentDefRead(defOrUse, _)
  ) and
  (
    exists(Operand op1, Operand op2, int indirectionIndex, Instruction instr |
      hasOperandAndIndex(nFrom, op1, pragma[only_bind_into](indirectionIndex)) and
      hasOperandAndIndex(nTo, op2, pragma[only_bind_into](indirectionIndex)) and
      instr = op2.getDef() and
      conversionFlow(op1, instr, _, _)
    )
    or
    exists(Operand op1, Operand op2, int indirectionIndex, Instruction instr |
      hasOperandAndIndex(nFrom, op1, pragma[only_bind_into](indirectionIndex)) and
      hasOperandAndIndex(nTo, op2, indirectionIndex - 1) and
      instr = op2.getDef() and
      isDereference(instr, op1)
    )
  )
}

/**
 * The reason for this predicate is a bit annoying:
 * We cannot mark a `PointerArithmeticInstruction` that computes an offset based on some SSA
 * variable `x` as a use of `x` since this creates taint-flow in the following example:
 * ```c
 * int x = array[source]
 * sink(*array)
 * ```
 * This is because `source` would flow from the operand of `PointerArithmeticInstruction` to the
 * result of the instruction, and into the `IndirectOperand` that represents the value of `*array`.
 * Then, via use-use flow, flow will arrive at `*array` in `sink(*array)`.
 *
 * So this predicate recurses back along conversions and `PointerArithmeticInstruction`s to find the
 * first use that has provides use-use flow, and uses that target as the target of the `nodeFrom`.
 */
private predicate adjustForPointerArith(Node nodeFrom, UseOrPhi use, boolean uncertain) {
  nodeFrom = any(PostUpdateNode pun).getPreUpdateNode() and
  exists(DefOrUse defOrUse, Node adjusted |
    indirectConversionFlowStep*(adjusted, nodeFrom) and
    nodeToDefOrUse(adjusted, defOrUse, uncertain) and
    adjacentDefRead(defOrUse, use)
  )
}

private predicate ssaFlowImpl(Node nodeFrom, Node nodeTo, boolean uncertain) {
  // `nodeFrom = any(PostUpdateNode pun).getPreUpdateNode()` is implied by adjustedForPointerArith.
  exists(UseOrPhi use |
    adjustForPointerArith(nodeFrom, use, uncertain) and
    useToNode(use, nodeTo)
  )
  or
  not nodeFrom = any(PostUpdateNode pun).getPreUpdateNode() and
  exists(DefOrUse defOrUse1, UseOrPhi use |
    nodeToDefOrUse(nodeFrom, defOrUse1, uncertain) and
    adjacentDefRead(defOrUse1, use) and
    useToNode(use, nodeTo)
  )
}

/**
 * Holds if `def` is the corresponding definition of
 * the SSA library's `definition`.
 */
private predicate ssaDefinition(Def def, Definition definition) {
  exists(IRBlock block, int i, SourceVariable sv |
    def.hasIndexInBlock(block, i, sv) and
    definition.definesAt(sv, block, i)
  )
}

/** Gets a node that represents the prior definition of `node`. */
private Node getAPriorDefinition(Node node) {
  exists(Def def, Definition definition, Definition inp, Def input |
    defToNode(node, def, true) and
    ssaDefinition(def, definition) and
    uncertainWriteDefinitionInput(pragma[only_bind_into](definition), pragma[only_bind_into](inp)) and
    ssaDefinition(input, inp) and
    defToNode(result, input, _)
  )
}

/** Holds if there is def-use or use-use flow from `nodeFrom` to `nodeTo`. */
predicate ssaFlow(Node nodeFrom, Node nodeTo) {
  exists(Node nFrom, boolean uncertain |
    ssaFlowImpl(nFrom, nodeTo, uncertain) and
    if uncertain = true then nodeFrom = [nFrom, getAPriorDefinition(nFrom)] else nodeFrom = nFrom
  )
}

/**
 * Holds if `use` is a use of `sv` and is a next adjacent use of `phi` in
 * index `i1` in basic block `bb1`.
 *
 * This predicate exists to prevent an early join of `adjacentDefRead` with `definesAt`.
 */
pragma[nomagic]
private predicate fromPhiNodeToUse(PhiNode phi, SourceVariable sv, IRBlock bb1, int i1, UseOrPhi use) {
  exists(IRBlock bb2, int i2 |
    use.asDefOrUse().hasIndexInBlock(bb2, i2, sv) and
    adjacentDefRead(pragma[only_bind_into](phi), pragma[only_bind_into](bb1),
      pragma[only_bind_into](i1), pragma[only_bind_into](bb2), pragma[only_bind_into](i2))
  )
}

/** Holds if `nodeTo` receives flow from the phi node `nodeFrom`. */
predicate fromPhiNode(SsaPhiNode nodeFrom, Node nodeTo) {
  exists(PhiNode phi, SourceVariable sv, IRBlock bb1, int i1, UseOrPhi use |
    phi = nodeFrom.getPhiNode() and
    phi.definesAt(sv, bb1, i1) and
    useToNode(use, nodeTo)
  |
    fromPhiNodeToUse(phi, sv, bb1, i1, use)
    or
    exists(PhiNode phiTo |
      lastRefRedef(phi, _, _, phiTo) and
      nodeTo.(SsaPhiNode).getPhiNode() = phiTo
    )
  )
}

/**
 * Holds if there is a write at index `i` in basic block `bb` to variable `v` that's
 * subsequently read (as determined by the SSA pruning stage).
 */
private predicate variableWriteCand(IRBlock bb, int i, SourceVariable v) {
  exists(SsaInternals0::Def def, SsaInternals0::SourceVariable v0 |
    def.asDefOrUse().hasIndexInBlock(bb, i, v0) and
    v0 = v.getBaseVariable()
  )
}

private module SsaInput implements SsaImplCommon::InputSig {
  import InputSigCommon
  import SourceVariables

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
}

/**
 * The final SSA predicates used for dataflow purposes.
 */
cached
module SsaCached {
  /**
   * Holds if `def` is accessed at index `i1` in basic block `bb1` (either a read
   * or a write), `def` is read at index `i2` in basic block `bb2`, and there is a
   * path between them without any read of `def`.
   */
  cached
  predicate adjacentDefRead(Definition def, IRBlock bb1, int i1, IRBlock bb2, int i2) {
    SsaImpl::adjacentDefRead(def, bb1, i1, bb2, i2)
  }

  /**
   * Holds if the node at index `i` in `bb` is a last reference to SSA definition
   * `def`. The reference is last because it can reach another write `next`,
   * without passing through another read or write.
   */
  cached
  predicate lastRefRedef(Definition def, IRBlock bb, int i, Definition next) {
    SsaImpl::lastRefRedef(def, bb, i, next)
  }

  cached
  predicate uncertainWriteDefinitionInput(SsaImpl::UncertainWriteDefinition def, Definition inp) {
    SsaImpl::uncertainWriteDefinitionInput(def, inp)
  }
}

cached
private newtype TSsaDefOrUse =
  TDefOrUse(DefOrUseImpl defOrUse) {
    defOrUse instanceof UseImpl
    or
    // Like in the pruning stage, we only include definition that's live after the
    // write as the final definitions computed by SSA.
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

  predicate hasIndexInBlock(IRBlock block, int index, SourceVariable sv) {
    defOrUse.hasIndexInBlock(block, index, sv)
  }
}

class Phi extends TPhi, SsaDefOrUse {
  PhiNode phi;

  Phi() { this = TPhi(phi) }

  final override PhiNode asPhi() { result = phi }

  final override Location getLocation() { result = phi.getBasicBlock().getLocation() }

  override string toString() { result = "Phi" }

  SsaPhiNode getNode() { result.getPhiNode() = phi }
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

  final Node getNode() {
    result = this.(Phi).getNode()
    or
    result = this.asDefOrUse().(UseImpl).getNode()
  }
}

class Def extends DefOrUse {
  override DefImpl defOrUse;

  Operand getAddressOperand() { result = defOrUse.getAddressOperand() }

  Instruction getAddress() { result = this.getAddressOperand().getDef() }

  /**
   * This predicate ensures that joins go from `defOrUse` to the result
   * instead of the other way around.
   */
  pragma[inline]
  int getIndirectionIndex() {
    pragma[only_bind_into](result) = pragma[only_bind_out](defOrUse).getIndirectionIndex()
  }

  Node0Impl getValue() { result = defOrUse.getValue() }

  predicate isCertain() { defOrUse.isCertain() }
}

private module SsaImpl = SsaImplCommon::Make<SsaInput>;

class PhiNode = SsaImpl::PhiNode;

class Definition = SsaImpl::Definition;

class UncertainWriteDefinition = SsaImpl::UncertainWriteDefinition;

import SsaCached
