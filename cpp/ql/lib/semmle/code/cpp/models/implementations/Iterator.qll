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
  IteratorByTraits() { exists(IteratorTraits it | it.getIteratorType() = this) }
}

/**
 * The C++ standard includes an `std::iterator_traits` specialization for pointer types. When
 * this specialization is included in the database, a pointer type `T*` will be an instance
 * of the `IteratorByTraits` class. However, if the `T*` specialization is not in the database,
 * we need to explicitly include them with this class.
 */
private class IteratorByPointer extends Iterator instanceof PointerType {
  IteratorByPointer() { not this instanceof IteratorByTraits }
}

/**
 * A type which has the typedefs expected for an iterator.
 */
private class IteratorByTypedefs extends Iterator, Class {
  IteratorByTypedefs() {
    this.getAMember().(TypedefType).hasName("difference_type") and
    this.getAMember().(TypedefType).hasName("value_type") and
    this.getAMember().(TypedefType).hasName("pointer") and
    this.getAMember().(TypedefType).hasName("reference") and
    this.getAMember().(TypedefType).hasName("iterator_category") and
    not this.hasQualifiedName(["std", "bsl"], "iterator_traits")
  }
}

/**
 * The `std::iterator` class.
 */
private class StdIterator extends Iterator, Class {
  StdIterator() { this.hasQualifiedName(["std", "bsl"], "iterator") }
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
 * A non-member prefix `operator*` function for an iterator type.
 */
private class IteratorPointerDereferenceOperator extends Operator, TaintFunction,
  IteratorReferenceFunction {
  FunctionInput iteratorInput;

  IteratorPointerDereferenceOperator() {
    this.hasName("operator*") and
    iteratorInput = getIteratorArgumentInput(this, 0)
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input = iteratorInput and
    output.isReturnValue()
    or
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
  }
}

/**
 * A non-member `operator++` or `operator--` function for an iterator type.
 */
private class IteratorCrementOperator extends Operator, DataFlowFunction {
  FunctionInput iteratorInput;

  IteratorCrementOperator() {
    this.hasName(["operator++", "operator--"]) and
    iteratorInput = getIteratorArgumentInput(this, 0)
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input = iteratorInput and
    output.isReturnValue()
    or
    input.isParameterDeref(0) and output.isReturnValueDeref()
  }
}

/**
 * A non-member `operator+` function for an iterator type.
 */
private class IteratorAddOperator extends Operator, TaintFunction {
  FunctionInput iteratorInput;

  IteratorAddOperator() {
    this.hasName("operator+") and
    iteratorInput = getIteratorArgumentInput(this, [0, 1])
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input = iteratorInput and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator-` function that takes a pointer difference type as its second argument.
 */
private class IteratorSubOperator extends Operator, TaintFunction {
  FunctionInput iteratorInput;

  IteratorSubOperator() {
    this.hasName("operator-") and
    iteratorInput = getIteratorArgumentInput(this, 0) and
    this.getParameter(1).getUnspecifiedType() instanceof IntegralType // not an iterator difference
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input = iteratorInput and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator+=` or `operator-=` function for an iterator type.
 */
private class IteratorAssignArithmeticOperator extends Operator, DataFlowFunction, TaintFunction {
  IteratorAssignArithmeticOperator() {
    this.hasName(["operator+=", "operator-="]) and
    exists(getIteratorArgumentInput(this, 0))
  }

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
    input.isParameterDeref(1) and
    output.isParameterDeref(0)
  }
}

/**
 * A prefix `operator*` member function for an iterator type.
 */
class IteratorPointerDereferenceMemberOperator extends MemberFunction, TaintFunction,
  IteratorReferenceFunction {
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
 * An `operator++` or `operator--` member function for an iterator type.
 */
private class IteratorCrementMemberOperator extends MemberFunction, DataFlowFunction, TaintFunction {
  IteratorCrementMemberOperator() {
    this.getClassAndName(["operator++", "operator--"]) instanceof Iterator
  }

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
 * An `operator+` or `operator-` member function of an iterator class.
 */
private class IteratorBinaryArithmeticMemberOperator extends MemberFunction, TaintFunction {
  IteratorBinaryArithmeticMemberOperator() {
    this.getClassAndName(["operator+", "operator-"]) instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * An `operator+=` or `operator-=` member function of an iterator class.
 */
private class IteratorAssignArithmeticMemberOperator extends MemberFunction, DataFlowFunction,
  TaintFunction {
  IteratorAssignArithmeticMemberOperator() {
    this.getClassAndName(["operator+=", "operator-="]) instanceof Iterator
  }

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
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * An `operator[]` member function of an iterator class.
 */
private class IteratorArrayMemberOperator extends MemberFunction, TaintFunction,
  IteratorReferenceFunction {
  IteratorArrayMemberOperator() { this.getClassAndName("operator[]") instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * An `operator=` member function of an iterator class that is not a copy or move assignment
 * operator.
 *
 * The `hasTaintFlow` override provides flow through output iterators that return themselves with
 * `operator*` and use their own `operator=` to assign to the container.
 */
private class IteratorAssignmentMemberOperator extends MemberFunction, TaintFunction {
  IteratorAssignmentMemberOperator() {
    this.getClassAndName("operator=") instanceof Iterator and
    not this instanceof CopyAssignmentOperator and
    not this instanceof MoveAssignmentOperator
  }

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
