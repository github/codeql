/**
 * This module provides a hand-modifiable wrapper around the generated class `Impl`.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.generated.Impl
private import codeql.rust.internal.PathResolution as PathResolution
private import codeql.rust.internal.typeinference.Type
private import codeql.rust.internal.typeinference.TypeMention

/**
 * INTERNAL: This module contains the customizable definition of `Impl` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An `impl` block.
   *
   * For example:
   * ```rust
   * impl MyTrait for MyType {
   *     fn foo(&self) {}
   * }
   * ```
   */
  class Impl extends Generated::Impl {
    override string toStringImpl() {
      exists(string trait |
        (
          trait = this.getTraitTy().toAbbreviatedString() + " for "
          or
          not this.hasTraitTy() and trait = ""
        ) and
        result = "impl " + trait + this.getSelfTy().toAbbreviatedString() + " { ... }"
      )
    }

    /**
     * Holds if this is an inherent `impl` block, that is, one that does not implement a trait.
     */
    pragma[nomagic]
    predicate isInherent() { not this.hasTraitTy() }

    /**
     * Gets the type being implemented.
     *
     * For example, in
     *
     * ```rust
     * impl MyType { ... }
     *
     * impl MyTrait for MyType { ... }
     * ```
     *
     * the type being implemented is in both cases`MyType`.
     */
    TypeItem getSelf() {
      result = this.getSelfTy().(TypeMention).getType().(DataType).getTypeItem()
    }

    /**
     * Gets the trait being implemented, if any.
     *
     * For example, in
     *
     * ```rust
     * impl MyType { ... }
     *
     * impl MyTrait for MyType { ... }
     * ```
     *
     * the trait being implemented is in the second case `MyTrait`.
     */
    Trait getTrait() {
      result = PathResolution::resolvePath(this.getTraitTy().(PathTypeRepr).getPath())
    }
  }
}
