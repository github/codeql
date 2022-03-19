import SsaImplCommon
private import cpp as Cpp
private import semmle.code.cpp.ir.IR
private import DataFlowUtil
private import DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.cpp.models.interfaces.Allocation as Alloc
private import semmle.code.cpp.models.interfaces.DataFlow as DataFlow

private module SourceVariables {
  private newtype TSourceVariable =
    TSourceIRVariable(IRVariable var) or
    TSourceIRVariableIndirection(InitializeIndirectionInstruction init)

  abstract class SourceVariable extends TSourceVariable {
    IRVariable var;

    abstract string toString();
  }

  class SourceIRVariable extends SourceVariable, TSourceIRVariable {
    SourceIRVariable() { this = TSourceIRVariable(var) }

    IRVariable getIRVariable() { result = var }

    override string toString() { result = this.getIRVariable().toString() }
  }

  class SourceIRVariableIndirection extends SourceVariable, TSourceIRVariableIndirection {
    InitializeIndirectionInstruction init;

    SourceIRVariableIndirection() {
      this = TSourceIRVariableIndirection(init) and var = init.getIRVariable()
    }

    IRVariable getUnderlyingIRVariable() { result = var }

    override string toString() { result = "*" + this.getUnderlyingIRVariable().toString() }
  }
}

import SourceVariables

cached
private newtype TDefOrUse =
  TExplicitDef(Instruction store) { explicitWrite(_, store, _) } or
  TInitializeParam(Instruction instr) {
    instr instanceof InitializeParameterInstruction
    or
    instr instanceof InitializeIndirectionInstruction
  } or
  TExplicitUse(Operand op) { isExplicitUse(op) } or
  TReturnParamIndirection(Operand op) { returnParameterIndirection(op, _) }

private class DefOrUse extends TDefOrUse {
  /** Gets the instruction associated with this definition, if any. */
  Instruction asDef() { none() }

  /** Gets the operand associated with this use, if any. */
  Operand asUse() { none() }

  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the block of this definition or use. */
  abstract IRBlock getBlock();

  /** Holds if this definition or use has index `index` in block `block`. */
  final predicate hasIndexInBlock(IRBlock block, int index) {
    block.getInstruction(index) = toInstruction(this)
  }

  /** Gets the location of this element. */
  abstract Cpp::Location getLocation();
}

private Instruction toInstruction(DefOrUse defOrUse) {
  result = defOrUse.asDef()
  or
  result = defOrUse.asUse().getUse()
}

abstract class Def extends DefOrUse {
  Instruction store;

  /** Gets the instruction of this definition. */
  Instruction getInstruction() { result = store }

  /** Gets the variable that is defined by this definition. */
  abstract SourceVariable getSourceVariable();

  /** Holds if this definition is guaranteed to happen. */
  abstract predicate isCertain();

  override Instruction asDef() { result = this.getInstruction() }

  override string toString() { result = "Def" }

  override IRBlock getBlock() { result = this.getInstruction().getBlock() }

  override Cpp::Location getLocation() { result = store.getLocation() }
}

private class ExplicitDef extends Def, TExplicitDef {
  ExplicitDef() { this = TExplicitDef(store) }

  override SourceVariable getSourceVariable() {
    exists(VariableInstruction var |
      explicitWrite(_, this.getInstruction(), var) and
      result.(SourceIRVariable).getIRVariable() = var.getIRVariable()
    )
  }

  override predicate isCertain() { explicitWrite(true, this.getInstruction(), _) }
}

private class ParameterDef extends Def, TInitializeParam {
  ParameterDef() { this = TInitializeParam(store) }

  override SourceVariable getSourceVariable() {
    result.(SourceIRVariable).getIRVariable() =
      store.(InitializeParameterInstruction).getIRVariable()
    or
    result.(SourceIRVariableIndirection).getUnderlyingIRVariable() =
      store.(InitializeIndirectionInstruction).getIRVariable()
  }

  override predicate isCertain() { any() }
}

abstract class Use extends DefOrUse {
  Operand use;

  override Operand asUse() { result = use }

  /** Gets the underlying operand of this use. */
  Operand getOperand() { result = use }

  override string toString() { result = "Use" }

  /** Gets the variable that is used by this use. */
  abstract SourceVariable getSourceVariable();

  override IRBlock getBlock() { result = use.getUse().getBlock() }

  override Cpp::Location getLocation() { result = use.getLocation() }
}

private class ExplicitUse extends Use, TExplicitUse {
  ExplicitUse() { this = TExplicitUse(use) }

  override SourceVariable getSourceVariable() {
    exists(VariableInstruction var |
      use.getDef() = var and
      if use.getUse() instanceof ReadSideEffectInstruction
      then result.(SourceIRVariableIndirection).getUnderlyingIRVariable() = var.getIRVariable()
      else result.(SourceIRVariable).getIRVariable() = var.getIRVariable()
    )
  }
}

private class ReturnParameterIndirection extends Use, TReturnParamIndirection {
  ReturnParameterIndirection() { this = TReturnParamIndirection(use) }

  override SourceVariable getSourceVariable() {
    exists(ReturnIndirectionInstruction ret |
      returnParameterIndirection(use, ret) and
      result.(SourceIRVariableIndirection).getUnderlyingIRVariable() = ret.getIRVariable()
    )
  }
}

private predicate isExplicitUse(Operand op) {
  exists(VariableAddressInstruction vai | vai = op.getDef() |
    // Don't include this operand as a use if it only exists to initialize the
    // indirection of a parameter.
    not exists(LoadInstruction load |
      load.getSourceAddressOperand() = op and
      load.getAUse().getUse() instanceof InitializeIndirectionInstruction
    ) and
    // Don't include this operand as a use if the only use of the address is for a write
    // that definitely overrides a variable.
    not (explicitWrite(true, _, vai) and exists(unique( | | vai.getAUse())))
  )
}

private predicate returnParameterIndirection(Operand op, ReturnIndirectionInstruction ret) {
  ret.getSourceAddressOperand() = op
}

/**
 * Holds if `iFrom` computes an address that is used by `iTo`.
 */
predicate addressFlow(Instruction iFrom, Instruction iTo) {
  iTo.(CopyValueInstruction).getSourceValue() = iFrom
  or
  iTo.(ConvertInstruction).getUnary() = iFrom
  or
  iTo.(CheckedConvertOrNullInstruction).getUnary() = iFrom
  or
  iTo.(InheritanceConversionInstruction).getUnary() = iFrom
  or
  iTo.(PointerArithmeticInstruction).getLeft() = iFrom
  or
  iTo.(FieldAddressInstruction).getObjectAddress() = iFrom
  or
  // We traverse `LoadInstruction`s since we want to conclude that the
  // destination of the store operation `*x = source()` is derived from `x`.
  iTo.(LoadInstruction).getSourceAddress() = iFrom
  or
  // We want to include `ReadSideEffectInstruction`s for the same reason that we include
  // `LoadInstruction`s, but only when a `WriteSideEffectInstruction` for the same index exists as well
  // (as otherwise we know that the callee won't override the data). However, given an index `i`, the
  // destination of the `WriteSideEffectInstruction` for `i` is identical to the source address of the
  // `ReadSideEffectInstruction` for `i`. So we don't have to talk about the `ReadSideEffectInstruction`
  // at all.
  exists(WriteSideEffectInstruction write |
    write.getPrimaryInstruction() = iTo and
    write.getDestinationAddress() = iFrom
  )
}

/**
 * The reflexive, transitive closure of `addressFlow` that ends as the address of a
 * store or read operation.
 */
cached
predicate addressFlowTC(Instruction iFrom, Instruction iTo) {
  iTo = [getDestinationAddress(_), getSourceAddress(_)] and
  addressFlow*(iFrom, iTo)
}

/**
 * Gets the destination address of `instr` if it is a `StoreInstruction` or
 * a `WriteSideEffectInstruction`.
 */
Instruction getDestinationAddress(Instruction instr) {
  result =
    [
      instr.(StoreInstruction).getDestinationAddress(),
      instr.(WriteSideEffectInstruction).getDestinationAddress()
    ]
}

/** Gets the source address of `instr` if it is an instruction that behaves like a `LoadInstruction`. */
Instruction getSourceAddress(Instruction instr) { result = getSourceAddressOperand(instr).getDef() }

/**
 * Gets the operand that represents the source address of `instr` if it is an
 * instruction that behaves like a `LoadInstruction`.
 */
Operand getSourceAddressOperand(Instruction instr) {
  result =
    [
      instr.(LoadInstruction).getSourceAddressOperand(),
      instr.(ReadSideEffectInstruction).getArgumentOperand()
    ]
}

/**
 * Gets the source address of `node` if it's an instruction or operand that
 * behaves like a `LoadInstruction`.
 */
Instruction getSourceAddressFromNode(Node node) {
  result = getSourceAddress(node.asInstruction())
  or
  result = getSourceAddress(node.asOperand().(SideEffectOperand).getUse())
}

/** Gets the source value of `instr` if it's an instruction that behaves like a `LoadInstruction`. */
Instruction getSourceValue(Instruction instr) { result = getSourceValueOperand(instr).getDef() }

/**
 * Gets the operand that represents the source value of `instr` if it's an instruction
 * that behaves like a `LoadInstruction`.
 */
Operand getSourceValueOperand(Instruction instr) {
  result = instr.(LoadInstruction).getSourceValueOperand()
  or
  result = instr.(ReadSideEffectInstruction).getSideEffectOperand()
}

/**
 * Holds if `instr` is a `StoreInstruction` or a `WriteSideEffectInstruction` that writes to an address.
 * The addresses is computed using `address`, and `certain` is `true` if the write is guaranteed to overwrite
 * the entire variable.
 */
cached
predicate explicitWrite(boolean certain, Instruction instr, Instruction address) {
  exists(StoreInstruction store |
    store = instr and addressFlowTC(address, store.getDestinationAddress())
  |
    // Set `certain = false` if the address is derived from any instructions that prevents us from
    // concluding that the entire variable is overridden.
    if
      addressFlowTC(any(Instruction i |
          i instanceof FieldAddressInstruction or
          i instanceof PointerArithmeticInstruction or
          i instanceof LoadInstruction or
          i instanceof InheritanceConversionInstruction
        ), store.getDestinationAddress())
    then certain = false
    else certain = true
  )
  or
  addressFlowTC(address, instr.(WriteSideEffectInstruction).getDestinationAddress()) and
  certain = false
}

cached
private module Cached {
  private predicate defUseFlow(Node nodeFrom, Node nodeTo) {
    exists(IRBlock bb1, int i1, IRBlock bb2, int i2, DefOrUse defOrUse, Use use |
      defOrUse.hasIndexInBlock(bb1, i1) and
      use.hasIndexInBlock(bb2, i2) and
      adjacentDefRead(_, bb1, i1, bb2, i2) and
      nodeFrom.asInstruction() = toInstruction(defOrUse) and
      flowOutOfAddressStep(use.getOperand(), nodeTo)
    )
  }

  private predicate fromStoreNode(StoreNodeInstr nodeFrom, Node nodeTo) {
    // Def-use flow from a `StoreNode`.
    exists(IRBlock bb1, int i1, IRBlock bb2, int i2, Def def, Use use |
      nodeFrom.isTerminal() and
      def.getInstruction() = nodeFrom.getStoreInstruction() and
      def.hasIndexInBlock(bb1, i1) and
      adjacentDefRead(_, bb1, i1, bb2, i2) and
      use.hasIndexInBlock(bb2, i2) and
      flowOutOfAddressStep(use.getOperand(), nodeTo)
    )
    or
    // This final case is a bit annoying. The write side effect on an expression like `a = new A;` writes
    // to a fresh address returned by `operator new`, and there's no easy way to use the shared SSA
    // library to hook that up to the assignment to `a`. So instead we flow to the _first_ use of the
    // value computed by `operator new` that occurs after `nodeFrom` (to avoid a loop in the
    // dataflow graph).
    exists(WriteSideEffectInstruction write, IRBlock bb, int i1, int i2, Operand op |
      nodeFrom.getInstruction().(CallInstruction).getStaticCallTarget() instanceof
        Alloc::OperatorNewAllocationFunction and
      write = nodeFrom.getStoreInstruction() and
      bb.getInstruction(i1) = write and
      bb.getInstruction(i2) = op.getUse() and
      // Flow to an instruction that occurs later in the block.
      conversionFlow*(nodeFrom.getInstruction(), op.getDef()) and
      nodeTo.asOperand() = op and
      i2 > i1 and
      // There is no previous instruction that also occurs after `nodeFrom`.
      not exists(Instruction instr, int i |
        bb.getInstruction(i) = instr and
        conversionFlow(instr, op.getDef()) and
        i1 < i and
        i < i2
      )
    )
  }

  private predicate fromReadNode(ReadNode nodeFrom, Node nodeTo) {
    exists(IRBlock bb1, int i1, IRBlock bb2, int i2, Use use1, Use use2 |
      use1.hasIndexInBlock(bb1, i1) and
      use2.hasIndexInBlock(bb2, i2) and
      use1.getOperand().getDef() = nodeFrom.getInstruction() and
      adjacentDefRead(_, bb1, i1, bb2, i2) and
      flowOutOfAddressStep(use2.getOperand(), nodeTo)
    )
  }

  private predicate fromPhiNode(SsaPhiNode nodeFrom, Node nodeTo) {
    exists(PhiNode phi, Use use, IRBlock block, int rnk |
      phi = nodeFrom.getPhiNode() and
      adjacentDefRead(phi, _, _, block, rnk) and
      use.hasIndexInBlock(block, rnk) and
      flowOutOfAddressStep(use.getOperand(), nodeTo)
    )
  }

  private predicate toPhiNode(Node nodeFrom, SsaPhiNode nodeTo) {
    // Flow to phi nodes
    exists(Def def, IRBlock block, int rnk |
      def.hasIndexInBlock(block, rnk) and
      nodeTo.hasInputAtRankInBlock(block, rnk)
    |
      exists(StoreNodeInstr storeNode |
        storeNode = nodeFrom and
        storeNode.isTerminal() and
        def.getInstruction() = storeNode.getStoreInstruction()
      )
      or
      def.getInstruction() = nodeFrom.asInstruction()
    )
    or
    // Phi -> phi flow
    nodeTo.hasInputAtRankInBlock(_, _, nodeFrom.(SsaPhiNode).getPhiNode())
  }

  /**
   * Holds if `nodeFrom` is a read or write, and `nTo` is the next subsequent read of the variable
   * written (or read) by `storeOrRead`.
   */
  cached
  predicate ssaFlow(Node nodeFrom, Node nodeTo) {
    // Def-use/use-use flow from an `InstructionNode`.
    defUseFlow(nodeFrom, nodeTo)
    or
    // Def-use flow from a `StoreNode`.
    fromStoreNode(nodeFrom, nodeTo)
    or
    // Use-use flow from a `ReadNode`.
    fromReadNode(nodeFrom, nodeTo)
    or
    fromPhiNode(nodeFrom, nodeTo)
    or
    toPhiNode(nodeFrom, nodeTo)
    or
    // When we want to transfer flow out of a `StoreNode` we perform two steps:
    // 1. Find the next use of the address being stored to
    // 2. Find the `LoadInstruction` that loads the address
    // When the address being stored into doesn't have a `LoadInstruction` associated with it because it's
    // passed into a `CallInstruction` we transfer flow to the `ReadSideEffect`, which will then flow into
    // the callee. We then pickup the flow from the `InitializeIndirectionInstruction` and use the shared
    // SSA library to determine where the next use of the address that received the flow is.
    exists(Node init, Node mid |
      nodeFrom.asInstruction().(InitializeIndirectionInstruction).getIRVariable() =
        init.asInstruction().(InitializeParameterInstruction).getIRVariable() and
      // No need for the flow if the next use is the instruction that returns the flow out of the callee.
      not mid.asInstruction() instanceof ReturnIndirectionInstruction and
      // Find the next use of the address
      ssaFlow(init, mid) and
      // And flow to the next load of that address
      flowOutOfAddressStep([mid.asInstruction().getAUse(), mid.asOperand()], nodeTo)
    )
  }

  /**
   * Holds if `iTo` is a conversion-like instruction that copies
   * the value computed by `iFrom`.
   *
   * This predicate is used by `fromStoreNode` to find the next use of a pointer that
   * points to freshly allocated memory.
   */
  private predicate conversionFlow(Instruction iFrom, Instruction iTo) {
    iTo.(CopyValueInstruction).getSourceValue() = iFrom
    or
    iTo.(ConvertInstruction).getUnary() = iFrom
    or
    iTo.(CheckedConvertOrNullInstruction).getUnary() = iFrom
    or
    iTo.(InheritanceConversionInstruction).getUnary() = iFrom
  }

  pragma[noinline]
  private predicate callTargetHasInputOutput(
    CallInstruction call, DataFlow::FunctionInput input, DataFlow::FunctionOutput output
  ) {
    exists(DataFlow::DataFlowFunction func |
      call.getStaticCallTarget() = func and
      func.hasDataFlow(input, output)
    )
  }

  /**
   * The role of `flowOutOfAddressStep` is to select the node for which we want dataflow to end up in
   * after the shared SSA library's `adjacentDefRead` predicate has determined that `operand` is the
   * next use of some variable.
   *
   * More precisely, this predicate holds if `operand` is an operand that represents an address, and:
   * - `nodeTo` is the next load of that address, or
   * - `nodeTo` is a `ReadNode` that uses the definition of `operand` to start a sequence of reads, or
   * - `nodeTo` is the outer-most `StoreNode` that uses the address represented by `operand`. We obtain
   *    use-use flow in this case since `StoreNodeFlow::flowOutOf` will then provide flow to the next of
   *    of `operand`.
   *
   * There is one final (slightly annoying) case: When `operand` is a an argument to a modeled function
   * without any `ReadSideEffect` (such as `std::move`). Here, the address flows from the argument to
   * the return value, which might then be read later.
   */
  private predicate flowOutOfAddressStep(Operand operand, Node nodeTo) {
    // Flow into a read node
    exists(ReadNode readNode | readNode = nodeTo |
      readNode.isInitial() and
      operand.getDef() = readNode.getInstruction()
    )
    or
    exists(StoreNodeInstr storeNode, Instruction def |
      storeNode = nodeTo and
      def = operand.getDef()
    |
      storeNode.isTerminal() and
      not addressFlow(def, _) and
      // Only transfer flow to a store node if it doesn't immediately overwrite the address
      // we've just written to.
      explicitWrite(false, storeNode.getStoreInstruction(), def)
    )
    or
    // The destination of a store operation has undergone lvalue-to-rvalue conversion and is now a
    // right-hand-side of a store operation.
    // Find the next use of the variable in that store operation, and recursively find the load of that
    // pointer. For example, consider this case:
    //
    // ```cpp
    // int x = source();
    // int* p = &x;
    // sink(*p);
    // ```
    //
    // if we want to find the load of the address of `x`, we see that the pointer is stored into `p`,
    // and we then need to recursively look for the load of `p`.
    exists(
      Def def, StoreInstruction store, IRBlock block1, int rnk1, Use use, IRBlock block2, int rnk2
    |
      store = def.getInstruction() and
      store.getSourceValueOperand() = operand and
      def.hasIndexInBlock(block1, rnk1) and
      use.hasIndexInBlock(block2, rnk2) and
      adjacentDefRead(_, block1, rnk1, block2, rnk2)
    |
      // The shared SSA library has determined that `use` is the next use of the operand
      // so we find the next load of that use (but only if there is no `PostUpdateNode`) we
      // need to flow into first.
      not StoreNodeFlow::flowInto(store, _) and
      flowOutOfAddressStep(use.getOperand(), nodeTo)
      or
      // It may also be the case that `store` gives rise to another store step. So let's make sure that
      // we also take those into account.
      StoreNodeFlow::flowInto(store, nodeTo)
    )
    or
    // As we find the next load of an address, we might come across another use of the same variable.
    // In that case, we recursively find the next use of _that_ operand, and continue searching for
    // the next load of that operand. For example, consider this case:
    //
    // ```cpp
    // int x = source();
    // use(&x);
    // int* p = &x;
    // sink(*p);
    // ```
    //
    // The next use of `x` after its definition is `use(&x)`, but there is a later load of the address
    // of `x` that we want to flow to. So we use the shared SSA library to find the next load.
    not operand = getSourceAddressOperand(_) and
    exists(Use use1, Use use2, IRBlock block1, int rnk1, IRBlock block2, int rnk2 |
      use1.getOperand() = operand and
      use1.hasIndexInBlock(block1, rnk1) and
      // Don't flow to the next use if this use is part of a store operation that totally
      // overrides a variable.
      not explicitWrite(true, _, use1.getOperand().getDef()) and
      adjacentDefRead(_, block1, rnk1, block2, rnk2) and
      use2.hasIndexInBlock(block2, rnk2) and
      flowOutOfAddressStep(use2.getOperand(), nodeTo)
    )
    or
    operand = getSourceAddressOperand(nodeTo.asInstruction())
    or
    exists(ReturnIndirectionInstruction ret |
      ret.getSourceAddressOperand() = operand and
      ret = nodeTo.asInstruction()
    )
    or
    exists(ReturnValueInstruction ret |
      ret.getReturnAddressOperand() = operand and
      nodeTo.asInstruction() = ret
    )
    or
    exists(CallInstruction call, int index, ReadSideEffectInstruction read |
      call.getArgumentOperand(index) = operand and
      read = getSideEffectFor(call, index) and
      nodeTo.asOperand() = read.getSideEffectOperand()
    )
    or
    exists(CopyInstruction copy |
      not exists(getSourceAddressOperand(copy)) and
      copy.getSourceValueOperand() = operand and
      flowOutOfAddressStep(copy.getAUse(), nodeTo)
    )
    or
    exists(ConvertInstruction convert |
      convert.getUnaryOperand() = operand and
      flowOutOfAddressStep(convert.getAUse(), nodeTo)
    )
    or
    exists(CheckedConvertOrNullInstruction convert |
      convert.getUnaryOperand() = operand and
      flowOutOfAddressStep(convert.getAUse(), nodeTo)
    )
    or
    exists(InheritanceConversionInstruction convert |
      convert.getUnaryOperand() = operand and
      flowOutOfAddressStep(convert.getAUse(), nodeTo)
    )
    or
    exists(PointerArithmeticInstruction arith |
      arith.getLeftOperand() = operand and
      flowOutOfAddressStep(arith.getAUse(), nodeTo)
    )
    or
    // Flow through a modeled function that has parameter -> return value flow.
    exists(
      CallInstruction call, int index, DataFlow::FunctionInput input,
      DataFlow::FunctionOutput output
    |
      callTargetHasInputOutput(call, input, output) and
      call.getArgumentOperand(index) = operand and
      not getSideEffectFor(call, index) instanceof ReadSideEffectInstruction and
      input.isParameter(index) and
      output.isReturnValue() and
      flowOutOfAddressStep(call.getAUse(), nodeTo)
    )
  }
}

import Cached

/**
 * Holds if the `i`'th write in block `bb` writes to the variable `v`.
 * `certain` is `true` if the write is guaranteed to overwrite the entire variable.
 */
predicate variableWrite(IRBlock bb, int i, SourceVariable v, boolean certain) {
  DataFlowImplCommon::forceCachingInSameStage() and
  exists(Def def |
    def.hasIndexInBlock(bb, i) and
    v = def.getSourceVariable() and
    (if def.isCertain() then certain = true else certain = false)
  )
}

/**
 * Holds if the `i`'th read in block `bb` reads to the variable `v`.
 * `certain` is `true` if the read is guaranteed. For C++, this is always the case.
 */
predicate variableRead(IRBlock bb, int i, SourceVariable v, boolean certain) {
  exists(Use use |
    use.hasIndexInBlock(bb, i) and
    v = use.getSourceVariable() and
    certain = true
  )
}
