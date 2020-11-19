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
class IteratorTraits extends Class {
  IteratorTraits() {
    this.hasQualifiedName("std", "iterator_traits") and
    not this instanceof TemplateClass and
    exists(TypedefType t |
      this.getAMember() = t and
      t.getName() = "iterator_category"
    )
  }

  Type getIteratorType() { result = this.getTemplateArgument(0) }
}

/**
 * A type which has the typedefs expected for an iterator.
 */
class IteratorByTypedefs extends Class {
  IteratorByTypedefs() {
    this.getAMember().(TypedefType).hasName("difference_type") and
    this.getAMember().(TypedefType).hasName("value_type") and
    this.getAMember().(TypedefType).hasName("pointer") and
    this.getAMember().(TypedefType).hasName("reference") and
    this.getAMember().(TypedefType).hasName("iterator_category") and
    not this.hasQualifiedName("std", "iterator_traits")
  }
}

/**
 * The `std::iterator` class.
 */
class StdIterator extends Class {
  StdIterator() { this.hasQualifiedName("std", "iterator") }
}

/**
 * A type which can be used as an iterator
 */
class Iterator extends Type {
  Iterator() {
    this instanceof IteratorByTypedefs or
    exists(IteratorTraits it | it.getIteratorType() = this) or
    this instanceof StdIterator
  }
}

private FunctionInput getIteratorArgumentInput(Operator op, int index) {
  exists(Type t |
    t =
      op
          .getACallToThisFunction()
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
class IteratorPointerDereferenceOperator extends Operator, TaintFunction, IteratorReferenceFunction {
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
class IteratorCrementOperator extends Operator, DataFlowFunction {
  FunctionInput iteratorInput;

  IteratorCrementOperator() {
    this.hasName(["operator++", "operator--"]) and
    iteratorInput = getIteratorArgumentInput(this, 0)
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input = iteratorInput and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator+` function for an iterator type.
 */
class IteratorAddOperator extends Operator, TaintFunction {
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
class IteratorSubOperator extends Operator, TaintFunction {
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
class IteratorAssignArithmeticOperator extends Operator, DataFlowFunction, TaintFunction {
  IteratorAssignArithmeticOperator() {
    this.hasName(["operator+=", "operator-="]) and
    this.getDeclaringType() instanceof Iterator
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
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
    this.hasName("operator*") and
    this.getDeclaringType() instanceof Iterator
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
class IteratorCrementMemberOperator extends MemberFunction, DataFlowFunction, TaintFunction {
  IteratorCrementMemberOperator() {
    this.hasName(["operator++", "operator--"]) and
    this.getDeclaringType() instanceof Iterator
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * A member `operator->` function for an iterator type.
 */
class IteratorFieldMemberOperator extends Operator, TaintFunction {
  IteratorFieldMemberOperator() {
    this.hasName("operator->") and
    this.getDeclaringType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * An `operator+` or `operator-` member function of an iterator class.
 */
class IteratorBinaryArithmeticMemberOperator extends MemberFunction, TaintFunction {
  IteratorBinaryArithmeticMemberOperator() {
    this.hasName(["operator+", "operator-"]) and
    this.getDeclaringType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * An `operator+=` or `operator-=` member function of an iterator class.
 */
class IteratorAssignArithmeticMemberOperator extends MemberFunction, DataFlowFunction, TaintFunction {
  IteratorAssignArithmeticMemberOperator() {
    this.hasName(["operator+=", "operator-="]) and
    this.getDeclaringType() instanceof Iterator
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * An `operator[]` member function of an iterator class.
 */
class IteratorArrayMemberOperator extends MemberFunction, TaintFunction, IteratorReferenceFunction {
  IteratorArrayMemberOperator() {
    this.hasName("operator[]") and
    this.getDeclaringType() instanceof Iterator
  }

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
class IteratorAssignmentMemberOperator extends MemberFunction, TaintFunction {
  IteratorAssignmentMemberOperator() {
    this.hasName("operator=") and
    this.getDeclaringType() instanceof Iterator and
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
class BeginOrEndFunction extends MemberFunction, TaintFunction, GetIteratorFunction {
  BeginOrEndFunction() {
    this
        .hasName([
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
class InserterIteratorFunction extends GetIteratorFunction {
  InserterIteratorFunction() {
    this.hasQualifiedName("std", ["front_inserter", "inserter", "back_inserter"])
  }

  override predicate getsIterator(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValue()
  }
}
