/**
 * This module provides a hand-modifiable wrapper around the generated class `UnknownLocation`.
 */

private import codeql.rust.generated.UnknownLocation
private import codeql.rust.elements.File
private import codeql.rust.elements.UnknownFile

class UnknownLocation extends Generated::UnknownLocation {
  override File getFile() { result instanceof UnknownFile }

  override int getStartLine() { result = 0 }

  override int getStartColumn() { result = 0 }

  override int getEndLine() { result = 0 }

  override int getEndColumn() { result = 0 }

  override string toString() { result = "UnknownLocation" }
}
