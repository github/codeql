/**
 * This module provides a hand-modifiable wrapper around the generated class `Addressable`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Addressable

/**
 * INTERNAL: This module contains the customizable definition of `Addressable` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.PathResolution

  /**
   * Something that can be addressed by a path.
   *
   * TODO: This does not yet include all possible cases.
   */
  class Addressable extends Generated::Addressable {
    /**
     * Gets the canonical path of this item, if any.
     *
     * The crate `c` is the root of the path.
     *
     * See [The Rust Reference][1] for more details.
     *
     * [1]: https://doc.rust-lang.org/reference/paths.html#canonical-paths
     */
    string getCanonicalPath(Crate c) { result = this.(ItemNode).getCanonicalPath(c) }

    /**
     * Gets the canonical path of this item, if any.
     *
     * See [The Rust Reference][1] for more details.
     *
     * [1]: https://doc.rust-lang.org/reference/paths.html#canonical-paths
     */
    string getCanonicalPath() { result = this.getCanonicalPath(_) }

    /**
     * Holds if this item has a canonical path.
     *
     * See [The Rust Reference][1] for more details.
     *
     * [1]: https://doc.rust-lang.org/reference/paths.html#canonical-paths
     */
    predicate hasCanonicalPath() { exists(this.getCanonicalPath()) }
  }
}
