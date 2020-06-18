/**
 * Provides models for C++ constructors and user-defined operators.
 */

import cpp
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * Model for C++ conversion constructors.
 */
class ConversionConstructorModel extends ConversionConstructor, TaintFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from the first constructor argument to the returned object
    input.isParameter(0) and
    output.isReturnValue()
  }
}

/**
 * Model for C++ copy constructors.
 */
class CopyConstructorModel extends CopyConstructor, DataFlowFunction {
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // data flow from the first constructor argument to the returned object
    input.isParameter(0) and
    output.isReturnValue()
  }
}

/**
 * Model for C++ move constructors.
 */
class MoveConstructorModel extends MoveConstructor, DataFlowFunction {
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // data flow from the first constructor argument to the returned object
    input.isParameter(0) and
    output.isReturnValue()
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
