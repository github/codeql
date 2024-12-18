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
private import codeql.rust.internal.CachedStages

/**
 * INTERNAL: This module contains the customizable definition of `Locatable` and should not
 * be referenced directly.
 */
module Impl {
  abstract class SynthLocatable extends Locatable {
    pragma[nomagic]
    abstract predicate hasSynthLocationInfo(
      File file, int startline, int startcolumn, int endline, int endcolumn
    );

    final override Location getLocation() {
      exists(File file, int startline, int startcolumn, int endline, int endcolumn |
        this.hasSynthLocationInfo(file, startline, startcolumn, endline, endcolumn) and
        result.hasLocationFileInfo(file, startline, startcolumn, endline, endcolumn)
      )
    }
  }

  class Locatable extends Generated::Locatable {
    cached
    Location getLocation() {
      Stages::AstStage::ref() and
      result = getLocationDefault(this)
    }

    /**
     * Gets the primary file where this element occurs.
     */
    File getFile() { result = this.getLocation().getFile() }
  }

  /** Gets the non-synthesized location of `l`, if any. */
  LocationImpl::LocationDefault getLocationDefault(Locatable l) {
    exists(@location_default location |
      result = LocationImpl::TLocationDefault(location) and
      locatable_locations(Synth::convertLocatableToRaw(l), location)
    )
  }
}
