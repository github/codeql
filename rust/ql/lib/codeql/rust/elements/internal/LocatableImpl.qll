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
  abstract class SynthLocatable extends Locatable {
    abstract predicate hasSynthLocationInfo(
      File file, int startline, int startcolumn, int endline, int endcolumn
    );

    final override Location getLocation() {
      not locatable_locations(Synth::convertLocatableToRaw(this), _) and
      exists(File file, int beginLine, int beginColumn, int endLine, int endColumn |
        this.hasSynthLocationInfo(file, beginLine, beginColumn, endLine, endColumn)
      |
        result = LocationImpl::TLocationSynth(file, beginLine, beginColumn, endLine, endColumn)
        or
        exists(@location_default location |
          result = LocationImpl::TLocationDefault(location) and
          locations_default(location, file, beginLine, beginColumn, endLine, endColumn)
        )
      )
    }
  }

  class Locatable extends Generated::Locatable {
    pragma[nomagic]
    Location getLocation() {
      exists(@location_default location |
        result = LocationImpl::TLocationDefault(location) and
        locatable_locations(Synth::convertLocatableToRaw(this), location)
      )
    }

    /**
     * Gets the primary file where this element occurs.
     */
    File getFile() { result = this.getLocation().getFile() }
  }
}
