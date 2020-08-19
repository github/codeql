import cpp
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.DataFlow

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

class StdIterator extends Class {
  StdIterator() {
    this.hasQualifiedName("std", "iterator")
  }
}

class LegacyIterator extends Type {
  LegacyIterator() {
    this instanceof IteratorByTypedefs or
    exists(IteratorTraits it | it.getIteratorType() = this) or
    this instanceof StdIterator
  }
}

class IteratorPointerDereferenceOperator extends Operator, TaintFunction {
  IteratorPointerDereferenceOperator() {
    this.hasName("operator*") and
    this.getACallToThisFunction().getArgument(0).getFullyConverted().getUnderlyingType() instanceof
      LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

class IteratorCrementOperator extends Operator, DataFlowFunction, TaintFunction {
  IteratorCrementOperator() {
    (
      this.hasName("operator++") or
      this.hasName("operator--")
    ) and
    this
        .getACallToThisFunction()
        .getArgument(0)
        .getFullyConverted()
        .getUnderlyingType()
        .(ReferenceType)
        .getBaseType() instanceof LegacyIterator
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isParameterDeref(0)
  }
}

class IteratorFieldOperator extends Operator, TaintFunction {
  IteratorFieldOperator() {
    this.hasName("operator->") and
    this
        .getACallToThisFunction()
        .getArgument(0)
        .getFullyConverted()
        .getUnspecifiedType()
        .(PointerType)
        .getBaseType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValue()
  }
}

class IteratorAddOperator extends Operator, TaintFunction {
  IteratorAddOperator() {
    this.hasName("operator+") and
    (
      this
          .getACallToThisFunction()
          .getArgument(0)
          .getFullyConverted()
          .getUnspecifiedType()
          .(PointerType)
          .getBaseType() instanceof LegacyIterator or
      this
          .getACallToThisFunction()
          .getArgument(0)
          .getFullyConverted()
          .getUnspecifiedType()
          .(PointerType)
          .getBaseType() instanceof LegacyIterator
    )
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameter(0) or
      input.isParameter(1)
    ) and
    output.isReturnValue()
  }
}

/**
 * A non-member `operator-` function that takes an iterator as its first argument.
 */
class IteratorSubOperator extends Operator, TaintFunction {
  IteratorSubOperator() {
    this.hasName("operator-") and
    this
        .getACallToThisFunction()
        .getArgument(0)
        .getFullyConverted()
        .getUnspecifiedType()
        .(PointerType)
        .getBaseType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameter(0) or
      input.isParameter(1)
    ) and
    output.isReturnValue()
  }
}

class IteratorAssignArithmeticOperator extends MemberFunction, DataFlowFunction, TaintFunction {
  IteratorAssignArithmeticOperator() {
    (
      this.hasName("operator+=") or
      this.hasName("operator-=")
    ) and
    this.getDeclaringType() instanceof LegacyIterator
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

class IteratorPointerDereferenceMemberOperator extends MemberFunction, TaintFunction {
  IteratorPointerDereferenceMemberOperator() {
    this.hasName("operator*") and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

class IteratorCrementMemberOperator extends MemberFunction, DataFlowFunction, TaintFunction {
  IteratorCrementMemberOperator() {
    (
      this.hasName("operator++") or
      this.hasName("operator--")
    ) and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isQualifierObject()
  }
}

class IteratorFieldMemberOperator extends Operator, TaintFunction {
  IteratorFieldMemberOperator() {
    this.hasName("operator->") and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
  }
}

/**
 * An `operator+` or `operator-` member function of an iterator class.
 */
class IteratorBinaryArithmeticMemberOperator extends MemberFunction, TaintFunction {
  IteratorBinaryArithmeticMemberOperator() {
    this.hasName("operator-") and
    this.getDeclaringType() instanceof LegacyIterator and
    this.getParameter(0).getUnspecifiedType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isQualifierObject() or
      input.isParameter(0)
    ) and
    output.isQualifierObject()
  }
}

class IteratorAssignArithmeticMemberOperator extends MemberFunction, DataFlowFunction, TaintFunction {
  IteratorAssignArithmeticMemberOperator() {
    (
      this.hasName("operator+=") or
      this.hasName("operator-=")
    ) and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isQualifierObject()
  }
}

class IteratorArrayMemberOperator extends MemberFunction, TaintFunction {
  IteratorArrayMemberOperator() {
    this.hasName("operator[]") and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isQualifierObject() or
      input.isParameter(0)
    ) and
    output.isReturnValue()
  }
}