/**
 * This module provides a hand-modifiable wrapper around the generated class `Locatable`.
 *
 * INTERNAL: Do not use.
 */

import codeql.Locations
private import codeql.rust.elements.internal.LocationImpl
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
      exists(@location_default location |
        result = LocationImpl::TLocationDefault(location) and
        locatable_locations(Synth::convertLocatableToRaw(this), location)
      )
      or
      not locatable_locations(Synth::convertLocatableToRaw(this), _) and
      exists(File file, int beginLine, int beginColumn, int endLine, int endColumn |
        this.hasLocationInfo(file.getAbsolutePath(), beginLine, beginColumn, endLine, endColumn)
      |
        result = LocationImpl::TLocationSynth(file, beginLine, beginColumn, endLine, endColumn)
        or
        exists(@location_default location |
          result = LocationImpl::TLocationDefault(location) and
          locations_default(location, file, beginLine, beginColumn, endLine, endColumn)
        )
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
    }

    /**
     * Gets the primary file where this element occurs.
     */
    File getFile() { result = this.getLocation().getFile() }
  }
}
