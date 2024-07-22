/**
 * Provides implementation classes modeling C++ iterators, including
 * `std::iterator`, `std::iterator_traits`, and types meeting the
 * `LegacyIterator` named requirement. See `semmle.code.cpp.models.Models` for
 * usage information.
 */

import cpp
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Iterator
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * An instantiation of the `std::iterator_traits` template.
 */
private class IteratorTraits extends Class {
  IteratorTraits() {
    this.hasQualifiedName(["std", "bsl"], "iterator_traits") and
    not this instanceof TemplateClass and
    exists(TypedefType t |
      this.getAMember() = t and
      t.getName() = "iterator_category"
    )
  }

  Type getIteratorType() { result = this.getTemplateArgument(0) }
}

/**
 * A type that is deduced to be an iterator because there is a corresponding
 * `std::iterator_traits` instantiation for it.
 */
private class IteratorByTraits extends Iterator {
  IteratorTraits trait;

  IteratorByTraits() { trait.getIteratorType() = this }

  override Type getValueType() {
    exists(TypedefType t |
      trait.getAMember() = t and
      t.getName() = "value_type" and
      result = t.getUnderlyingType()
    )
  }
}

/**
 * The C++ standard includes an `std::iterator_traits` specialization for pointer types. When
 * this specialization is included in the database, a pointer type `T*` will be an instance
 * of the `IteratorByTraits` class. However, if the `T*` specialization is not in the database,
 * we need to explicitly include them with this class.
 */
private class IteratorByPointer extends Iterator instanceof PointerType {
  IteratorByPointer() { not this instanceof IteratorByTraits }

  override Type getValueType() { result = super.getBaseType() }
}

/**
 * A type which has the typedefs expected for an iterator.
 */
private class IteratorByTypedefs extends Iterator, Class {
  TypedefType valueType;

  IteratorByTypedefs() {
    this.getAMember().(TypedefType).hasName("difference_type") and
    valueType = this.getAMember() and
    valueType.hasName("value_type") and
    this.getAMember().(TypedefType).hasName("pointer") and
    this.getAMember().(TypedefType).hasName("reference") and
    this.getAMember().(TypedefType).hasName("iterator_category") and
    not this.hasQualifiedName(["std", "bsl"], "iterator_traits")
  }

  override Type getValueType() { result = valueType.getUnderlyingType() }
}

/**
 * The `std::iterator` class.
 */
private class StdIterator extends Iterator, Class {
  StdIterator() { this.hasQualifiedName(["std", "bsl"], "iterator") }

  override Type getValueType() { result = this.getTemplateArgument(1).(Type).getUnderlyingType() }
}

private class StdReverseIterator extends Iterator, Class {
  StdReverseIterator() { this.hasQualifiedName(["std", "bsl"], "reverse_iterator") }

  override Type getValueType() { result = this.getTemplateArgument(1).(Type).getUnderlyingType() }
}

private class StdIstreamBufIterator extends Iterator, Class {
  StdIstreamBufIterator() { this.hasQualifiedName(["std", "bsl"], "istreambuf_iterator") }

  override Type getValueType() { result = this.getTemplateArgument(1).(Type).getUnderlyingType() }
}

private class StdIstreambufIteratorConstructor extends Constructor, SideEffectFunction,
  AliasFunction
{
  StdIstreambufIteratorConstructor() { this.getDeclaringType() instanceof StdIstreamBufIterator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }
}

/**
 * Gets the `FunctionInput` corresponding to an iterator parameter to
 * user-defined operator `op`, at `index`.
 */
private FunctionInput getIteratorArgumentInput(Operator op, int index) {
  exists(Type t |
    t =
      op.getACallToThisFunction()
          .getArgument(index)
          .getExplicitlyConverted()
          .getType()
          .stripTopLevelSpecifiers()
  |
    (
      t instanceof Iterator or
      t.(ReferenceType).getBaseType() instanceof Iterator
    ) and
    if op.getParameter(index).getUnspecifiedType() instanceof ReferenceType
    then result.isParameterDeref(index)
    else result.isParameter(index)
  )
}

/**
 * A non-member `operator++` or `operator--` function for an iterator type.
 *
 * Note that this class _only_ matches non-member functions. To find both
 * non-member and versions, use `IteratorCrementOperator`.
 */
class IteratorCrementNonMemberOperator extends Operator {
  IteratorCrementNonMemberOperator() {
    this.hasName(["operator++", "operator--"]) and
    exists(getIteratorArgumentInput(this, 0))
  }
}

private class IteratorCrementNonMemberOperatorModel extends IteratorCrementNonMemberOperator,
  DataFlowFunction, SideEffectFunction, AliasFunction
{
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input = getIteratorArgumentInput(this, 0) and
    output.isReturnValue()
    or
    input.isParameterDeref(0) and output.isReturnValueDeref()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = false
  }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    // See the comment on `IteratorCrementMemberOperatorModel::hasSpecificWriteSideEffect`
    // for an explanation of these values.
    i = 0 and buffer = false and mustWrite = false
  }

  override predicate parameterNeverEscapes(int index) { none() }

  override predicate parameterEscapesOnlyViaReturn(int index) { index = 0 }
}

/**
 * An `operator++` or `operator--` member function for an iterator type.
 *
 * Note that this class _only_ matches member functions. To find both
 * non-member and member versions, use `IteratorCrementOperator`.
 */
class IteratorCrementMemberOperator extends MemberFunction {
  IteratorCrementMemberOperator() {
    this.getClassAndName(["operator++", "operator--"]) instanceof Iterator
  }
}

private class IteratorCrementMemberOperatorModel extends IteratorCrementMemberOperator,
  DataFlowFunction, TaintFunction, SideEffectFunction, AliasFunction
{
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isReturnValueDeref() and
    output.isQualifierObject()
    or
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    // We have two choices here: either `buffer` must be `true` or `mustWrite`
    // must be `false` to ensure that the IR alias analysis doesn't think that
    // `it++` completely override the value of the iterator.
    // We choose `mustWrite` must be `false`. In that case, the value of
    // `buffer` isn't super important (it just decides which kind of read side
    // effect will be emitted).
    i = -1 and buffer = false and mustWrite = false
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }
}

/**
 * A (member or non-member) `operator++` or `operator--` function for an iterator type.
 */
class IteratorCrementOperator extends Function {
  IteratorCrementOperator() {
    this instanceof IteratorCrementNonMemberOperator or
    this instanceof IteratorCrementMemberOperator
  }
}

/**
 * A non-member `operator+` function for an iterator type.
 *
 * Note that this class _only_ matches non-member functions. To find both
 * non-member and member versions, use `IteratorBinaryAddOperator`.
 */
class IteratorAddNonMemberOperator extends Operator {
  IteratorAddNonMemberOperator() {
    this.hasName("operator+") and
    exists(getIteratorArgumentInput(this, [0, 1]))
  }
}

private class IteratorAddNonMemberOperatorModel extends IteratorAddNonMemberOperator, TaintFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input = getIteratorArgumentInput(this, [0, 1]) and
    output.isReturnValue()
  }
}

/**
 * An `operator+` or `operator-` member function of an iterator class.
 *
 * Note that this class _only_ matches member functions. To find both
 * non-member and member versions, use `IteratorBinaryAddOperator`.
 */
class IteratorBinaryArithmeticMemberOperator extends MemberFunction {
  IteratorBinaryArithmeticMemberOperator() {
    this.getClassAndName(["operator+", "operator-"]) instanceof Iterator
  }
}

private class IteratorBinaryArithmeticMemberOperatorModel extends IteratorBinaryArithmeticMemberOperator,
  TaintFunction
{
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * A (member or non-member) `operator+` or `operator-` function for an iterator type.
 */
class IteratorBinaryArithmeticOperator extends Function {
  IteratorBinaryArithmeticOperator() {
    this instanceof IteratorAddNonMemberOperator or
    this instanceof IteratorSubNonMemberOperator or
    this instanceof IteratorBinaryArithmeticMemberOperator
  }
}

/**
 * A non-member `operator-` function that takes a pointer difference type as its second argument.
 *
 * Note that this class _only_ matches non-member functions. To find both
 * non-member and member versions, use `IteratorBinaryArithmeticOperator` (which also
 * includes `operator+` versions).
 */
class IteratorSubNonMemberOperator extends Operator {
  IteratorSubNonMemberOperator() {
    this.hasName("operator-") and
    exists(getIteratorArgumentInput(this, 0)) and
    this.getParameter(1).getUnspecifiedType() instanceof IntegralType // not an iterator difference
  }
}

private class IteratorSubOperatorModel extends IteratorSubNonMemberOperator, TaintFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input = getIteratorArgumentInput(this, 0) and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator+=` or `operator-=` function for an iterator type.
 *
 * Note that this class _only_ matches non-member functions. To find both
 * non-member and member versions, use `IteratorAssignArithmeticOperator`.
 */
class IteratorAssignArithmeticNonMemberOperator extends Operator {
  IteratorAssignArithmeticNonMemberOperator() {
    this.hasName(["operator+=", "operator-="]) and
    exists(getIteratorArgumentInput(this, 0))
  }
}

private class IteratorAssignArithmeticNonMemberOperatorModel extends IteratorAssignArithmeticNonMemberOperator,
  DataFlowFunction, TaintFunction
{
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the object referenced by the first parameter
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
    or
    (input.isParameter(1) or input.isParameterDeref(1)) and
    output.isParameterDeref(0)
  }
}

/**
 * An `operator+=` or `operator-=` member function of an iterator class.
 *
 * Note that this class _only_ matches member functions. To find both
 * non-member and member versions, use `IteratorAssignArithmeticOperator`.
 */
class IteratorAssignArithmeticMemberOperator extends MemberFunction {
  IteratorAssignArithmeticMemberOperator() {
    this.getClassAndName(["operator+=", "operator-="]) instanceof Iterator
  }
}

private class IteratorAssignArithmeticMemberOperatorModel extends IteratorAssignArithmeticMemberOperator,
  DataFlowFunction, TaintFunction
{
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
    or
    (input.isParameter(0) or input.isParameterDeref(0)) and
    output.isQualifierObject()
  }
}

/**
 * A (member or non-member) `operator+=` or `operator-=` function for an iterator type.
 */
class IteratorAssignArithmeticOperator extends Function {
  IteratorAssignArithmeticOperator() {
    this instanceof IteratorAssignArithmeticNonMemberOperator or
    this instanceof IteratorAssignArithmeticMemberOperator
  }
}

/**
 * A prefix `operator*` member function for an iterator type.
 *
 * Note that this class _only_ matches member functions. To find both
 * non-member and member versions, use `IteratorPointerDereferenceOperator`.
 */
class IteratorPointerDereferenceMemberOperator extends MemberFunction, TaintFunction,
  IteratorReferenceFunction, AliasFunction, SideEffectFunction
{
  IteratorPointerDereferenceMemberOperator() {
    this.getClassAndName("operator*") instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
    or
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

/**
 * A non-member prefix `operator*` function for an iterator type.
 *
 * Note that this class _only_ matches non-member functions. To find both
 * non-member and member versions, use `IteratorPointerDereferenceOperator`.
 */
class IteratorPointerDereferenceNonMemberOperator extends Operator, IteratorReferenceFunction {
  IteratorPointerDereferenceNonMemberOperator() {
    this.hasName("operator*") and
    exists(getIteratorArgumentInput(this, 0))
  }
}

private class IteratorPointerDereferenceNonMemberOperatorModel extends IteratorPointerDereferenceNonMemberOperator,
  TaintFunction, AliasFunction, SideEffectFunction
{
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input = getIteratorArgumentInput(this, 0) and
    output.isReturnValue()
    or
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
  }

  override predicate parameterNeverEscapes(int index) { index = 0 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = false
  }
}

/**
 * A (member or non-member) prefix `operator*` function for an iterator type.
 */
class IteratorPointerDereferenceOperator extends Function {
  IteratorPointerDereferenceOperator() {
    this instanceof IteratorPointerDereferenceNonMemberOperator or
    this instanceof IteratorPointerDereferenceMemberOperator
  }
}

/**
 * A member `operator->` function for an iterator type.
 */
private class IteratorFieldMemberOperator extends Operator, TaintFunction {
  IteratorFieldMemberOperator() { this.getClassAndName("operator->") instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * An `operator[]` member function of an iterator class.
 */
private class IteratorArrayMemberOperator extends MemberFunction, TaintFunction,
  IteratorReferenceFunction
{
  IteratorArrayMemberOperator() { this.getClassAndName("operator[]") instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * An `operator=` member function of an iterator class that is not a copy or move assignment
 * operator.
 */
class IteratorAssignmentMemberOperator extends MemberFunction {
  IteratorAssignmentMemberOperator() {
    this.getClassAndName("operator=") instanceof Iterator and
    not this instanceof CopyAssignmentOperator and
    not this instanceof MoveAssignmentOperator
  }
}

/**
 * A member `operator==` or `operator!=` function for an iterator type.
 *
 * Note that this class _only_ matches member functions. To find both
 * non-member and member versions, use `IteratorLogicalOperator`.
 */
class IteratorLogicalMemberOperator extends MemberFunction {
  IteratorLogicalMemberOperator() {
    this.getClassAndName(["operator!=", "operator=="]) instanceof Iterator
  }
}

private class IteratorLogicalMemberOperatorModel extends IteratorLogicalMemberOperator,
  AliasFunction, SideEffectFunction
{
  override predicate parameterNeverEscapes(int index) { index = [-1, 0] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

/**
 * A member `operator==` or `operator!=` function for an iterator type.
 *
 * Note that this class _only_ matches non-member functions. To find both
 * non-member and member versions, use `IteratorLogicalOperator`.
 */
class IteratorLogicalNonMemberOperator extends Function {
  IteratorLogicalNonMemberOperator() {
    this.hasName(["operator!=", "operator=="]) and
    exists(getIteratorArgumentInput(this, 0)) and
    exists(getIteratorArgumentInput(this, 1))
  }
}

private class IteratorLogicalNonMemberOperatorModel extends IteratorLogicalNonMemberOperator,
  AliasFunction, SideEffectFunction
{
  override predicate parameterNeverEscapes(int index) { index = [0, 1] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

/**
 * A (member or non-member) `operator==` or `operator!=` function for an iterator type.
 */
class IteratorLogicalOperator extends Function {
  IteratorLogicalOperator() {
    this instanceof IteratorLogicalNonMemberOperator
    or
    this instanceof IteratorLogicalMemberOperator
  }
}

/**
 * An `operator=` member function of an iterator class that is not a copy or move assignment
 * operator.
 *
 * The `hasTaintFlow` override provides flow through output iterators that return themselves with
 * `operator*` and use their own `operator=` to assign to the container.
 */
private class IteratorAssignmentMemberOperatorModel extends IteratorAssignmentMemberOperator,
  TaintFunction, SideEffectFunction, AliasFunction
{
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (input.isParameterDeref(0) or input.isParameter(0)) and
    output.isQualifierObject()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    // See the comment on `IteratorCrementMemberOperatorModel::hasSpecificWriteSideEffect`
    // for an explanation of these values.
    i = -1 and buffer = false and mustWrite = false
  }

  override predicate parameterNeverEscapes(int index) { index = 0 }

  override predicate parameterEscapesOnlyViaReturn(int index) { index = -1 }
}

private string beginName() {
  result = ["begin", "cbegin", "rbegin", "crbegin", "before_begin", "cbefore_begin"]
}

/**
 * A `begin` member function, or a related function, that returns an iterator.
 */
class BeginFunction extends Function {
  BeginFunction() {
    this.getUnspecifiedType() instanceof Iterator and
    (
      this.hasName(beginName()) and
      this instanceof MemberFunction
      or
      this.hasGlobalOrStdOrBslName(beginName()) and
      not this instanceof MemberFunction and
      this.getNumberOfParameters() = 1
    )
  }
}

private string endName() { result = ["end", "cend", "rend", "crend"] }

/**
 * An `end` member function, or a related function, that returns an iterator.
 */
class EndFunction extends Function {
  EndFunction() {
    this.getUnspecifiedType() instanceof Iterator and
    (
      this.hasName(endName()) and
      this instanceof MemberFunction
      or
      this.hasGlobalOrStdOrBslName(endName()) and
      this instanceof MemberFunction and
      this.getNumberOfParameters() = 1
    )
  }
}

/**
 * A `begin` or `end` member function, or a related member function, that
 * returns an iterator.
 */
class BeginOrEndFunction extends Function {
  BeginOrEndFunction() {
    this instanceof BeginFunction or
    this instanceof EndFunction
  }
}

private class BeginOrEndFunctionModels extends BeginOrEndFunction, TaintFunction,
  GetIteratorFunction, AliasFunction, SideEffectFunction
{
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }

  override predicate getsIterator(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

/**
 * The `std::front_inserter`, `std::inserter`, and `std::back_inserter`
 * functions.
 */
private class InserterIteratorFunction extends GetIteratorFunction {
  InserterIteratorFunction() {
    this.hasQualifiedName(["std", "bsl"], ["front_inserter", "inserter", "back_inserter"])
  }

  override predicate getsIterator(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValue()
  }
}
