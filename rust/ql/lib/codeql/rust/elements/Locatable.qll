/**
 * This module provides a hand-modifiable wrapper around the generated class `Locatable`.
 */

private import codeql.rust.generated.Locatable
private import codeql.rust.elements.File
private import codeql.rust.elements.UnknownLocation

class Locatable extends Generated::Locatable {
  pragma[nomagic]
  override Location getLocation() {
    result = Generated::Locatable.super.getLocation()
    or
    not exists(Generated::Locatable.super.getLocation()) and
    result instanceof UnknownLocation
  }

  /**
   * Gets the primary file where this element occurs.
   */
  File getFile() { result = this.getLocation().getFile() }
}
