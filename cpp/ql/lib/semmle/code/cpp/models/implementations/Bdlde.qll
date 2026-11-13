/**
 * Models direct pointer-buffer conversions in the BDE bdlde library.
 * See https://github.com/bloomberg/bde/tree/ec310b87e008199ecbdbc00a0b0264a53d806a0a/groups/bdl/bdlde.
 */

import semmle.code.cpp.models.interfaces.Taint

/** A conversion whose input and output iterators are pointers. */
private class BdldePointerConversion extends TaintFunction {
  int beginIndex;

  BdldePointerConversion() {
    this.hasName("convert") and
    this.getDeclaringType()
        .hasQualifiedName("BloombergLP::bdlde",
          ["Base64Encoder", "Base64Decoder", "HexEncoder", "HexDecoder"]) and
    (
      this.getNumberOfParameters() = 3 and beginIndex = 1
      or
      this.getNumberOfParameters() = 6 and beginIndex = 3
    ) and
    // Check instantiated types. A generic template signature would also match
    // iterator objects and replace their bodies with an inapplicable summary.
    this.getParameter(0).getUnspecifiedType() instanceof PointerType and
    this.getParameter(beginIndex).getUnspecifiedType() instanceof PointerType and
    this.getParameter(beginIndex + 1).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(beginIndex) and output.isParameterDeref(0)
  }
}
