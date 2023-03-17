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

  private class MarshalFunction extends MarshalingFunction::Range {
    MarshalFunction() { this.hasQualifiedName(packagePath(), "Marshal") }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "yaml" }
  }

  private class UnmarshalFunction extends UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName(packagePath(), ["Unmarshal", "UnmarshalStrict"]) }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "yaml" }
  }

  // These models are not implemented using Models-as-Data because they represent reverse flow.
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      this.hasQualifiedName(packagePath(), "NewEncoder") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
