private import codeql.swift.generated.UnknownLocation
private import codeql.swift.elements.UnknownFile
private import codeql.swift.elements.File

module Impl {
  /**
   * A `Location` that is given to something that is not associated with any position in the source code.
   */
  class UnknownLocation extends Generated::UnknownLocation {
    override File getFile() { result instanceof UnknownFile }

    override int getStartLine() { result = 0 }

    override int getStartColumn() { result = 0 }

    override int getEndLine() { result = 0 }

    override int getEndColumn() { result = 0 }

    override string toString() { result = "UnknownLocation" }
  }
}
