/**
 * Provides classes modelling taint propagation through the `json-iterator` package.
 */

import go

/** Models json-iterator's Unmarshal function, propagating taint from the JSON input to the decoded object. */
private class JsonIteratorUnmarshalFunction extends TaintTracking::FunctionModel,
  UnmarshalingFunction::Range {
  JsonIteratorUnmarshalFunction() {
    this.hasQualifiedName("github.com/json-iterator/go", "Unmarshal")
  }

  override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

  override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

  override string getFormat() { result = "JSON" }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp = getAnInput() and outp = getOutput()
  }
}
