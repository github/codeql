/**
 * @name Use of expired stack-address
 * @description Accessing the stack-allocated memory of a function
 *              after it has returned can lead to memory corruption.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id cpp/using-expired-stack-address
 * @tags reliability
 *       security
 *       external/cwe/cwe-825
 */

import cpp
// We don't actually use the global value numbering library in this query, but without it we end up
// recomputing the IR.
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.ir.IR

predicate instructionHasVariable(VariableAddressInstruction vai, StackVariable var, Function f) {
  var = vai.getAstVariable() and
  f = vai.getEnclosingFunction() and
  // Pointer-to-member types aren't properly handled in the dbscheme.
  not vai.getResultType() instanceof PointerToMemberType and
  // Rule out FPs caused by extraction errors.
  not f.hasErrors()
}

/**
 * Holds if `source` is the base address of an address computation whose
 * result is stored in `address`.
 */
predicate stackPointerFlowsToUse(Instruction address, VariableAddressInstruction source) {
  address = source and
  instructionHasVariable(source, _, _)
  or
  stackPointerFlowsToUse(address.(CopyInstruction).getSourceValue(), source)
  or
  stackPointerFlowsToUse(address.(ConvertInstruction).getUnary(), source)
  or
  stackPointerFlowsToUse(address.(CheckedConvertOrNullInstruction).getUnary(), source)
  or
  stackPointerFlowsToUse(address.(InheritanceConversionInstruction).getUnary(), source)
  or
  stackPointerFlowsToUse(address.(FieldAddressInstruction).getObjectAddress(), source)
  or
  stackPointerFlowsToUse(address.(PointerOffsetInstruction).getLeft(), source)
}

/**
 * A HashCons-like table for comparing addresses that are
 * computed relative to some global variable.
 */
newtype TGlobalAddress =
  TGlobalVariable(GlobalOrNamespaceVariable v) {
    // Pointer-to-member types aren't properly handled in the dbscheme.
    not v.getUnspecifiedType() instanceof PointerToMemberType
  } or
  TLoad(TGlobalAddress address) {
    address = globalAddress(any(LoadInstruction load).getSourceAddress())
  } or
  TConversion(string kind, TGlobalAddress address, Type fromType, Type toType) {
    kind = "unchecked" and
    exists(ConvertInstruction convert |
      uncheckedConversionTypes(convert, fromType, toType) and
      address = globalAddress(convert.getUnary())
    )
    or
    kind = "checked" and
    exists(CheckedConvertOrNullInstruction convert |
      checkedConversionTypes(convert, fromType, toType) and
      address = globalAddress(convert.getUnary())
    )
    or
    kind = "inheritance" and
    exists(InheritanceConversionInstruction convert |
      inheritanceConversionTypes(convert, fromType, toType) and
      address = globalAddress(convert.getUnary())
    )
  } or
  TFieldAddress(TGlobalAddress address, Field f) {
    exists(FieldAddressInstruction fai |
      fai.getField() = f and
      address = globalAddress(fai.getObjectAddress())
    )
  }

pragma[noinline]
predicate uncheckedConversionTypes(ConvertInstruction convert, Type fromType, Type toType) {
  fromType = convert.getUnary().getResultType() and
  toType = convert.getResultType()
}

pragma[noinline]
predicate checkedConversionTypes(CheckedConvertOrNullInstruction convert, Type fromType, Type toType) {
  fromType = convert.getUnary().getResultType() and
  toType = convert.getResultType()
}

pragma[noinline]
predicate inheritanceConversionTypes(
  InheritanceConversionInstruction convert, Type fromType, Type toType
) {
  fromType = convert.getUnary().getResultType() and
  toType = convert.getResultType()
}

private signature class ConversionInstruction extends UnaryInstruction;

module Conversion<ConversionInstruction I> {
  signature predicate hasTypes(I instr, Type fromType, Type toType);

  module Using<hasTypes/3 project> {
    pragma[nomagic]
    predicate hasOperandAndTypes(I convert, Instruction unary, Type fromType, Type toType) {
      project(convert, fromType, toType) and
      unary = convert.getUnary()
    }
  }
}

pragma[nomagic]
predicate hasObjectAndField(FieldAddressInstruction fai, Instruction object, Field f) {
  fai.getObjectAddress() = object and
  fai.getField() = f
}

/** Gets the HashCons value of an address computed by `instr`, if any. */
TGlobalAddress globalAddress(Instruction instr) {
  result = TGlobalVariable(instr.(VariableAddressInstruction).getAstVariable())
  or
  not instr instanceof LoadInstruction and
  result = globalAddress(instr.(CopyInstruction).getSourceValue())
  or
  exists(LoadInstruction load | instr = load |
    result = TLoad(globalAddress(load.getSourceAddress()))
  )
  or
  exists(Type fromType, Type toType, Instruction unary |
    Conversion<ConvertInstruction>::Using<uncheckedConversionTypes/3>::hasOperandAndTypes(instr,
      unary, fromType, toType) and
    result = TConversion("unchecked", globalAddress(unary), fromType, toType)
  )
  or
  exists(Type fromType, Type toType, Instruction unary |
    Conversion<CheckedConvertOrNullInstruction>::Using<checkedConversionTypes/3>::hasOperandAndTypes(instr,
      unary, fromType, toType) and
    result = TConversion("checked", globalAddress(unary), fromType, toType)
  )
  or
  exists(Type fromType, Type toType, Instruction unary |
    Conversion<InheritanceConversionInstruction>::Using<inheritanceConversionTypes/3>::hasOperandAndTypes(instr,
      unary, fromType, toType) and
    result = TConversion("inheritance", globalAddress(unary), fromType, toType)
  )
  or
  exists(FieldAddressInstruction fai, Instruction object, Field f | instr = fai |
    hasObjectAndField(fai, object, f) and
    result = TFieldAddress(globalAddress(object), f)
  )
  or
  result = globalAddress(instr.(PointerOffsetInstruction).getLeft())
}

/**
 * Gets a first `StoreInstruction` that writes to address `globalAddress` reachable
 * from `block`.
 */
StoreInstruction getFirstStore(IRBlock block, TGlobalAddress globalAddress) {
  1 = getStoreRank(result, block, globalAddress)
  or
  not exists(getStoreRank(_, block, globalAddress)) and
  result = getFirstStore(block.getASuccessor(), globalAddress)
}

/**
 * Gets the rank of `store` in block `block` (i.e., a rank of `1` means that it is the
 * first `store` to write to `globalAddress`, a rank of `2` means it's the second, etc.)
 */
int getStoreRank(StoreInstruction store, IRBlock block, TGlobalAddress globalAddress) {
  blockStoresToAddress(block, _, store, globalAddress) and
  store =
    rank[result](StoreInstruction anotherStore, int i |
      blockStoresToAddress(_, i, anotherStore, globalAddress)
    |
      anotherStore order by i
    )
}

/**
 * Gets a next subsequent `StoreInstruction` to write to `globalAddress`
 * after `store` has done so.
 */
StoreInstruction getANextStoreTo(StoreInstruction store, TGlobalAddress globalAddress) {
  exists(IRBlock block, int rnk |
    rnk = getStoreRank(store, block, globalAddress) and
    rnk + 1 = getStoreRank(result, block, globalAddress)
  )
  or
  exists(IRBlock block, int rnk, IRBlock succ |
    rnk = getStoreRank(store, block, globalAddress) and
    not rnk + 1 = getStoreRank(_, block, globalAddress) and
    succ = block.getASuccessor() and
    result = getFirstStore(succ, globalAddress)
  )
}

/**
 * Holds if `store` copies the address of `f`'s local variable `var`
 * into the address `globalAddress`.
 */
predicate stackAddressEscapes(
  StoreInstruction store, StackVariable var, TGlobalAddress globalAddress, Function f
) {
  globalAddress = globalAddress(store.getDestinationAddress()) and
  exists(VariableAddressInstruction vai |
    instructionHasVariable(pragma[only_bind_into](vai), var, f) and
    stackPointerFlowsToUse(store.getSourceValue(), vai)
  ) and
  // Ensure there's no subsequent store that overrides the global address.
  not exists(getANextStoreTo(store, globalAddress))
}

predicate blockStoresToAddress(
  IRBlock block, int index, StoreInstruction store, TGlobalAddress globalAddress
) {
  block.getInstruction(index) = store and
  globalAddress = globalAddress(store.getDestinationAddress())
}

/**
 * Holds if `globalAddress` evaluates to the address of `var` (which escaped through `store` before
 * returning through `call`) when control reaches `block`.
 */
predicate globalAddressPointsToStack(
  StoreInstruction store, StackVariable var, CallInstruction call, IRBlock block,
  TGlobalAddress globalAddress, boolean isCallBlock, boolean isStoreBlock
) {
  (
    if blockStoresToAddress(block, _, _, globalAddress)
    then isStoreBlock = true
    else isStoreBlock = false
  ) and
  (
    isCallBlock = true and
    exists(Function f |
      stackAddressEscapes(store, var, globalAddress, f) and
      call.getStaticCallTarget() = f and
      call.getBlock() = block
    )
    or
    isCallBlock = false and
    step(store, var, call, globalAddress, _, block)
  )
}

pragma[inline]
int getInstructionIndex(Instruction instr, IRBlock block) { block.getInstruction(result) = instr }

predicate step(
  StoreInstruction store, StackVariable var, CallInstruction call, TGlobalAddress globalAddress,
  IRBlock pred, IRBlock succ
) {
  exists(boolean isCallBlock, boolean isStoreBlock |
    // Only recurse if there is no store to `globalAddress` in `mid`.
    globalAddressPointsToStack(store, var, call, pred, globalAddress, isCallBlock, isStoreBlock)
  |
    // Post domination ensures that `block` is always executed after `mid`
    // Domination ensures that `mid` is always executed before `block`
    isStoreBlock = false and
    succ.immediatelyPostDominates(pred) and
    pred.immediatelyDominates(succ)
    or
    exists(CallInstruction anotherCall, int anotherCallIndex |
      anotherCall = pred.getInstruction(anotherCallIndex) and
      succ.getFirstInstruction() instanceof EnterFunctionInstruction and
      succ.getEnclosingFunction() = anotherCall.getStaticCallTarget() and
      (if isCallBlock = true then getInstructionIndex(call, _) < anotherCallIndex else any()) and
      (
        if isStoreBlock = true
        then
          forex(int storeIndex | blockStoresToAddress(pred, storeIndex, _, globalAddress) |
            anotherCallIndex < storeIndex
          )
        else any()
      )
    )
  )
}

newtype TPathElement =
  TStore(StoreInstruction store) { globalAddressPointsToStack(store, _, _, _, _, _, _) } or
  TCall(CallInstruction call, IRBlock block) {
    globalAddressPointsToStack(_, _, call, block, _, _, _)
  } or
  TMid(IRBlock block) { step(_, _, _, _, _, block) } or
  TSink(LoadInstruction load, IRBlock block) {
    exists(TGlobalAddress address |
      globalAddressPointsToStack(_, _, _, block, address, _, _) and
      block.getAnInstruction() = load and
      globalAddress(load.getSourceAddress()) = address
    )
  }

class PathElement extends TPathElement {
  StoreInstruction asStore() { this = TStore(result) }

  CallInstruction asCall(IRBlock block) { this = TCall(result, block) }

  predicate isCall(IRBlock block) { exists(this.asCall(block)) }

  IRBlock asMid() { this = TMid(result) }

  LoadInstruction asSink(IRBlock block) { this = TSink(result, block) }

  predicate isSink(IRBlock block) { exists(this.asSink(block)) }

  string toString() {
    result =
      [
        this.asStore().toString(), this.asCall(_).toString(), this.asMid().toString(),
        this.asSink(_).toString()
      ]
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asStore()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    this.asCall(_)
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    this.asMid().getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    this.asSink(_)
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

predicate isSink(LoadInstruction load, IRBlock block, int index, TGlobalAddress globalAddress) {
  block.getInstruction(index) = load and
  globalAddress(load.getSourceAddress()) = globalAddress
}

query predicate edges(PathElement pred, PathElement succ) {
  // Store -> caller
  globalAddressPointsToStack(pred.asStore(), _, succ.asCall(_), _, _, _, _)
  or
  // Call -> basic block
  pred.isCall(succ.asMid())
  or
  // Special case for when the caller goes directly to the load with no steps
  // across basic blocks (i.e., caller -> sink)
  exists(IRBlock block |
    pred.isCall(block) and
    succ.isSink(block)
  )
  or
  // Basic block -> basic block
  step(_, _, _, _, pred.asMid(), succ.asMid())
  or
  // Basic block -> load
  succ.isSink(pred.asMid())
}

from
  StoreInstruction store, StackVariable var, LoadInstruction load, CallInstruction call,
  IRBlock block, boolean isCallBlock, TGlobalAddress address, boolean isStoreBlock,
  PathElement source, PathElement sink, int loadIndex
where
  globalAddressPointsToStack(store, var, call, block, address, isCallBlock, isStoreBlock) and
  isSink(load, block, loadIndex, address) and
  (
    // We know that we have a sequence:
    // (1) store to `address` -> (2) return from `f` -> (3) load from `address`.
    // But if (2) and (3) happen in the sam block we need to check the
    // block indices to ensure that (3) happens after (2).
    if isCallBlock = true
    then
      // If so, the load must happen after the call.
      getInstructionIndex(call, _) < loadIndex
    else any()
  ) and
  (
    // If there is a store to the address we need to make sure that the load we found was
    // before that store (So that the load doesn't read an overwritten value).
    if isStoreBlock = true
    then
      forex(int storeIndex | blockStoresToAddress(block, storeIndex, _, address) |
        loadIndex < storeIndex
      )
    else any()
  ) and
  source.asStore() = store and
  sink.asSink(_) = load
select sink, source, sink, "Stack variable $@ escapes at $@ and is used after it has expired.", var,
  var.toString(), store, "this store"
