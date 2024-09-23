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
        (
          locatable_locations(raw, result)
          or
          not exists(Location loc | locatable_locations(raw, loc)) and
          result instanceof EmptyLocation
        )
      )
    }

    /**
     * Gets the primary file where this element occurs.
     */
    File getFile() { result = this.getLocation().getFile() }
  }
}
