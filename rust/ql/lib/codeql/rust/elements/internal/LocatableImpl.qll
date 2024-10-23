/**
 * This module provides a hand-modifiable wrapper around the generated class `Locatable`.
 *
 * INTERNAL: Do not use.
 */

import codeql.Locations
private import codeql.rust.elements.internal.generated.Locatable
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw

/**
 * INTERNAL: This module contains the customizable definition of `Locatable` and should not
 * be referenced directly.
 */
module Impl {
  class Locatable extends Generated::Locatable {
    pragma[nomagic]
    final Location getLocation() {
      exists(Raw::Locatable raw |
        raw = Synth::convertLocatableToRaw(this) and
        locatable_locations(raw, result)
      )
    }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      or
      not exists(this.getLocation()) and
      pragma[only_bind_out](any(EmptyLocation e))
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    /**
     * Gets the primary file where this element occurs.
     */
    File getFile() { result = this.getLocation().getFile() }
  }
}
