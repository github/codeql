/**
 * This module provides a hand-modifiable wrapper around the generated class `Crate`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Crate

/**
 * INTERNAL: This module contains the customizable definition of `Crate` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.NamedCrate
  private import codeql.rust.internal.PathResolution

  class Crate extends Generated::Crate {
    override string toStringImpl() {
      result = strictconcat(int i | | this.toStringPart(i) order by i)
    }

    private string toStringPart(int i) {
      i = 0 and result = "Crate("
      or
      i = 1 and result = this.getName()
      or
      i = 2 and result = "@"
      or
      i = 3 and result = this.getVersion()
      or
      i = 4 and result = ")"
    }

    /**
     * Gets the dependency named `name`, if any.
     *
     * `name` may be different from the name of the crate, when the dependency has been
     * renamed in the `Cargo.toml` file, for example in
     *
     * ```yml
     * [dependencies]
     * my_serde = {package = "serde", version = "1.0.217"}
     * ```
     *
     * the name of the dependency is `my_serde`, but the name of the crate is `serde`.
     */
    pragma[nomagic]
    Crate getDependency(string name) {
      exists(NamedCrate c |
        c = this.getANamedDependency() and
        result = c.getCrate() and
        name = c.getName()
      )
    }

    /**
     * Gets any dependency of this crate.
     */
    Crate getADependency() { result = this.getDependency(_) }

    /** Gets the source file that defines this crate, if any. */
    SourceFile getSourceFile() { result.getFile() = this.getModule().getFile() }

    /**
     * Gets a source file that belongs to this crate, if any.
     */
    SourceFile getASourceFile() { result = this.(CrateItemNode).getASourceFile() }

    override Location getLocation() { result = this.getModule().getLocation() }
  }
}
