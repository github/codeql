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

class IteratorOperatorStar extends Operator, TaintFunction {
  IteratorOperatorStar() {
    this.hasName("operator*") and
    this.getACallToThisFunction().getArgument(0).getFullyConverted().getUnderlyingType() instanceof
      LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

class IteratorOperatorPlusPlus extends Operator, TaintFunction {
  IteratorOperatorPlusPlus() {
    this.hasName("operator++") and
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


class IteratorOperatorMinusMinus extends Operator, TaintFunction {
    IteratorOperatorMinusMinus() {
      this.hasName("operator++") and
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
class IteratorOperatorArrow extends Operator, TaintFunction {
  IteratorOperatorArrow() {
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

class IteratorMemberOperatorStar extends MemberFunction, TaintFunction {
  IteratorMemberOperatorStar() {
    this.hasName("operator*") and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

class IteratorMemberOperatorPlusPlus extends MemberFunction, TaintFunction {
  IteratorMemberOperatorPlusPlus() {
    this.hasName("operator++") and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isQualifierObject()
  }
}

class IteratorMemberOperatorArrow extends Operator, TaintFunction {
  IteratorMemberOperatorArrow() {
    this.hasName("operator->") and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierAddress() and
    output.isReturnValue()
  }
}

class IteratorMemberOperatorMinusMinus extends MemberFunction, TaintFunction {
  IteratorMemberOperatorMinusMinus() {
    this.hasName("operator--") and
    this.getDeclaringType() instanceof LegacyIterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isQualifierObject()
  }
}
