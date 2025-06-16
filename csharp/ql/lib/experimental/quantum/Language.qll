private import csharp as Language
private import codeql.quantum.experimental.Model

private class UnknownLocation extends Language::Location {
  UnknownLocation() { this.getFile().getAbsolutePath() = "" }
}

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it. There
 * may be several distinct kinds of unknown locations. For example: one for
 * expressions, one for statements and one for other program elements.
 */
private class UnknownDefaultLocation extends UnknownLocation {
  UnknownDefaultLocation() { locations_default(this, _, 0, 0, 0, 0) }
}

module CryptoInput implements InputSig<Language::Location> {
  class DataFlowNode = DataFlow::Node;

  class LocatableElement = Language::Element;

  class UnknownLocation = UnknownDefaultLocation;

  string locationToFileBaseNameAndLineNumberString(Location location) {
    result = location.getFile().getBaseName() + ":" + location.getStartLine()
  }

  LocatableElement dfn_to_element(DataFlow::Node node) {
    result = node.asExpr() or
    result = node.asParameter()
  }

  predicate artifactOutputFlowsToGenericInput(
    DataFlow::Node artifactOutput, DataFlow::Node otherInput
  ) {
    ArtifactFlow::flow(artifactOutput, otherInput)
  }
}

// Instantiate the `CryptographyBase` module
module Crypto = CryptographyBase<Language::Location, CryptoInput>;
