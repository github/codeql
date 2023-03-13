import cpp as Cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.internal.IRCppLanguage
private import semmle.code.cpp.ir.implementation.raw.internal.SideEffects as SideEffects
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowUtil
private import semmle.code.cpp.models.interfaces.PointerWrapper
private import DataFlowPrivate

/**
 * Holds if `operand` is an operand that is not used by the dataflow library.
 * Ignored operands are not recognized as uses by SSA, and they don't have a
 * corresponding `(Indirect)OperandNode`.
 */
predicate ignoreOperand(Operand operand) {
  operand = any(Instruction instr | ignoreInstruction(instr)).getAnOperand() or
  operand = any(Instruction instr | ignoreInstruction(instr)).getAUse() or
  operand instanceof MemoryOperand
}

/**
 * Holds if `instr` is an instruction that is not used by the dataflow library.
 * Ignored instructions are not recognized as reads/writes by SSA, and they
 * don't have a corresponding `(Indirect)InstructionNode`.
 */
predicate ignoreInstruction(Instruction instr) {
  DataFlowImplCommon::forceCachingInSameStage() and
  (
    instr instanceof WriteSideEffectInstruction or
    instr instanceof PhiInstruction or
    instr instanceof ReadSideEffectInstruction or
    instr instanceof ChiInstruction or
    instr instanceof InitializeIndirectionInstruction or
    instr instanceof AliasedDefinitionInstruction or
    instr instanceof InitializeNonLocalInstruction or
    instr instanceof ReturnIndirectionInstruction
  )
}

/**
 * Gets the C++ type of `this` in the member function `f`.
 * The result is a glvalue if `isGLValue` is true, and
 * a prvalue if `isGLValue` is false.
 */
bindingset[isGLValue]
private CppType getThisType(Cpp::MemberFunction f, boolean isGLValue) {
  result.hasType(f.getTypeOfThis(), isGLValue)
}

/**
 * Gets the C++ type of the instruction `i`.
 *
 * This is equivalent to `i.getResultLanguageType()` with the exception
 * of instructions that directly references a `this` IRVariable. In this
 * case, `i.getResultLanguageType()` gives an unknown type, whereas the
 * predicate gives the expected type (i.e., a potentially cv-qualified
 * type `A*` where `A` is the declaring type of the member function that
 * contains `i`).
 */
cached
CppType getResultLanguageType(Instruction i) {
  if i.(VariableAddressInstruction).getIRVariable() instanceof IRThisVariable
  then
    if i.isGLValue()
    then result = getThisType(i.getEnclosingFunction(), true)
    else result = getThisType(i.getEnclosingFunction(), false)
  else result = i.getResultLanguageType()
}

/**
 * Gets the C++ type of the operand `operand`.
 * This is equivalent to the type of the operand's defining instruction.
 *
 * See `getResultLanguageType` for a description of this behavior.
 */
CppType getLanguageType(Operand operand) { result = getResultLanguageType(operand.getDef()) }

/**
 * Gets the maximum number of indirections a glvalue of type `type` can have.
 * For example:
 * - If `type = int`, the result is 1
 * - If `type = MyStruct`, the result is 1
 * - If `type = char*`, the result is 2
 */
int getMaxIndirectionsForType(Type type) {
  result = countIndirectionsForCppType(getTypeForGLValue(type))
}

private class PointerOrArrayOrReferenceType extends Cpp::DerivedType {
  PointerOrArrayOrReferenceType() {
    this instanceof Cpp::PointerType
    or
    this instanceof Cpp::ArrayType
    or
    this instanceof Cpp::ReferenceType
  }
}

/**
 * Gets the maximum number of indirections a value of type `type` can have.
 *
 * Note that this predicate is intended to be called on unspecified types
 * (i.e., `countIndirections(e.getUnspecifiedType())`).
 */
private int countIndirections(Type t) {
  // We special case void pointers because we don't know how many indirections
  // they really have. In a Glorious Future we could do a pre-analysis to figure out
  // which kinds of values flows into the type and use the maximum number of
  // indirections flowinginto the type.
  if t instanceof Cpp::VoidPointerType
  then result = 2
  else (
    result = any(Indirection ind | ind.getType() = t).getNumberOfIndirections()
    or
    not exists(Indirection ind | ind.getType() = t) and
    result = 0
  )
}

/**
 * Gets the maximum number of indirections a value of C++
 * type `langType` can have.
 */
int countIndirectionsForCppType(LanguageType langType) {
  exists(Type type | langType.hasType(type, true) |
    result = 1 + countIndirections(type.getUnspecifiedType())
  )
  or
  exists(Type type | langType.hasType(type, false) |
    result = countIndirections(type.getUnspecifiedType())
  )
}

/**
 * A `CallInstruction` that calls an allocation function such
 * as `malloc` or `operator new`.
 */
class AllocationInstruction extends CallInstruction {
  AllocationInstruction() { this.getStaticCallTarget() instanceof Cpp::AllocationFunction }
}

/**
 * An abstract class for handling indirections.
 *
 * Extend this class to make a type behave as a pointer for the
 * purposes of dataflow.
 */
abstract class Indirection extends Type {
  Type baseType;

  /** Gets the type of this indirection. */
  final Type getType() { result = this }

  /**
   * Gets the number of indirections supported by this type.
   *
   * For example, the number of indirections of a variable `p` of type
   * `int**` is `3` (i.e., `p`, `*p` and `**p`).
   */
  abstract int getNumberOfIndirections();

  /**
   * Holds if `deref` is an instruction that behaves as a `LoadInstruction`
   * that loads the value computed by `address`.
   */
  predicate isAdditionalDereference(Instruction deref, Operand address) { none() }

  /**
   * Holds if `value` is written to the address computed by `address`.
   *
   * `certain` is `true` if this write is guaranteed to write to the address.
   */
  predicate isAdditionalWrite(Node0Impl value, Operand address, boolean certain) { none() }

  /**
   * Gets the base type of this indirection, after specifiers have been deeply
   * stripped and typedefs have been resolved.
   *
   * For example, the base type of `int*&` is `int*`, and the base type of `int*` is `int`.
   */
  final Type getBaseType() { result = baseType }

  /** Holds if there should be an additional taint step from `node1` to `node2`. */
  predicate isAdditionalTaintStep(Node node1, Node node2) { none() }

  /**
   * Holds if the step from `opFrom` to `instrTo` should be considered a conversion
   * from `opFrom` to `instrTo`.
   */
  predicate isAdditionalConversionFlow(Operand opFrom, Instruction instrTo) { none() }
}

private class PointerOrArrayOrReferenceTypeIndirection extends Indirection instanceof PointerOrArrayOrReferenceType
{
  PointerOrArrayOrReferenceTypeIndirection() {
    baseType = PointerOrArrayOrReferenceType.super.getBaseType()
  }

  override int getNumberOfIndirections() {
    result = 1 + countIndirections(this.getBaseType().getUnspecifiedType())
  }
}

private class PointerWrapperTypeIndirection extends Indirection instanceof PointerWrapper {
  PointerWrapperTypeIndirection() { baseType = PointerWrapper.super.getBaseType() }

  override int getNumberOfIndirections() {
    result = 1 + countIndirections(this.getBaseType().getUnspecifiedType())
  }

  override predicate isAdditionalDereference(Instruction deref, Operand address) {
    exists(CallInstruction call |
      operandForFullyConvertedCall(getAUse(deref), call) and
      this = call.getStaticCallTarget().getClassAndName("operator*") and
      address = call.getThisArgumentOperand()
    )
  }
}

private module IteratorIndirections {
  import semmle.code.cpp.models.interfaces.Iterator as Interfaces
  import semmle.code.cpp.models.implementations.Iterator as Iterator
  import semmle.code.cpp.models.implementations.StdContainer as StdContainer

  class IteratorIndirection extends Indirection instanceof Interfaces::Iterator {
    IteratorIndirection() {
      not this instanceof PointerOrArrayOrReferenceTypeIndirection and
      baseType = super.getValueType()
    }

    override int getNumberOfIndirections() {
      result = 1 + countIndirections(this.getBaseType().getUnspecifiedType())
    }

    override predicate isAdditionalDereference(Instruction deref, Operand address) {
      exists(CallInstruction call |
        operandForFullyConvertedCall(getAUse(deref), call) and
        this = call.getStaticCallTarget().getClassAndName("operator*") and
        address = call.getThisArgumentOperand()
      )
    }

    override predicate isAdditionalWrite(Node0Impl value, Operand address, boolean certain) {
      exists(CallInstruction call | call.getArgumentOperand(0) = value.asOperand() |
        this = call.getStaticCallTarget().getClassAndName("operator=") and
        address = call.getThisArgumentOperand() and
        certain = false
      )
    }

    override predicate isAdditionalTaintStep(Node node1, Node node2) {
      exists(CallInstruction call |
        // Taint through `operator+=` and `operator-=` on iterators.
        call.getStaticCallTarget() instanceof Iterator::IteratorAssignArithmeticOperator and
        node2.(IndirectArgumentOutNode).getPreUpdateNode() = node1 and
        node1.(IndirectOperand).getOperand() = call.getArgumentOperand(0) and
        node1.getType().getUnspecifiedType() = this
      )
    }

    override predicate isAdditionalConversionFlow(Operand opFrom, Instruction instrTo) {
      // This is a bit annoying: Consider the following snippet:
      // ```
      // struct MyIterator {
      //       ...
      //       insert_iterator_by_trait operator*();
      //       insert_iterator_by_trait operator=(int x);
      //   };
      // ...
      // MyIterator it;
      // ...
      // *it = source();
      // ```
      // The qualifier to `operator*` will undergo prvalue-to-xvalue conversion and a
      // temporary object will be created. Thus, the IR for the call to `operator=` will
      // look like (simplified):
      // ```
      // r1(glval<MyIterator>) = VariableAddress[it]        :
      // r2(glval<unknown>)    = FunctionAddress[operator*] :
      // r3(MyIterator)        = Call[operator*]            : func:r2, this:r1
      // r4(glval<MyIterator>) = VariableAddress[#temp]     :
      // m1(MyIterator)        = Store[#temp]               : &:r4, r3
      // r5(glval<unknown>)    = FunctionAddress[operator=] :
      // r6(glval<unknown>)    = FunctionAddress[source]    :
      // r7(int)               = Call[source]               : func:r6
      // r8(MyIterator)        = Call[operator=]            : func:r5, this:r4, 0:r7
      // ```
      // in order to properly recognize that the qualifier to the call to `operator=` accesses
      // `it` we look for the store that writes to the temporary object, and use the source value
      // of that store as the "address" to continue searching for the base variable `it`.
      exists(StoreInstruction store, VariableInstruction var |
        var = instrTo and
        var.getIRVariable() instanceof IRTempVariable and
        opFrom.getType() = this and
        store.getSourceValueOperand() = opFrom and
        store.getDestinationAddress() = var
      )
      or
      // A call to `operator++` or `operator--` is the iterator equivalent version of a
      // pointer arithmetic instruction.
      exists(CallInstruction call |
        instrTo = call and
        call.getStaticCallTarget() instanceof Iterator::IteratorCrementMemberOperator and
        opFrom = call.getThisArgumentOperand()
      )
    }
  }
}

predicate isDereference(Instruction deref, Operand address) {
  any(Indirection ind).isAdditionalDereference(deref, address)
  or
  deref.(LoadInstruction).getSourceAddressOperand() = address
}

predicate isWrite(Node0Impl value, Operand address, boolean certain) {
  any(Indirection ind).isAdditionalWrite(value, address, certain)
  or
  certain = true and
  (
    exists(StoreInstruction store |
      value.asInstruction() = store and
      address = store.getDestinationAddressOperand()
    )
    or
    exists(InitializeParameterInstruction init |
      value.asInstruction() = init and
      address = init.getAnOperand()
    )
    or
    exists(InitializeDynamicAllocationInstruction init |
      value.asInstruction() = init and
      address = init.getAllocationAddressOperand()
    )
    or
    exists(UninitializedInstruction uninitialized |
      value.asInstruction() = uninitialized and
      address = uninitialized.getAnOperand()
    )
  )
}

predicate isAdditionalConversionFlow(Operand opFrom, Instruction instrTo) {
  any(Indirection ind).isAdditionalConversionFlow(opFrom, instrTo)
}

newtype TBaseSourceVariable =
  // Each IR variable gets its own source variable
  TBaseIRVariable(IRVariable var) or
  // Each allocation gets its own source variable
  TBaseCallVariable(AllocationInstruction call)

abstract class BaseSourceVariable extends TBaseSourceVariable {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the type of this base source variable. */
  abstract DataFlowType getType();
}

class BaseIRVariable extends BaseSourceVariable, TBaseIRVariable {
  IRVariable var;

  IRVariable getIRVariable() { result = var }

  BaseIRVariable() { this = TBaseIRVariable(var) }

  override string toString() { result = var.toString() }

  override DataFlowType getType() { result = var.getType() }
}

class BaseCallVariable extends BaseSourceVariable, TBaseCallVariable {
  AllocationInstruction call;

  BaseCallVariable() { this = TBaseCallVariable(call) }

  AllocationInstruction getCallInstruction() { result = call }

  override string toString() { result = call.toString() }

  override DataFlowType getType() { result = call.getResultType() }
}

/**
 * Holds if the value pointed to by `operand` can potentially be
 * modified be the caller.
 */
predicate isModifiableByCall(ArgumentOperand operand, int indirectionIndex) {
  exists(CallInstruction call, int index, CppType type |
    indirectionIndex = [1 .. countIndirectionsForCppType(type)] and
    type = getLanguageType(operand) and
    call.getArgumentOperand(index) = operand and
    if index = -1
    then
      // A qualifier is "modifiable" if:
      // 1. the member function is not const specified, or
      // 2. the member function is `const` specified, but returns a pointer or reference
      // type that is non-const.
      //
      // To see why this is necessary, consider the following function:
      // ```
      // struct C {
      //   void* data_;
      //   void* data() const { return data; }
      // };
      // ...
      // C c;
      // memcpy(c.data(), source, 16)
      // ```
      // the data pointed to by `c.data_` is potentially modified by the call to `memcpy` even though
      // `C::data` has a const specifier. So we further place the restriction that the type returned
      // by `call` should not be of the form `const T*` (for some deeply const type `T`).
      if call.getStaticCallTarget() instanceof Cpp::ConstMemberFunction
      then
        exists(PointerOrArrayOrReferenceType resultType |
          resultType = call.getResultType() and
          not resultType.isDeeplyConstBelow()
        )
      else any()
    else
      // An argument is modifiable if it's a non-const pointer or reference type.
      isModifiableAt(type, indirectionIndex)
  )
}

/**
 * Holds if `t` is a pointer or reference type that supports at least `indirectionIndex` number
 * of indirections, and the `indirectionIndex` indirection cannot be modfiied by passing a
 * value of `t` to a function.
 */
private predicate isModifiableAtImpl(CppType cppType, int indirectionIndex) {
  indirectionIndex = [1 .. countIndirectionsForCppType(cppType)] and
  (
    exists(Type pointerType, Type base, Type t |
      pointerType = t.getUnderlyingType() and
      pointerType = any(Indirection ind).getUnderlyingType() and
      cppType.hasType(t, _) and
      base = getTypeImpl(pointerType, indirectionIndex)
    |
      // The value cannot be modified if it has a const specifier,
      not base.isConst()
      or
      // but in the case of a class type, it may be the case that
      // one of the members was modified.
      exists(base.stripType().(Cpp::Class).getAField())
    )
    or
    // If the `indirectionIndex`'th dereference of a type can be modified
    // then so can the  `indirectionIndex + 1`'th dereference.
    isModifiableAtImpl(cppType, indirectionIndex - 1)
  )
}

/**
 * Holds if `t` is a type with at least `indirectionIndex` number of indirections,
 * and the `indirectionIndex` indirection can be modified by passing a value of
 * type `t` to a function function.
 */
bindingset[indirectionIndex]
predicate isModifiableAt(CppType cppType, int indirectionIndex) {
  isModifiableAtImpl(cppType, indirectionIndex)
  or
  exists(PointerWrapper pw, Type t |
    cppType.hasType(t, _) and
    t.stripType() = pw and
    not pw.pointsToConst()
  )
}

abstract class BaseSourceVariableInstruction extends Instruction {
  /** Gets the base source variable accessed by this instruction. */
  abstract BaseSourceVariable getBaseSourceVariable();
}

private class BaseIRVariableInstruction extends BaseSourceVariableInstruction,
  VariableAddressInstruction
{
  override BaseIRVariable getBaseSourceVariable() { result.getIRVariable() = this.getIRVariable() }
}

private class BaseAllocationInstruction extends BaseSourceVariableInstruction, AllocationInstruction
{
  override BaseCallVariable getBaseSourceVariable() { result.getCallInstruction() = this }
}

cached
private module Cached {
  private import semmle.code.cpp.models.interfaces.Iterator as Interfaces
  private import semmle.code.cpp.models.implementations.Iterator as Iterator
  private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs as IO

  /**
   * Holds if `next` is a instruction with a memory result that potentially
   * updates the memory produced by `prev`.
   */
  private predicate memorySucc(Instruction prev, Instruction next) {
    prev = next.(ChiInstruction).getTotal()
    or
    // Phi inputs can be inexact.
    prev = next.(PhiInstruction).getAnInputOperand().getAnyDef()
    or
    prev = next.(CopyInstruction).getSourceValue()
    or
    exists(ReadSideEffectInstruction read |
      next = read.getPrimaryInstruction() and
      isAdditionalConversionFlow(_, next) and
      prev = read.getSideEffectOperand().getAnyDef()
    )
  }

  /**
   * Holds if `iteratorDerefAddress` is an address of an iterator dereference (i.e., `*it`)
   * that is used for a write operation that writes the value `value`. The `memory` instruction
   * represents the memory that the IR's SSA analysis determined was read by the call to `operator*`.
   *
   * The `numberOfLoads` integer represents the number of dereferences this write corresponds to
   * on the underlying container that produced the iterator.
   */
  private predicate isChiAfterIteratorDef(
    Instruction memory, Operand iteratorDerefAddress, Node0Impl value, int numberOfLoads
  ) {
    exists(
      BaseSourceVariableInstruction iteratorBase, ReadSideEffectInstruction read,
      Operand iteratorAddress
    |
      numberOfLoads >= 0 and
      isDef(_, value, iteratorDerefAddress, iteratorBase, numberOfLoads + 2, 0) and
      isUse(_, iteratorAddress, iteratorBase, numberOfLoads + 1, 0) and
      iteratorBase.getResultType() instanceof Interfaces::Iterator and
      isDereference(iteratorAddress.getDef(), read.getArgumentDef().getAUse()) and
      memory = read.getSideEffectOperand().getAnyDef()
    )
  }

  private predicate isSource(Instruction instr, Operand iteratorAddress, int numberOfLoads) {
    getAUse(instr) = iteratorAddress and
    exists(BaseSourceVariableInstruction iteratorBase |
      iteratorBase.getResultType() instanceof Interfaces::Iterator and
      not iteratorBase.getResultType() instanceof Cpp::PointerType and
      isUse(_, iteratorAddress, iteratorBase, numberOfLoads - 1, 0)
    )
  }

  private predicate isSink(Instruction instr, CallInstruction call) {
    getAUse(instr).(ArgumentOperand).getCall() = call and
    // Only include operations that may modify the object that the iterator points to.
    // The following is a non-exhaustive list of things that may modify the value of the
    // iterator, but never the value of what the iterator points to.
    // The more things we can exclude here, the faster the small dataflow-like analysis
    // done by `convertsIntoArgument` will converge.
    not exists(Function f | f = call.getStaticCallTarget() |
      f instanceof Iterator::IteratorCrementOperator or
      f instanceof Iterator::IteratorBinaryArithmeticOperator or
      f instanceof Iterator::IteratorAssignArithmeticOperator or
      f instanceof Iterator::IteratorCrementMemberOperator or
      f instanceof Iterator::IteratorBinaryArithmeticMemberOperator or
      f instanceof Iterator::IteratorAssignArithmeticMemberOperator or
      f instanceof Iterator::IteratorAssignmentMemberOperator
    )
  }

  private predicate convertsIntoArgumentFwd(Instruction instr) {
    isSource(instr, _, _)
    or
    exists(Instruction prev | convertsIntoArgumentFwd(prev) |
      conversionFlow(unique( | | getAUse(prev)), instr, false, _)
    )
  }

  pragma[assume_small_delta]
  private predicate convertsIntoArgumentRev(Instruction instr) {
    convertsIntoArgumentFwd(instr) and
    (
      isSink(instr, _)
      or
      exists(Instruction next | convertsIntoArgumentRev(next) |
        conversionFlow(unique( | | getAUse(instr)), next, false, _)
      )
    )
  }

  private predicate convertsIntoArgument(
    Operand iteratorAddress, CallInstruction call, int numberOfLoads
  ) {
    exists(Instruction iteratorAddressDef |
      isSource(iteratorAddressDef, iteratorAddress, numberOfLoads) and
      isSink(iteratorAddressDef, call) and
      convertsIntoArgumentRev(pragma[only_bind_into](iteratorAddressDef))
    )
  }

  private predicate isChiAfterIteratorArgument(
    Instruction memory, Operand iteratorAddress, int numberOfLoads
  ) {
    // Ideally, `iteratorAddress` would be an `ArgumentOperand`, but there might be
    // various conversions applied to it before it becomes an argument.
    // So we do a small amount of flow to find the call that the iterator is passed to.
    exists(CallInstruction call | convertsIntoArgument(iteratorAddress, call, numberOfLoads) |
      exists(ReadSideEffectInstruction read |
        read.getPrimaryInstruction() = call and
        read.getSideEffectOperand().getAnyDef() = memory
      )
      or
      exists(LoadInstruction load |
        iteratorAddress.getDef() = load and
        memory = load.getSourceValueOperand().getAnyDef()
      )
    )
  }

  /**
   * Holds if `iterator` is a `StoreInstruction` that stores the result of some function
   * returning an iterator into an address computed started at `containerBase`.
   *
   * For example, given a declaration like `std::vector<int>::iterator it = v.begin()`,
   * the `iterator` will be the `StoreInstruction` generated by the write to `it`, and
   * `containerBase` will be the address of `v`.
   */
  private predicate isChiAfterBegin(
    BaseSourceVariableInstruction containerBase, StoreInstruction iterator
  ) {
    exists(
      CallInstruction getIterator, Iterator::GetIteratorFunction getIteratorFunction,
      IO::FunctionInput input, int i
    |
      getIterator = iterator.getSourceValue() and
      getIteratorFunction = getIterator.getStaticCallTarget() and
      getIteratorFunction.getsIterator(input, _) and
      isDef(_, any(Node0Impl n | n.asInstruction() = iterator), _, _, 1, 0) and
      input.isParameterDerefOrQualifierObject(i) and
      isUse(_, getIterator.getArgumentOperand(i), containerBase, 0, 0)
    )
  }

  /**
   * Holds if `iteratorAddress` is an address of an iterator that is used for
   * a read operation. The `memory` instruction represents the memory that
   * the IR's SSA analysis determined was read by the call to `operator*`.
   *
   * Finally, the `numberOfLoads` integer represents the number of dereferences
   * this read corresponds to on the underlying container that produced the iterator.
   */
  private predicate isChiBeforeIteratorUse(
    Operand iteratorAddress, Instruction memory, int numberOfLoads
  ) {
    exists(
      BaseSourceVariableInstruction iteratorBase, LoadInstruction load,
      ReadSideEffectInstruction read, Operand iteratorDerefAddress
    |
      numberOfLoads >= 0 and
      isUse(_, iteratorAddress, iteratorBase, numberOfLoads + 1, 0) and
      isUse(_, iteratorDerefAddress, iteratorBase, numberOfLoads + 2, 0) and
      iteratorBase.getResultType() instanceof Interfaces::Iterator and
      load.getSourceAddressOperand() = iteratorDerefAddress and
      read.getPrimaryInstruction() = load.getSourceAddress() and
      memory = read.getSideEffectOperand().getAnyDef()
    )
  }

  /**
   * Holds if `iteratorDerefAddress` is an address of an iterator dereference (i.e., `*it`)
   * that is used for a write operation that writes the value `value` to a container that
   * created the iterator. `container` represents the base of the address of the container
   * that was used to create the iterator.
   */
  cached
  predicate isIteratorDef(
    BaseSourceVariableInstruction container, Operand iteratorDerefAddress, Node0Impl value,
    int numberOfLoads, int indirectionIndex
  ) {
    exists(Instruction memory, Instruction begin, int upper, int ind |
      isChiAfterIteratorDef(memory, iteratorDerefAddress, value, numberOfLoads) and
      memorySucc*(begin, memory) and
      isChiAfterBegin(container, begin) and
      upper = countIndirectionsForCppType(getResultLanguageType(container)) and
      ind = numberOfLoads + [1 .. upper] and
      indirectionIndex = ind - (numberOfLoads + 1)
    )
  }

  /**
   * Holds if `iteratorAddress` is an address of an iterator that is used for a
   * read operation to read a value from a container that created the iterator.
   * `container` represents the base of the address of the container that was used
   * to create the iterator.
   */
  cached
  predicate isIteratorUse(
    BaseSourceVariableInstruction container, Operand iteratorAddress, int numberOfLoads,
    int indirectionIndex
  ) {
    // Direct use
    exists(Instruction begin, Instruction memory, int upper, int ind |
      isChiBeforeIteratorUse(iteratorAddress, memory, numberOfLoads) and
      memorySucc*(begin, memory) and
      isChiAfterBegin(container, begin) and
      upper = countIndirectionsForCppType(getResultLanguageType(container)) and
      ind = numberOfLoads + [1 .. upper] and
      indirectionIndex = ind - (numberOfLoads + 1)
    )
    or
    // Use through function output
    exists(Instruction memory, Instruction begin, int upper, int ind |
      isChiAfterIteratorArgument(memory, iteratorAddress, numberOfLoads) and
      memorySucc*(begin, memory) and
      isChiAfterBegin(container, begin) and
      upper = countIndirectionsForCppType(getResultLanguageType(container)) and
      ind = numberOfLoads + [1 .. upper] and
      indirectionIndex = ind - (numberOfLoads - 1)
    )
  }

  /** Holds if `op` is the only use of its defining instruction, and that op is used in a conversation */
  private predicate isConversion(Operand op) {
    exists(Instruction def, Operand use |
      def = op.getDef() and
      use = unique( | | getAUse(def)) and
      conversionFlow(use, _, false, false)
    )
  }

  /**
   * Holds if `op` is a use of an SSA variable rooted at `base` with `ind` number
   * of indirections.
   *
   * `certain` is `true` if the operand is guaranteed to read the variable, and
   * `indirectionIndex` specifies the number of loads required to read the variable.
   */
  cached
  predicate isUse(
    boolean certain, Operand op, BaseSourceVariableInstruction base, int ind, int indirectionIndex
  ) {
    not ignoreOperand(op) and
    certain = true and
    exists(LanguageType type, int upper, int ind0 |
      type = getLanguageType(op) and
      upper = countIndirectionsForCppType(type) and
      isUseImpl(op, base, ind0) and
      // Don't count every conversion as their own use. Instead, only the first
      // use (i.e., before any conversions are applied) will count as a use.
      not isConversion(op) and
      ind = ind0 + [0 .. upper] and
      indirectionIndex = ind - ind0
    )
  }

  /**
   * Holds if the underlying IR has a suitable instruction to represent a value
   * that would otherwise need to be represented by a dedicated `OperandNode` value.
   *
   * Such operands do not create new `OperandNode` values, but are
   * instead associated with the instruction returned by this predicate.
   */
  cached
  Instruction getIRRepresentationOfOperand(Operand operand) {
    operand = unique( | | getAUse(result))
  }

  /**
   * Holds if the underlying IR has a suitable operand to represent a value
   * that would otherwise need to be represented by a dedicated `RawIndirectOperand` value.
   *
   * Such operands do not create new `RawIndirectOperand` values, but are
   * instead associated with the operand returned by this predicate.
   */
  cached
  Operand getIRRepresentationOfIndirectOperand(Operand operand, int indirectionIndex) {
    exists(Instruction load |
      isDereference(load, operand) and
      result = unique( | | getAUse(load)) and
      isUseImpl(operand, _, indirectionIndex - 1)
    )
  }

  /**
   * Holds if the underlying IR has a suitable instruction to represent a value
   * that would otherwise need to be represented by a dedicated `RawIndirectInstruction` value.
   *
   * Such instructions do not create new `RawIndirectOperand` values, but are
   * instead associated with the instruction returned by this predicate.
   */
  cached
  Instruction getIRRepresentationOfIndirectInstruction(Instruction instr, int indirectionIndex) {
    exists(Instruction load, Operand address |
      address.getDef() = instr and
      isDereference(load, address) and
      isUseImpl(address, _, indirectionIndex - 1) and
      result = instr
    )
  }

  /**
   * Holds if `operand` is a use of an SSA variable rooted at `base`, and the
   * path from `base` to `operand` passes through `ind` load-like instructions.
   */
  private predicate isUseImpl(Operand operand, BaseSourceVariableInstruction base, int ind) {
    DataFlowImplCommon::forceCachingInSameStage() and
    ind = 0 and
    operand = base.getAUse()
    or
    exists(Operand mid, Instruction instr |
      isUseImpl(mid, base, ind) and
      instr = operand.getDef() and
      conversionFlow(mid, instr, false, _)
    )
    or
    exists(int ind0 |
      exists(Operand address |
        isDereference(operand.getDef(), address) and
        isUseImpl(address, base, ind0)
      )
      or
      isUseImpl(operand.getDef().(InitializeParameterInstruction).getAnOperand(), base, ind0)
    |
      ind0 = ind - 1
    )
  }

  /**
   * Holds if `address` is an address of an SSA variable rooted at `base`,
   * and `instr` is a definition of the SSA variable with `ind` number of indirections.
   *
   * `certain` is `true` if `instr` is guaranteed to write to the variable, and
   * `indirectionIndex` specifies the number of loads required to read the variable
   * after the write operation.
   */
  cached
  predicate isDef(
    boolean certain, Node0Impl value, Operand address, BaseSourceVariableInstruction base, int ind,
    int indirectionIndex
  ) {
    exists(
      boolean writeIsCertain, boolean addressIsCertain, int ind0, CppType type, int lower, int upper
    |
      isWrite(value, address, writeIsCertain) and
      isDefImpl(address, base, ind0, addressIsCertain) and
      certain = writeIsCertain.booleanAnd(addressIsCertain) and
      type = getLanguageType(address) and
      upper = countIndirectionsForCppType(type) and
      ind = ind0 + [lower .. upper] and
      indirectionIndex = ind - (ind0 + lower) and
      (if type.hasType(any(Cpp::ArrayType arrayType), true) then lower = 0 else lower = 1)
    )
  }

  /**
   * Holds if the address computed by `operand` is guaranteed to write
   * to a specific address.
   */
  private predicate isCertainAddress(Operand operand) {
    operand.getDef() instanceof VariableAddressInstruction
    or
    operand.getType() instanceof Cpp::ReferenceType
  }

  /**
   * Holds if `address` is a use of an SSA variable rooted at `base`, and the
   * path from `base` to `address` passes through `ind` load-like instructions.
   *
   * Note: Unlike `isUseImpl`, this predicate recurses through pointer-arithmetic
   * instructions.
   */
  private predicate isDefImpl(
    Operand operand, BaseSourceVariableInstruction base, int ind, boolean certain
  ) {
    DataFlowImplCommon::forceCachingInSameStage() and
    ind = 0 and
    operand = base.getAUse() and
    (if isCertainAddress(operand) then certain = true else certain = false)
    or
    exists(Operand mid, Instruction instr, boolean certain0, boolean isPointerArith |
      isDefImpl(mid, base, ind, certain0) and
      instr = operand.getDef() and
      conversionFlow(mid, instr, isPointerArith, _) and
      if isPointerArith = true then certain = false else certain = certain0
    )
    or
    exists(Operand address, boolean certain0 |
      isDereference(operand.getDef(), address) and
      isDefImpl(address, base, ind - 1, certain0)
    |
      if isCertainAddress(operand) then certain = certain0 else certain = false
    )
    or
    isDefImpl(operand.getDef().(InitializeParameterInstruction).getAnOperand(), base, ind - 1, _) and
    certain = true
  }
}

import Cached

/**
 * Inputs to the shared SSA library's parameterized module that is shared
 * between the SSA pruning stage, and the final SSA stage.
 */
module InputSigCommon {
  class BasicBlock = IRBlock;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result.immediatelyDominates(bb) }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock extends IRBlock {
    ExitBasicBlock() { this.getLastInstruction() instanceof ExitFunctionInstruction }
  }
}
