/**
 * This module provides a hand-modifiable wrapper around the generated class `Function`.
 */

private import codeql.rust.generated.Function

class Function extends Generated::Function {
  override string toString() { result = this.getName() }
}
