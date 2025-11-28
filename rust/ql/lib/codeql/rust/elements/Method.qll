/**
 * This module provides the public class `Method`.
 */

private import rust

/**
 * A method declaration. For example
 * ```rust
 * fn foo(self, x: u32) -> u64 { (x + 1).into() }
 * ```
 *
 * A method declaration within a trait might not have a body:
 * ```rust
 * trait Trait {
 *     fn bar(self);
 * }
 * ```
 */
final class Method extends Function {
  Method() { this.hasSelfParam() }
}
