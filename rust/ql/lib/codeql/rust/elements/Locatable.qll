/**
 * This module provides a hand-modifiable wrapper around the generated class `Locatable`.
 */

private import codeql.rust.generated.Locatable
private import codeql.rust.elements.File
private import codeql.rust.elements.UnknownLocation

class LocatableImpl extends Generated::LocatableImpl {
  pragma[nomagic]
  override Location getLocation() {
    result = Generated::LocatableImpl.super.getLocation()
    or
    not exists(Generated::LocatableImpl.super.getLocation()) and
    result instanceof UnknownLocation
  }

  /**
   * Gets the primary file where this element occurs.
   */
  File getFile() { result = this.getLocation().getFile() }
}

final class Locatable = LocatableImpl;
