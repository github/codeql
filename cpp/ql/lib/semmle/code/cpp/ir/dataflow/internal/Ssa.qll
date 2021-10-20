import SsaImplCommon
import SsaImplSpecific
private import cpp as Cpp
private import semmle.code.cpp.ir.IR
private import DataFlowUtil
private import DataFlowPrivate
private import semmle.code.cpp.models.interfaces.Allocation as Alloc
private import semmle.code.cpp.models.interfaces.DataFlow as DataFlow

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

pragma[nomagic]
private int getRank(DefOrUse defOrUse, IRBlock block) {
  defOrUse =
    rank[result](int i, DefOrUse cand |
      block.getInstruction(i) = toInstruction(cand)
    |
      cand order by i
    )
}

private class DefOrUse extends TDefOrUse {
  /** Gets the instruction associated with this definition, if any. */
  Instruction asDef() { none() }

  /** Gets the operand associated with this use, if any. */
  Operand asUse() { none() }

  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the block of this definition or use. */
  abstract IRBlock getBlock();

  /** Holds if this definition or use has rank `rank` in block `block`. */
  cached
  final predicate hasRankInBlock(IRBlock block, int rnk) {
    block = getBlock() and
    rnk = getRank(this, block)
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  abstract predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  );
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
  abstract SourceVariable getVariable();

  /** Holds if this definition is guaranteed to happen. */
  abstract predicate isCertain();

  override Instruction asDef() { result = this.getInstruction() }

  override string toString() { result = "Def" }

  override IRBlock getBlock() { result = this.getInstruction().getBlock() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    store.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class ExplicitDef extends Def, TExplicitDef {
  ExplicitDef() { this = TExplicitDef(store) }

  override SourceVariable getVariable() {
    exists(VariableInstruction var |
      explicitWrite(_, this.getInstruction(), var) and
      result.getVariable() = var.getIRVariable() and
      not result.isIndirection()
    )
  }

  override predicate isCertain() { explicitWrite(true, this.getInstruction(), _) }
}

private class ParameterDef extends Def, TInitializeParam {
  ParameterDef() { this = TInitializeParam(store) }

  override SourceVariable getVariable() {
    result.getVariable() = store.(InitializeParameterInstruction).getIRVariable() and
    not result.isIndirection()
    or
    result.getVariable() = store.(InitializeIndirectionInstruction).getIRVariable() and
    result.isIndirection()
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
  abstract SourceVariable getVariable();

  override IRBlock getBlock() { result = use.getUse().getBlock() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    use.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class ExplicitUse extends Use, TExplicitUse {
  ExplicitUse() { this = TExplicitUse(use) }

  override SourceVariable getVariable() {
    exists(VariableInstruction var |
      use.getDef() = var and
      result.getVariable() = var.getIRVariable() and
      (
        if use.getUse() instanceof ReadSideEffectInstruction
        then result.isIndirection()
        else not result.isIndirection()
      )
    )
  }
}

private class ReturnParameterIndirection extends Use, TReturnParamIndirection {
  ReturnParameterIndirection() { this = TReturnParamIndirection(use) }

  override SourceVariable getVariable() {
    exists(ReturnIndirectionInstruction ret |
      returnParameterIndirection(use, ret) and
      result.getVariable() = ret.getIRVariable() and
      result.isIndirection()
    )
  }
}

private predicate isExplicitUse(Operand op) {
  op.getDef() instanceof VariableAddressInstruction and
  not exists(LoadInstruction load |
    load.getSourceAddressOperand() = op and
    load.getAUse().getUse() instanceof InitializeIndirectionInstruction
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
  iTo.(LoadInstruction).getSourceAddress() = iFrom
  or
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
 * a `WriteSideEffectInstruction`. The destination address of a `WriteSideEffectInstruction` is adjusted
 * in the case of calls to operator `new` to give the destination address of a subsequent store (if any).
 */
Instruction getDestinationAddress(Instruction instr) {
  result =
    [
      instr.(StoreInstruction).getDestinationAddress(),
      instr.(WriteSideEffectInstruction).getDestinationAddress()
    ]
}

class ReferenceToInstruction extends CopyValueInstruction {
  ReferenceToInstruction() {
    this.getResultType() instanceof Cpp::ReferenceType and
    not this.getUnary().getResultType() instanceof Cpp::ReferenceType
  }

  Instruction getSourceAddress() { result = getSourceAddressOperand().getDef() }

  Operand getSourceAddressOperand() { result = this.getUnaryOperand() }
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
      instr.(ReadSideEffectInstruction).getArgumentOperand(),
      instr.(ReferenceToInstruction).getSourceAddressOperand()
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
  or
  result = instr.(ReferenceToInstruction).getSourceValueOperand()
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
    if
      addressFlowTC(any(Instruction i |
          i instanceof FieldAddressInstruction or i instanceof PointerArithmeticInstruction
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
      defOrUse.hasRankInBlock(bb1, i1) and
      use.hasRankInBlock(bb2, i2) and
      adjacentDefRead(_, bb1, i1, bb2, i2) and
      nodeFrom.asInstruction() = toInstruction(defOrUse) and
      flowOutOfAddressStep(use.getOperand(), nodeTo)
    )
  }

  private predicate fromStoreNode(StoreNode nodeFrom, Node nodeTo) {
    // Def-use flow from a `StoreNode`.
    exists(IRBlock bb1, int i1, IRBlock bb2, int i2, Def def, Use use |
      nodeFrom.isTerminal() and
      def.getInstruction() = nodeFrom.getStoreInstruction() and
      def.hasRankInBlock(bb1, i1) and
      adjacentDefRead(_, bb1, i1, bb2, i2) and
      use.hasRankInBlock(bb2, i2) and
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
      valueFlow*(nodeFrom.getInstruction(), op.getDef()) and
      nodeTo.asOperand() = op and
      i2 > i1 and
      // There is no previous instruction that also occurs after `nodeFrom`.
      not exists(Instruction instr, int i |
        bb.getInstruction(i) = instr and
        valueFlow(instr, op.getDef()) and
        i1 < i and
        i < i2
      )
    )
  }

  private predicate fromReadNode(ReadNode nodeFrom, Node nodeTo) {
    exists(IRBlock bb1, int i1, IRBlock bb2, int i2, Use use1, Use use2 |
      use1.hasRankInBlock(bb1, i1) and
      use2.hasRankInBlock(bb2, i2) and
      use1.getOperand().getDef() = nodeFrom.getInstruction() and
      adjacentDefRead(_, bb1, i1, bb2, i2) and
      flowOutOfAddressStep(use2.getOperand(), nodeTo)
    )
  }

  private predicate fromPhiNode(SsaPhiNode nodeFrom, Node nodeTo) {
    exists(PhiNode phi, Use use, IRBlock block, int rnk |
      phi = nodeFrom.getPhiNode() and
      adjacentDefRead(phi, _, _, block, rnk) and
      use.hasRankInBlock(block, rnk) and
      flowOutOfAddressStep(use.getOperand(), nodeTo)
    )
  }

  private predicate toPhiNode(Node nodeFrom, SsaPhiNode nodeTo) {
    // Flow to phi nodes
    exists(Def def, IRBlock block, int rnk |
      def.hasRankInBlock(block, rnk) and
      nodeTo.hasInputAtRankInBlock(block, rnk)
    |
      exists(StoreNode store |
        store = nodeFrom and
        store.isTerminal() and
        def.getInstruction() = store.getStoreInstruction()
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
    // Def-use/use-use flow from an `InstructionNode` to an `OperandNode`.
    defUseFlow(nodeFrom, nodeTo)
    or
    // Def-use flow from a `StoreNode` to an `OperandNode`.
    fromStoreNode(nodeFrom, nodeTo)
    or
    // Use-use flow from a `ReadNode` to an `OperandNode`
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

  private predicate valueFlow(Instruction iFrom, Instruction iTo) {
    iTo.(CopyValueInstruction).getSourceValue() = iFrom
    or
    iTo.(ConvertInstruction).getUnary() = iFrom
    or
    iTo.(CheckedConvertOrNullInstruction).getUnary() = iFrom
    or
    iTo.(InheritanceConversionInstruction).getUnary() = iFrom
  }

  private predicate flowOutOfAddressStep(Operand operand, Node nTo) {
    // Flow into a read node
    exists(ReadNode readNode | readNode = nTo |
      readNode.isInitial() and
      operand.getDef() = readNode.getInstruction()
    )
    or
    exists(StoreNode storeNode, Instruction def |
      storeNode = nTo and
      def = operand.getDef()
    |
      storeNode.isTerminal() and
      not addressFlow(def, _) and
      // Only transfer flow to a store node if it doesn't immediately overwrite the address
      // we've just written to.
      explicitWrite(false, storeNode.getStoreInstruction(), def)
    )
    or
    operand = getSourceAddressOperand(nTo.asInstruction())
    or
    exists(ReturnIndirectionInstruction ret |
      ret.getSourceAddressOperand() = operand and
      ret = nTo.asInstruction()
    )
    or
    exists(ReturnValueInstruction ret |
      ret.getReturnAddressOperand() = operand and
      nTo.asInstruction() = ret
    )
    or
    exists(CallInstruction call, int index, ReadSideEffectInstruction read |
      call.getArgumentOperand(index) = operand and
      read = getSideEffectFor(call, index) and
      nTo.asOperand() = read.getSideEffectOperand()
    )
    or
    exists(CopyInstruction copy |
      not exists(getSourceAddressOperand(copy)) and
      copy.getSourceValueOperand() = operand and
      flowOutOfAddressStep(copy.getAUse(), nTo)
    )
    or
    exists(ConvertInstruction convert |
      convert.getUnaryOperand() = operand and
      flowOutOfAddressStep(convert.getAUse(), nTo)
    )
    or
    exists(CheckedConvertOrNullInstruction convert |
      convert.getUnaryOperand() = operand and
      flowOutOfAddressStep(convert.getAUse(), nTo)
    )
    or
    exists(InheritanceConversionInstruction convert |
      convert.getUnaryOperand() = operand and
      flowOutOfAddressStep(convert.getAUse(), nTo)
    )
    or
    exists(PointerArithmeticInstruction arith |
      arith.getLeftOperand() = operand and
      flowOutOfAddressStep(arith.getAUse(), nTo)
    )
    or
    // Flow through a modelled function that has parameter -> return value flow.
    exists(
      CallInstruction call, DataFlow::DataFlowFunction func, int index,
      DataFlow::FunctionInput input, DataFlow::FunctionOutput output
    |
      call.getStaticCallTarget() = func and
      call.getArgumentOperand(index) = operand and
      not getSideEffectFor(call, index) instanceof ReadSideEffectInstruction and
      func.hasDataFlow(input, output) and
      input.isParameter(index) and
      output.isReturnValue() and
      flowOutOfAddressStep(call.getAUse(), nTo)
    )
  }
}

import Cached
