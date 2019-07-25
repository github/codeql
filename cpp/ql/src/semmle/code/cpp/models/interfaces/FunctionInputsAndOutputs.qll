/**
 * Provides a set of QL classes for indicating dataflows through a particular
 * parameter, return value, or qualifier, as well as flows at one level of
 * pointer indirection.
 */

import semmle.code.cpp.Parameter

/**
 * An `int` that is a parameter index for some function.  This is needed for binding in certain cases.
 */
class ParameterIndex extends int {
  ParameterIndex() { exists(Parameter p | this = p.getIndex()) }
}

newtype TFunctionInput =
  TInParameter(ParameterIndex i)
  or
  TInParameterPointer(ParameterIndex i)
  or
  TInQualifier()
  or
  TInReturnValue()

class FunctionInput extends TFunctionInput {
  abstract string toString();
  
  predicate isInParameter(ParameterIndex index) {
    none()
  }
  
  predicate isInParameterPointer(ParameterIndex index) {
    none()
  }
  
  predicate isInQualifier() {
    none()
  }
  
  predicate isInReturnValue() {
    none()
  }
}

class InParameter extends FunctionInput, TInParameter {
  ParameterIndex index;
  
  InParameter() {
    this = TInParameter(index)
  }
  
  override string toString() {
    result = "InParameter " + index.toString()
  }
  
  ParameterIndex getIndex() {
    result = index
  }
  
  override predicate isInParameter(ParameterIndex i) {
    i = index
  }
}

class InParameterPointer extends FunctionInput, TInParameterPointer {
  ParameterIndex index;
  
  InParameterPointer() {
    this = TInParameterPointer(index)
  }
  
  override string toString() {
    result = "InParameterPointer " + index.toString()
  }
  
  ParameterIndex getIndex() {
    result = index
  }

  override predicate isInParameterPointer(ParameterIndex i) {
    i = index
  }
}

class InQualifier extends FunctionInput, TInQualifier {
  override string toString() {
    result = "InQualifier"
  }
  
  override predicate isInQualifier() {
    any()
  }
}

class InReturnValue extends FunctionInput, TInReturnValue {
  override string toString() {
    result = "InReturnValue"
  }
  
  override predicate isInReturnValue() {
    any()
  }
}

newtype TFunctionOutput =
  TOutParameterPointer(ParameterIndex i)
  or
  TOutQualifier()
  or
  TOutReturnValue()
  or
  TOutReturnPointer()


class FunctionOutput extends TFunctionOutput {
  abstract string toString();
  
  predicate isOutParameterPointer(ParameterIndex i) {
    none()
  }
  
  predicate isOutQualifier() {
    none()
  }
  
  predicate isOutReturnValue() {
    none()
  }
  
  predicate isOutReturnPointer() {
    none()
  }
}

class OutParameterPointer extends FunctionOutput, TOutParameterPointer {
  ParameterIndex index;
  
  OutParameterPointer() {
    this = TOutParameterPointer(index)
  }
  
  override string toString() {
    result = "OutParameterPointer " + index.toString()
  }
  
  ParameterIndex getIndex() {
    result = index
  }
  
  override predicate isOutParameterPointer(ParameterIndex i) {
    i = index
  }
}

class OutQualifier extends FunctionOutput, TOutQualifier {
  override string toString() {
    result = "OutQualifier"
  }
  
  override predicate isOutQualifier() {
    any()
  }
}

class OutReturnValue extends FunctionOutput, TOutReturnValue {
  override string toString() {
    result = "OutReturnValue"
  }
  
  override predicate isOutReturnValue() {
    any()
  }
}

class OutReturnPointer extends FunctionOutput, TOutReturnPointer {
  override string toString() {
    result = "OutReturnPointer"
  }
  
  override predicate isOutReturnPointer() {
    any()
  }
}