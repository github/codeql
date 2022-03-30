/**
 * Provides classes for working with the [gopkg.in/yaml](https://pkg.go.dev/gopkg.in/yaml.v3) package.
 */

import go

/**
 * Provides classes for working with the [gopkg.in/yaml](https://pkg.go.dev/gopkg.in/yaml.v3) package.
 */
module Yaml {
  /** Gets a package path for the Yaml package. */
  string packagePath() { result = package("gopkg.in/yaml", "") }

  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    MarshalFunction() { this.hasQualifiedName(packagePath(), "Marshal") }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = this.getAnInput() and output = this.getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "yaml" }
  }

  private class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName(packagePath(), ["Unmarshal", "UnmarshalStrict"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = this.getAnInput() and output = this.getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "yaml" }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      this.hasQualifiedName(packagePath(), "NewDecoder") and
      (inp.isParameter(0) and outp.isResult())
      or
      this.hasQualifiedName(packagePath(), "NewEncoder") and
      (inp.isResult() and outp.isParameter(0))
      or
      exists(Method m | this = m |
        m.hasQualifiedName(packagePath(), ["Decoder", "Node"], "Decode") and
        (inp.isReceiver() and outp.isParameter(0))
        or
        m.hasQualifiedName(packagePath(), ["Encoder", "Node"], "Encode") and
        (inp.isParameter(0) and outp.isReceiver())
        or
        m.hasQualifiedName(packagePath(), "Node", "SetString") and
        (inp.isParameter(0) and outp.isReceiver())
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
