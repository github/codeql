private import codeql.swift.generated.Locatable
private import codeql.swift.elements.File
private import codeql.swift.elements.UnknownLocation

class Locatable extends Generated::Locatable {
  pragma[nomagic]
  override Location getImmediateLocation() {
    result = Generated::Locatable.super.getImmediateLocation()
    or
    not exists(Generated::Locatable.super.getImmediateLocation()) and
    result instanceof UnknownLocation
  }

  /**
   * Gets the primary file where this element occurs.
   */
  File getFile() { result = getLocation().getFile() }
}
