/**
 * Provides implementation classes modeling C++ iterators, including
 * `std::iterator`, `std::iterator_traits`, and types meeting the
 * `LegacyIterator` named requirement. See `semmle.code.cpp.models.Models` for
 * usage information.
 */

import cpp
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.DataFlow

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

private predicate calledWithIteratorArgument(Operator op, int index) {
  exists(Type t |
    t =
      op
          .getACallToThisFunction()
          .getArgument(index)
          .getExplicitlyConverted()
          .getType()
          .stripTopLevelSpecifiers()
  |
    t instanceof Iterator
    or
    t.(ReferenceType).getBaseType() instanceof Iterator
  )
}

/**
 * A non-member prefix `operator*` function for an iterator type.
 */
class IteratorPointerDereferenceOperator extends Operator, TaintFunction {
  IteratorPointerDereferenceOperator() {
    this.hasName("operator*") and
    calledWithIteratorArgument(this, 0)
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator++` or `operator--` function for an iterator type.
 */
class IteratorCrementOperator extends Operator, DataFlowFunction {
  IteratorCrementOperator() {
    this.hasName(["operator++", "operator--"]) and
    calledWithIteratorArgument(this, 0)
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator+` function for an iterator type.
 */
class IteratorAddOperator extends Operator, TaintFunction {
  int iteratorIndex;

  IteratorAddOperator() {
    this.hasName("operator+") and
    iteratorIndex = [0, 1] and
    calledWithIteratorArgument(this, iteratorIndex)
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(iteratorIndex) and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator-` function that takes a pointer difference type as its second argument.
 */
class IteratorSubOperator extends Operator, TaintFunction {
  IteratorSubOperator() {
    this.hasName("operator-") and
    calledWithIteratorArgument(this, 0) and
    this.getParameter(1).getUnspecifiedType() instanceof IntegralType // not an iterator difference
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
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
class IteratorPointerDereferenceMemberOperator extends MemberFunction, TaintFunction {
  IteratorPointerDereferenceMemberOperator() {
    this.hasName("operator*") and
    this.getDeclaringType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
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
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * An `operator[]` member function of an iterator class.
 */
class IteratorArrayMemberOperator extends MemberFunction, TaintFunction {
  IteratorArrayMemberOperator() {
    this.hasName("operator[]") and
    this.getDeclaringType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}
