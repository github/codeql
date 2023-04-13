/**
 * Provides classes modeling taint propagation through marshalling and encoding functions.
 */

import go

/** Gets the package name `github.com/json-iterator/go`. */
private string packagePath() { result = package("github.com/json-iterator/go", "") }

/** A model of json-iterator's `Unmarshal` function, propagating taint from the JSON input to the decoded object. */
private class JsonIteratorUnmarshalFunction extends UnmarshalingFunction::Range {
  JsonIteratorUnmarshalFunction() {
    this.hasQualifiedName(packagePath(), ["Unmarshal", "UnmarshalFromString"])
    or
    this.(Method).implements(packagePath(), "API", ["Unmarshal", "UnmarshalFromString"])
  }

  override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

  override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

  override string getFormat() { result = "JSON" }
}
