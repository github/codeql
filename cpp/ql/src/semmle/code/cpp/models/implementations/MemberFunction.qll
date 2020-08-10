/**
 * Provides models for C++ constructors and user-defined operators.
 */

import cpp
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * Model for C++ conversion constructors. As of C++11 this does not correspond
 * perfectly with the language definition of a converting constructor, however,
 * it does correspond with the constructors we are confident taint should flow
 * through.
 */
class ConversionConstructorModel extends Constructor, TaintFunction {
  ConversionConstructorModel() {
    strictcount(Parameter p | p = getAParameter() and not p.hasInitializer()) = 1 and
    not hasSpecifier("explicit")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from the first constructor argument to the returned object
    input.isParameter(0) and
    output.isReturnValue() // TODO: this should be `isQualifierObject` by our current definitions, but that flow is not yet supported.
  }
}

/**
 * Model for C++ copy constructors.
 */
class CopyConstructorModel extends CopyConstructor, DataFlowFunction {
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // data flow from the first constructor argument to the returned object
    input.isParameter(0) and
    output.isReturnValue() // TODO: this should be `isQualifierObject` by our current definitions, but that flow is not yet supported.
  }
}

/**
 * Model for C++ move constructors.
 */
class MoveConstructorModel extends MoveConstructor, DataFlowFunction {
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // data flow from the first constructor argument to the returned object
    input.isParameter(0) and
    output.isReturnValue() // TODO: this should be `isQualifierObject` by our current definitions, but that flow is not yet supported.
  }
}

/**
 * Model for C++ copy assignment operators.
 */
class CopyAssignmentOperatorModel extends CopyAssignmentOperator, TaintFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from argument to self
    input.isParameterDeref(0) and
    output.isQualifierObject()
    or
    // taint flow from argument to return value
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
    // TODO: it would be more accurate to model copy assignment as data flow
  }
}

/**
 * Model for C++ move assignment operators.
 */
class MoveAssignmentOperatorModel extends MoveAssignmentOperator, TaintFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from argument to self
    input.isParameterDeref(0) and
    output.isQualifierObject()
    or
    // taint flow from argument to return value
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
    // TODO: it would be more accurate to model move assignment as data flow
  }
}
