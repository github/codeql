/**
 * This module provides a hand-modifiable wrapper around the generated class `UnknownFile`.
 */

private import codeql.rust.generated.UnknownFile

class UnknownFile extends Generated::UnknownFile {
  override string getName() { result = "" }
}
