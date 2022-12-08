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

private module IteratorDefUse {
  private import semmle.code.cpp.models.interfaces.Iterator as Interfaces
  private import semmle.code.cpp.models.implementations.Iterator as Iterator
  private import semmle.code.cpp.models.implementations.StdContainer as StdContainer

  private CallInstruction getCall(ArgumentOperand operand) { result.getAnOperand() = operand }

  /**
   * Gets a `CallInstruction` that targets an iterator-returning function that was
   * used to construct the value used by `use`.
   */
  private CallInstruction getAnIteratorAccess(UseImpl use) {
    exists(Instruction value, StoreInstruction store |
      // Get the ultimiate definition of this use.
      store = use.getPruningUse().getAnUltimateValue().asInstruction() and
      value = store.getSourceValue()
    |
      // We're done if it's a call that targets an iterator-returning function.
      if value.(CallInstruction).getStaticCallTarget() instanceof Iterator::GetIteratorFunction
      then result = value
      else
        // Otherwise, we recursively search for a prior definition.
        exists(Operand operand |
          // Recurse through identity conversions
          conversionFlow(operand, value, _)
          or
          // ... and dereferences.
          exists(CallInstruction call |
            isDereference(call, operand) and
            operandForfullyConvertedCall(store.getDestinationAddressOperand(), call)
          )
        |
          result = getAnIteratorAccess(any(UseImpl priorUse | priorUse.getOperand() = operand))
        )
    )
  }

  /**
   * Holds if `containerUse` is the use of a variable of a container type that is used to obtain
   * an iterator into the container represented by `containerUse`, and `iteratorUse` is a use
   * of this iterator.
   */
  private predicate acquiresIteratorFromContainer(DirectUse containerUse, DirectUse iteratorUse) {
    exists(CallInstruction getIterator |
      containerUse.getOperand() = getIterator.getThisArgumentOperand() and
      containerUse.getIndirectionIndex() = 1 and
      getIterator = getAnIteratorAccess(iteratorUse)
    )
  }

  /**
   * Holds if `use` is a use of an iterator that is obtained by calling an iterator-returning
   * function that returns an iterator to the container represented by `containerUse.`
   */
  predicate isIteratorUse(DirectUse use, DirectUse containerUse) {
    exists(DirectUse iteratorUse |
      // Consider an example like:
      // ```cpp
      //   iterator = container.begin();
      //   sink(*iterator);
      // ```
      // In this case, `use` is the use of `*iterator`, `containerUse` is the use of `container`,
      // and `iteratorUse` is the use of `iterator` on line 2.
      use.getIndirection() > 1 and
      use.getIndirectionIndex() = 0 and
      use.getPruningUse().getSourceVariable().getBaseVariable().getType().getUnspecifiedType()
        instanceof Iterator::Iterator and
      use.getOperand() = iteratorUse.getOperand() and
      acquiresIteratorFromContainer(containerUse, iteratorUse)
    )
  }

  /**
   * Holds if `def` is a definition of an iterator that implicitly stores a value into a
   * container through an iterator represented by `containerUser`.
   */
  predicate isIteratorDef(DirectDef def, DirectUse containerUse) {
    exists(UseImpl iteratorUse |
      // Consider an example like:
      // ```cpp
      //   iterator = container.begin();
      //   *iterator = source();
      // ```
      // In this case, `def` is the definition of `*iterator`, `containerUse` is the use of `container`,
      // and `iteratorUse` is the use of `iterator` on line 2.
      def.getIndirection() > 1 and
      def.getIndirectionIndex() = 0 and
      def.getPruningDef().getBase().getBaseSourceVariable().getType().getUnspecifiedType()
        instanceof Iterator::Iterator and
      acquiresIteratorFromContainer(containerUse, iteratorUse) and
      operandForfullyConvertedCall(def.getAddressOperand(), getCall(iteratorUse.getOperand()))
    )
  }
}

cached
private newtype TDefOrUseImpl =
  TDirectDef(Operand address, int indirectionIndex) {
    isDef(_, _, address, _, _, indirectionIndex) and
    // We only include the definition if the SSA pruning stage
    // concluded that the definition is live after the write.
    any(SsaInternals0::Def def).getAddressOperand() = address
  } or
  TDirectUse(Operand operand, int indirectionIndex) {
    isUse(_, operand, _, _, indirectionIndex) and
    not isDef(true, _, operand, _, _, _)
  } or
  TIteratorUse(DirectUse use, DirectUse containerUse) {
    IteratorDefUse::isIteratorUse(use, containerUse)
  } or
  TIteratorDef(DirectDef def, DirectUse containerUse) {
    IteratorDefUse::isIteratorDef(def, containerUse)
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

  /**
   * Gets the number of loads between this definition or use and
   * its base source variable instruction.
   */
  abstract int getIndirection();

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

  override BaseSourceVariableInstruction getBase() { isDef(_, _, address, result, _, _) }

  Operand getAddressOperand() { result = address }

  Node0Impl getValue() { isDef(_, result, address, _, _, _) }

  override string toString() { result = "DefImpl" }

  override IRBlock getBlock() { result = this.getAddressOperand().getUse().getBlock() }

  override Cpp::Location getLocation() { result = this.getAddressOperand().getUse().getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getAddressOperand().getUse() = block.getInstruction(index)
  }

  predicate isCertain() { isDef(true, _, address, _, _, ind) }

  /**
   * Holds if this definition not having a use does not imply that it
   * will be removed from the SSA def-use relation.
   */
  predicate cannotBePruned() { none() }

  /** Gets the definition from the SSA pruning stage that corresponds to this definition. */
  SsaInternals0::Def getPruningDef() { result.getAddressOperand() = address }
}

private class DirectDef extends DefImpl, TDirectDef {
  DirectDef() { this = TDirectDef(address, ind) }

  override int getIndirection() { isDef(_, _, address, _, result, ind) }

  override string toString() { result = "DefImpl" }

  override int getIndirectionIndex() { result = ind }
}

private class IteratorDef extends DefImpl, TIteratorDef {
  DirectDef def;
  DirectUse containerUse;

  IteratorDef() {
    this = TIteratorDef(def, containerUse) and
    def = TDirectDef(address, ind + 1)
  }

  override BaseSourceVariableInstruction getBase() { result = containerUse.getBase() }

  override int getIndirection() { result = def.getIndirection() - 1 }

  override int getIndirectionIndex() { result = def.getIndirectionIndex() }

  override string toString() { result = "IteratorDef" }

  override predicate cannotBePruned() { any() }
}

abstract class UseImpl extends DefOrUseImpl {
  Operand operand;
  int ind;

  bindingset[ind]
  UseImpl() { any() }

  Operand getOperand() { result = operand }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    operand.getUse() = block.getInstruction(index)
  }

  final override IRBlock getBlock() { result = operand.getUse().getBlock() }

  final override Cpp::Location getLocation() { result = operand.getLocation() }

  override int getIndirectionIndex() { result = ind }

  override BaseSourceVariableInstruction getBase() { isUse(_, operand, result, _, ind) }

  predicate isCertain() { isUse(true, operand, _, _, ind) }

  /** Gets the use from the SSA pruning stage that corresponds to this use. */
  SsaInternals0::Use getPruningUse() { result.getOperand() = operand }
}

private class DirectUse extends UseImpl, TDirectUse {
  DirectUse() { this = TDirectUse(operand, ind) }

  override string toString() { result = "DirectUse" }

  override int getIndirection() { isUse(_, operand, _, result, ind) }

  override BaseSourceVariableInstruction getBase() { isUse(_, operand, result, _, ind) }

  override predicate isCertain() { isUse(true, operand, _, _, ind) }
}

private class IteratorUse extends UseImpl, TIteratorUse {
  DirectUse use;
  DirectUse containerUse;

  IteratorUse() {
    this = TIteratorUse(use, containerUse) and
    use = TDirectUse(operand, ind + 1)
  }

  override BaseSourceVariableInstruction getBase() { result = containerUse.getBase() }

  override int getIndirection() { result = containerUse.getIndirection() }

  override string toString() { result = "IteratorUse" }
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

private predicate useToNode(UseOrPhi use, Node nodeTo) {
  exists(UseImpl useImpl |
    useImpl = use.asDefOrUse() and
    nodeHasOperand(nodeTo, useImpl.getOperand(), useImpl.getIndirectionIndex())
  )
  or
  nodeTo.(SsaPhiNode).getPhiNode() = use.asPhi()
}

pragma[noinline]
predicate outNodeHasAddressAndIndex(
  IndirectArgumentOutNode out, Operand address, int indirectionIndex
) {
  out.getAddressOperand() = address and
  out.getIndirectionIndex() = indirectionIndex
}

private predicate defToNode(Node nodeFrom, Def def) {
  nodeHasOperand(nodeFrom, def.getValue().asOperand(), def.getIndirectionIndex())
  or
  nodeHasInstruction(nodeFrom, def.getValue().asInstruction(), def.getIndirectionIndex())
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if `nodeFrom` is the node that correspond to the definition or use `defOrUse`.
 */
predicate nodeToDefOrUse(Node nodeFrom, SsaDefOrUse defOrUse) {
  // Node -> Def
  defToNode(nodeFrom, defOrUse)
  or
  // Node -> Use
  useToNode(defOrUse, nodeFrom)
}

/**
 * Perform a single conversion-like step from `nFrom` to `nTo`. This relation
 * only holds when there is no use-use relation out of `nTo`.
 */
private predicate indirectConversionFlowStep(Node nFrom, Node nTo) {
  not exists(UseOrPhi defOrUse |
    nodeToDefOrUse(nTo, defOrUse) and
    adjacentDefRead(defOrUse, _)
  ) and
  exists(Operand op1, Operand op2, int indirectionIndex, Instruction instr |
    hasOperandAndIndex(nFrom, op1, pragma[only_bind_into](indirectionIndex)) and
    hasOperandAndIndex(nTo, op2, pragma[only_bind_into](indirectionIndex)) and
    instr = op2.getDef() and
    conversionFlow(op1, instr, _)
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
private predicate adjustForPointerArith(Node nodeFrom, UseOrPhi use) {
  nodeFrom = any(PostUpdateNode pun).getPreUpdateNode() and
  exists(DefOrUse defOrUse, Node adjusted |
    indirectConversionFlowStep*(adjusted, nodeFrom) and
    nodeToDefOrUse(adjusted, defOrUse) and
    adjacentDefRead(defOrUse, use)
  )
}

/** Holds if there is def-use or use-use flow from `nodeFrom` to `nodeTo`. */
predicate ssaFlow(Node nodeFrom, Node nodeTo) {
  // `nodeFrom = any(PostUpdateNode pun).getPreUpdateNode()` is implied by adjustedForPointerArith.
  exists(UseOrPhi use |
    adjustForPointerArith(nodeFrom, use) and
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
    exists(DefImpl def |
      variableWriteCand(bb, i, v) or
      def.cannotBePruned()
    |
      def.hasIndexInBlock(bb, i, v) and
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
}

cached
private newtype TSsaDefOrUse =
  TDefOrUse(DefOrUseImpl defOrUse) {
    defOrUse instanceof UseImpl
    or
    // Like in the pruning stage, we only include definition that's live after the
    // write as the final definitions computed by SSA, and we only do so if we're
    // allowed to prune it away.
    exists(DefImpl def | def = defOrUse |
      def.cannotBePruned()
      or
      exists(Definition definition, SourceVariable sv, IRBlock bb, int i |
        definition.definesAt(sv, bb, i) and
        def.hasIndexInBlock(bb, i, sv)
      )
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

  /**
   * This predicate ensures that joins go from `defOrUse` to the result
   * instead of the other way around.
   */
  pragma[inline]
  int getIndirectionIndex() {
    pragma[only_bind_into](result) = pragma[only_bind_out](defOrUse).getIndirectionIndex()
  }

  Node0Impl getValue() { result = defOrUse.getValue() }
}

private module SsaImpl = SsaImplCommon::Make<SsaInput>;

class PhiNode = SsaImpl::PhiNode;

class Definition = SsaImpl::Definition;

import SsaCached
