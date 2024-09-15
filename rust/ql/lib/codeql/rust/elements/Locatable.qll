/**
 * This module provides a hand-modifiable wrapper around the generated class `Locatable`.
 */

private import codeql.rust.generated.Locatable
import codeql.Locations
private import codeql.rust.generated.Synth
private import codeql.rust.generated.Raw

class Locatable extends Generated::Locatable {
  /** Gets the primary location of this element. */
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
