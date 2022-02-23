/**
 * @name Use of expired stack-address
 * @description Accessing the stack-allocated memory of a function
 *              after it has returned can lead to memory corruption.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id cpp/using-expired-stack-address
 * @tags reliability
 *       security
 *       external/cwe/cwe-825
 */

import cpp
import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.ir.IR

predicate instructionHasVariable(VariableAddressInstruction vai, StackVariable var, Function f) {
  var = vai.getASTVariable() and
  f = vai.getEnclosingFunction() and
  // Pointer-to-member types aren't properly handled in the dbscheme.
  not vai.getResultType() instanceof PointerToMemberType and
  // Rule out FPs caused by extraction errors.
  not any(ErrorExpr e).getEnclosingFunction() = f
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
    address = globalValueNumber(any(LoadInstruction load).getSourceAddress())
  } or
  TConversion(string kind, TGlobalAddress address, Type fromType, Type toType) {
    kind = "unchecked" and
    exists(ConvertInstruction convert |
      uncheckedConversionTypes(convert, fromType, toType) and
      address = globalValueNumber(convert.getUnary())
    )
    or
    kind = "checked" and
    exists(CheckedConvertOrNullInstruction convert |
      checkedConversionTypes(convert, fromType, toType) and
      address = globalValueNumber(convert.getUnary())
    )
    or
    kind = "inheritance" and
    exists(InheritanceConversionInstruction convert |
      inheritanceConversionTypes(convert, fromType, toType) and
      address = globalValueNumber(convert.getUnary())
    )
  } or
  TFieldAddress(TGlobalAddress address, Field f) {
    exists(FieldAddressInstruction fai |
      fai.getField() = f and
      address = globalValueNumber(fai.getObjectAddress())
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

/** Gets the HashCons value of an address computed by `instr`, if any. */
TGlobalAddress globalValueNumber(Instruction instr) {
  result = TGlobalVariable(instr.(VariableAddressInstruction).getASTVariable())
  or
  not instr instanceof LoadInstruction and
  result = globalValueNumber(instr.(CopyInstruction).getSourceValue())
  or
  exists(LoadInstruction load | instr = load |
    result = TLoad(globalValueNumber(load.getSourceAddress()))
  )
  or
  exists(ConvertInstruction convert, Type fromType, Type toType | instr = convert |
    uncheckedConversionTypes(convert, fromType, toType) and
    result = TConversion("unchecked", globalValueNumber(convert.getUnary()), fromType, toType)
  )
  or
  exists(CheckedConvertOrNullInstruction convert, Type fromType, Type toType | instr = convert |
    checkedConversionTypes(convert, fromType, toType) and
    result = TConversion("checked", globalValueNumber(convert.getUnary()), fromType, toType)
  )
  or
  exists(InheritanceConversionInstruction convert, Type fromType, Type toType | instr = convert |
    inheritanceConversionTypes(convert, fromType, toType) and
    result = TConversion("inheritance", globalValueNumber(convert.getUnary()), fromType, toType)
  )
  or
  exists(FieldAddressInstruction fai | instr = fai |
    result = TFieldAddress(globalValueNumber(fai.getObjectAddress()), fai.getField())
  )
  or
  result = globalValueNumber(instr.(PointerOffsetInstruction).getLeft())
}

/** Gets a `StoreInstruction` that may be executed after executing `store`. */
pragma[inline]
StoreInstruction getAStoreStrictlyAfter(StoreInstruction store) {
  exists(IRBlock block, int index1, int index2 |
    block.getInstruction(index1) = store and
    block.getInstruction(index2) = result and
    index2 > index1
  )
  or
  exists(IRBlock block1, IRBlock block2 |
    store.getBlock() = block1 and
    result.getBlock() = block2 and
    block1.getASuccessor+() = block2
  )
}

/**
 * Holds if `store` copies the address of `f`'s local variable `var`
 * into the address `globalAddress`.
 */
predicate stackAddressEscapes(
  StoreInstruction store, StackVariable var, TGlobalAddress globalAddress, Function f
) {
  globalAddress = globalValueNumber(store.getDestinationAddress()) and
  exists(VariableAddressInstruction vai |
    instructionHasVariable(pragma[only_bind_into](vai), var, f) and
    stackPointerFlowsToUse(store.getSourceValue(), vai)
  ) and
  // Ensure there's no subsequent store that overrides the global address.
  not globalAddress = globalValueNumber(getAStoreStrictlyAfter(store).getDestinationAddress())
}

predicate blockStoresToAddress(
  IRBlock block, int index, StoreInstruction store, TGlobalAddress globalAddress
) {
  block.getInstruction(index) = store and
  globalAddress = globalValueNumber(store.getDestinationAddress())
}

predicate blockLoadsFromAddress(
  IRBlock block, int index, LoadInstruction load, TGlobalAddress globalAddress
) {
  block.getInstruction(index) = load and
  globalAddress = globalValueNumber(load.getSourceAddress())
}

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
    exists(IRBlock mid |
      mid.immediatelyDominates(block) and
      // Only recurse if there is no store to `globalAddress` in `mid`.
      globalAddressPointsToStack(store, var, call, mid, globalAddress, _, false)
    )
  )
}

from
  StoreInstruction store, StackVariable var, LoadInstruction load, CallInstruction call,
  IRBlock block, boolean isCallBlock, TGlobalAddress address, boolean isStoreBlock
where
  globalAddressPointsToStack(store, var, call, block, address, isCallBlock, isStoreBlock) and
  block.getAnInstruction() = load and
  globalValueNumber(load.getSourceAddress()) = address and
  (
    // We know that we have a sequence:
    // (1) store to `address` -> (2) return from `f` -> (3) load from `address`.
    // But if (2) and (3) happen in the sam block we need to check the
    // block indices to ensure that (3) happens after (2).
    if isCallBlock = true
    then
      // If so, the load must happen after the call.
      exists(int callIndex, int loadIndex |
        blockLoadsFromAddress(_, loadIndex, load, _) and
        block.getInstruction(callIndex) = call and
        callIndex < loadIndex
      )
    else any()
  ) and
  // If there is a store to the address we need to make sure that the load we found was
  // before that store (So that the load doesn't read an overwritten value).
  if isStoreBlock = true
  then
    exists(int storeIndex, int loadIndex |
      blockStoresToAddress(block, storeIndex, _, address) and
      block.getInstruction(loadIndex) = load and
      loadIndex < storeIndex
    )
  else any()
select load, "Stack variable $@ escapes $@ and is used after it has expired.", var, var.toString(),
  store, "here"
