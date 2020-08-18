import cpp
import semmle.code.cpp.models.interfaces.Taint

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

class IteratorByStdIteratorTraits extends Type { }

class LegacyIterator extends Type {
  LegacyIterator() {
    this instanceof IteratorByTypedefs or
    exists(IteratorTraits it | it.getIteratorType() = this)
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

class IteratorCrementOperator extends Operator, TaintFunction {
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
        .getUnderlyingType()
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
    (
      this.hasName("operator+")
    ) and
    (
    this
        .getACallToThisFunction()
        .getArgument(0)
        .getFullyConverted()
        .getUnderlyingType()
        .(PointerType)
        .getBaseType() instanceof LegacyIterator or
    this
        .getACallToThisFunction()
        .getArgument(0)
        .getFullyConverted()
        .getUnderlyingType()
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

class IteratorSubOperator extends Operator, TaintFunction {
  IteratorSubOperator() {
    (
      this.hasName("operator-")
    ) and
    this
        .getACallToThisFunction()
        .getArgument(0)
        .getFullyConverted()
        .getUnderlyingType()
        .(PointerType)
        .getBaseType() instanceof LegacyIterator and
    not this
        .getACallToThisFunction()
        .getArgument(1)
        .getFullyConverted()
        .getUnderlyingType()
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

class IteratorDiffOperator extends Operator, TaintFunction {
  IteratorDiffOperator() {
    (
      this.hasName("operator-")
    ) and
    this
        .getACallToThisFunction()
        .getArgument(0)
        .getFullyConverted()
        .getUnderlyingType()
        .(PointerType)
        .getBaseType() instanceof LegacyIterator and
    not this
        .getACallToThisFunction()
        .getArgument(1)
        .getFullyConverted()
        .getUnderlyingType()
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

class IteratorCrementMemberOperator extends MemberFunction, TaintFunction {
  IteratorCrementMemberOperator() {
    (
      this.hasName("operator++") or
      this.hasName("operator--")
    ) and
    this.getDeclaringType() instanceof LegacyIterator
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

class IteratorMemberBinaryOperator extends MemberFunction, TaintFunction {
  IteratorMemberBinaryOperator() {
    (
      this.hasName("operator+") or
      this.hasName("operator-")
    ) and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isQualifierObject() or
      input.isParameter(0)
    ) and
    output.isQualifierObject()
  }
}

class IteratorMemberAssignOperator extends MemberFunction, TaintFunction {
  IteratorMemberAssignOperator() {
    (
      this.hasName("operator+=") or
      this.hasName("operator-=")
    ) and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isQualifierObject() or
      input.isParameter(0)
    ) and
    output.isQualifierObject()
    or
    output.isReturnValue()
  }
}
