/** Provides taint models for BDE BDEX deserialization into objects. */

import semmle.code.cpp.models.interfaces.Taint

private class BdexStreamIn extends TaintFunction {
  BdexStreamIn() {
    this.hasQualifiedName("BloombergLP::bslx::InStreamFunctions", "bdexStreamIn") and
    this.getParameter(1).getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType()
      instanceof Class
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isParameterDeref(1)
  }
}
