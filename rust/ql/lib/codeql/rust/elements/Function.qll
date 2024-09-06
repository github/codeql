/**
 * This module provides a hand-modifiable wrapper around the generated class `Function`.
 */

private import codeql.rust.generated.Function

// the following QLdoc is generated: if you need to edit it, do it in the schema file
/**
 * A function declaration. For example
 * ```
 * fn foo(x: u32) -> u64 { (x + 1).into()
 *  }
 * ```
 * A function declaration within a trait might not have a body:
 * ```
 * trait Trait {
 *     fn bar();
 * }
 * ```
 */
class Function extends Generated::Function {
  override string toString() { result = this.getName() }
}
