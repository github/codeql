/**
 * This module provides a hand-modifiable wrapper around the generated class `UnknownFile`.
 */

private import codeql.rust.generated.UnknownFile

class UnknownFileImpl extends Generated::UnknownFileImpl {
  override string getName() { result = "" }
}
