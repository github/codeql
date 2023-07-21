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
  DataFlowFunction
{
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input = getIteratorArgumentInput(this, 0) and
    output.isReturnValue()
    or
    input.isParameterDeref(0) and output.isReturnValueDeref()
  }
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
  DataFlowFunction, TaintFunction
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
  IteratorReferenceFunction
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
  TaintFunction
{
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input = getIteratorArgumentInput(this, 0) and
    output.isReturnValue()
    or
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
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
 * An `operator=` member function of an iterator class that is not a copy or move assignment
 * operator.
 *
 * The `hasTaintFlow` override provides flow through output iterators that return themselves with
 * `operator*` and use their own `operator=` to assign to the container.
 */
private class IteratorAssignmentMemberOperatorModel extends IteratorAssignmentMemberOperator,
  TaintFunction
{
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * A `begin` or `end` member function, or a related member function, that
 * returns an iterator.
 */
private class BeginOrEndFunction extends MemberFunction, TaintFunction, GetIteratorFunction {
  BeginOrEndFunction() {
    this.hasName([
        "begin", "cbegin", "rbegin", "crbegin", "end", "cend", "rend", "crend", "before_begin",
        "cbefore_begin"
      ]) and
    this.getType().getUnspecifiedType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }

  override predicate getsIterator(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
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
