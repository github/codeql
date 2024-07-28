import cpp as Cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.internal.IRCppLanguage
private import semmle.code.cpp.ir.implementation.raw.internal.SideEffects as SideEffects
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowUtil
private import semmle.code.cpp.models.interfaces.PointerWrapper
private import DataFlowPrivate
private import TypeFlow
private import semmle.code.cpp.ir.ValueNumbering

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
    instr instanceof CallSideEffectInstruction or
    instr instanceof CallReadSideEffectInstruction or
    instr instanceof ExitFunctionInstruction or
    instr instanceof EnterFunctionInstruction or
    instr instanceof WriteSideEffectInstruction or
    instr instanceof PhiInstruction or
    instr instanceof ReadSideEffectInstruction or
    instr instanceof ChiInstruction or
    instr instanceof InitializeIndirectionInstruction or
    instr instanceof AliasedDefinitionInstruction or
    instr instanceof AliasedUseInstruction or
    instr instanceof InitializeNonLocalInstruction or
    instr instanceof ReturnIndirectionInstruction or
    instr instanceof UninitializedGroupInstruction
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
    // If there is an indirection for the type, but we cannot count the number of indirections
    // it means we couldn't reach a non-indirection type by stripping off indirections. This
    // can occur if an iterator specifies itself as the value type. In this case we default to
    // 1 indirection fore the type.
    exists(Indirection ind |
      ind.getType() = t and
      not exists(ind.getNumberOfIndirections()) and
      result = 1
    )
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

private predicate isIndirectionType(Type t) { t instanceof Indirection }

private predicate hasUnspecifiedBaseType(Indirection t, Type base) {
  base = t.getBaseType().getUnspecifiedType()
}

/**
 * Holds if `t2` is the same type as `t1`, but after stripping away `result` number
 * of indirections.
 * Furthermore, specifies in `t2` been deeply stripped and typedefs has been resolved.
 */
private int getNumberOfIndirectionsImpl(Type t1, Type t2) =
  shortestDistances(isIndirectionType/1, hasUnspecifiedBaseType/2)(t1, t2, result)

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
  final int getNumberOfIndirections() {
    result =
      getNumberOfIndirectionsImpl(this.getType(), any(Type end | not end instanceof Indirection))
  }

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
}

private class PointerWrapperTypeIndirection extends Indirection instanceof PointerWrapper {
  PointerWrapperTypeIndirection() { baseType = PointerWrapper.super.getBaseType() }

  override predicate isAdditionalDereference(Instruction deref, Operand address) {
    exists(CallInstruction call |
      operandForFullyConvertedCall(getAUse(deref), call) and
      this = call.getStaticCallTarget().getClassAndName(["operator*", "operator->", "get"]) and
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

    override predicate isAdditionalWrite(Node0Impl value, Operand address, boolean certain) {
      exists(CallInstruction call | call.getArgumentOperand(0) = value.asOperand() |
        this = call.getStaticCallTarget().getClassAndName("operator=") and
        address = call.getThisArgumentOperand() and
        certain = false
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

/**
 * Holds if `deref` is the result of loading the value at the address
 * represented by `address`.
 *
 * If `additional = true` then the dereference comes from an `Indirection`
 * class (such as a call to an iterator's `operator*`), and if
 * `additional = false` the dereference is a `LoadInstruction`.
 */
predicate isDereference(Instruction deref, Operand address, boolean additional) {
  any(Indirection ind).isAdditionalDereference(deref, address) and
  additional = true
  or
  deref.(LoadInstruction).getSourceAddressOperand() = address and
  additional = false
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
  TBaseCallVariable(CallInstruction call) { not call.getResultIRType() instanceof IRVoidType }

abstract private class AbstractBaseSourceVariable extends TBaseSourceVariable {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the location of this variable. */
  abstract Location getLocation();

  /** Gets the type of this base source variable. */
  final DataFlowType getType() { this.getLanguageType().hasUnspecifiedType(result, _) }

  /** Gets the `CppType` of this base source variable. */
  abstract CppType getLanguageType();
}

final class BaseSourceVariable = AbstractBaseSourceVariable;

class BaseIRVariable extends AbstractBaseSourceVariable, TBaseIRVariable {
  IRVariable var;

  IRVariable getIRVariable() { result = var }

  BaseIRVariable() { this = TBaseIRVariable(var) }

  override string toString() { result = var.toString() }

  override Location getLocation() { result = var.getLocation() }

  override CppType getLanguageType() { result = var.getLanguageType() }
}

class BaseCallVariable extends AbstractBaseSourceVariable, TBaseCallVariable {
  CallInstruction call;

  BaseCallVariable() { this = TBaseCallVariable(call) }

  CallInstruction getCallInstruction() { result = call }

  override string toString() { result = call.toString() }

  override Location getLocation() { result = call.getLocation() }

  override CppType getLanguageType() { result = getResultLanguageType(call) }
}

private module IsModifiableAtImpl {
  pragma[nomagic]
  private predicate isUnderlyingIndirectionType(Type t) {
    t = any(Indirection ind).getUnderlyingType()
  }

  /**
   * Holds if the `indirectionIndex`'th dereference of a value of type
   * `cppType` is a type that can be modified (either by modifying the value
   * itself or one of its fields if it's a class type).
   *
   * For example, a value of type `const int* const` cannot be modified
   * at any indirection index (because it's a constant pointer to constant
   * data), and a value of type `int *const *` is modifiable at indirection index
   * 2 only.
   *
   * A value of type `const S2* s2` where `s2` is
   * ```cpp
   * struct S { int x; }
   * ```
   * can be modified at indirection index 1. This is to ensure that we generate
   * a `PostUpdateNode` for the argument corresponding to the `s2` parameter in
   * an example such as:
   * ```cpp
   * void set_field(const S2* s2)
   * {
   *  s2->s->x = 42;
   * }
   * ```
   */
  bindingset[cppType, indirectionIndex]
  pragma[inline_late]
  private predicate impl(CppType cppType, int indirectionIndex) {
    exists(Type pointerType, Type base |
      isUnderlyingIndirectionType(pointerType) and
      cppType.hasUnderlyingType(pointerType, false) and
      base = getTypeImpl(pointerType, indirectionIndex)
    |
      // The value cannot be modified if it has a const specifier,
      not base.isConst()
      or
      // but in the case of a class type, it may be the case that
      // one of the members was modified.
      exists(base.stripType().(Cpp::Class).getAField())
    )
  }

  /**
   * Holds if `cppType` is modifiable with an indirection index of at least 1.
   *
   * This predicate factored out into a separate predicate for two reasons:
   * - This predicate needs to be recursive because, if a type is modifiable
   * at indirection `i`, then it's also modifiable at indirection index `i+1`
   * (because the pointer could be completely re-assigned at indirection `i`).
   * - We special-case indirection index `0` so that pointer arguments that can
   * be modified at some index always have a `PostUpdateNode` at indiretion
   * index 0 even though the 0'th indirection can never be modified by a
   * callee.
   */
  private predicate isModifiableAtImplAtLeast1(CppType cppType, int indirectionIndex) {
    indirectionIndex = [1 .. countIndirectionsForCppType(cppType)] and
    (
      impl(cppType, indirectionIndex)
      or
      // If the `indirectionIndex`'th dereference of a type can be modified
      // then so can the  `indirectionIndex + 1`'th dereference.
      isModifiableAtImplAtLeast1(cppType, indirectionIndex - 1)
    )
  }

  /**
   * Holds if `cppType` is modifiable at indirection index 0.
   *
   * In reality, the 0'th indirection of a pointer (i.e., the pointer itself)
   * can never be modified by a callee, but it is sometimes useful to be able
   * to specify the value of the pointer, as its coming out of a function, as
   * a source of dataflow since the shared library's reverse-read mechanism
   * then ensures that field-flow is accounted for.
   */
  private predicate isModifiableAtImplAt0(CppType cppType) { impl(cppType, 0) }

  /**
   * Holds if `t` is a pointer or reference type that supports at least
   * `indirectionIndex` number of indirections, and the `indirectionIndex`
   * indirection cannot be modfiied by passing a value of `t` to a function.
   */
  private predicate isModifiableAtImpl(CppType cppType, int indirectionIndex) {
    isModifiableAtImplAtLeast1(cppType, indirectionIndex)
    or
    indirectionIndex = 0 and
    isModifiableAtImplAt0(cppType)
  }

  /**
   * Holds if `t` is a type with at least `indirectionIndex` number of
   * indirections, and the `indirectionIndex` indirection can be modified by
   * passing a value of type `t` to a function function.
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

  /**
   * Holds if the value pointed to by `operand` can potentially be
   * modified be the caller.
   */
  predicate isModifiableByCall(ArgumentOperand operand, int indirectionIndex) {
    exists(CallInstruction call, int index, CppType type |
      indirectionIndex = [0 .. countIndirectionsForCppType(type)] and
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
}

import IsModifiableAtImpl

abstract class BaseSourceVariableInstruction extends Instruction {
  /** Gets the base source variable accessed by this instruction. */
  abstract BaseSourceVariable getBaseSourceVariable();
}

private class BaseIRVariableInstruction extends BaseSourceVariableInstruction,
  VariableAddressInstruction
{
  override BaseIRVariable getBaseSourceVariable() { result.getIRVariable() = this.getIRVariable() }
}

private class BaseCallInstruction extends BaseSourceVariableInstruction, CallInstruction {
  override BaseCallVariable getBaseSourceVariable() { result.getCallInstruction() = this }
}

cached
private module Cached {
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
  predicate hasIRRepresentationOfIndirectOperand(
    Operand operand, int indirectionIndex, Operand operandRepr, int indirectionIndexRepr
  ) {
    indirectionIndex = [1 .. countIndirectionsForCppType(getLanguageType(operand))] and
    exists(Instruction load |
      isDereference(load, operand, false) and
      operandRepr = unique( | | getAUse(load)) and
      indirectionIndexRepr = indirectionIndex - 1
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
  predicate hasIRRepresentationOfIndirectInstruction(
    Instruction instr, int indirectionIndex, Instruction instrRepr, int indirectionIndexRepr
  ) {
    indirectionIndex = [1 .. countIndirectionsForCppType(getResultLanguageType(instr))] and
    exists(Instruction load, Operand address |
      address = unique( | | getAUse(instr)) and
      isDereference(load, address, false) and
      instrRepr = load and
      indirectionIndexRepr = indirectionIndex - 1
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
        isDereference(operand.getDef(), address, _) and
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
      lower = getMinIndirectionsForType(any(Type t | type.hasUnspecifiedType(t, _)))
    )
  }

  /**
   * Holds if the address computed by `operand` is guaranteed to write
   * to a specific address.
   */
  private predicate isCertainAddress(Operand operand) { isPointerToSingleObject(operand.getDef()) }

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
      isDereference(operand.getDef(), address, _) and
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
  class BasicBlock extends IRBlock {
    ControlFlowNode getNode(int i) { result = this.getInstruction(i) }

    int length() { result = this.getInstructionCount() }
  }

  class ControlFlowNode = Instruction;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result.immediatelyDominates(bb) }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock extends BasicBlock {
    ExitBasicBlock() { this.getLastInstruction() instanceof ExitFunctionInstruction }
  }
}
