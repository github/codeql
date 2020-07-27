/**
 * Provides classes modelling taint propagation through marshalling and encoding functions.
 */

import go

/** A model of json-iterator's `Unmarshal` function, propagating taint from the JSON input to the decoded object. */
private class JsonIteratorUnmarshalFunction extends TaintTracking::FunctionModel,
  UnmarshalingFunction::Range {
  JsonIteratorUnmarshalFunction() {
    this.hasQualifiedName("github.com/json-iterator/go", ["Unmarshal", "UnmarshalFromString"])
    or
    exists(Method m |
      m.hasQualifiedName("github.com/json-iterator/go", "API", ["Unmarshal", "UnmarshalFromString"]) and
      this.(Method).implements(m)
    )
  }

  override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

  override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

  override string getFormat() { result = "JSON" }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp = getAnInput() and outp = getOutput()
  }
}
