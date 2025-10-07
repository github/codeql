/**
 * This module provides a hand-modifiable wrapper around the generated class `DynTraitTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.DynTraitTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `DynTraitTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.PathResolution as PathResolution

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A dynamic trait object type.
   *
   * For example:
   * ```rust
   * let x: &dyn Debug;
   * //      ^^^^^^^^^
   * ```
   */
  class DynTraitTypeRepr extends Generated::DynTraitTypeRepr {
    /** Gets the trait that this trait object refers to. */
    pragma[nomagic]
    Trait getTrait() {
      result =
        PathResolution::resolvePath(this.getTypeBoundList()
              .getBound(0)
              .getTypeRepr()
              .(PathTypeRepr)
              .getPath())
    }
  }
}
