private import codeql.swift.generated.Locatable
private import codeql.swift.elements.File
private import codeql.swift.elements.UnknownLocation

class Locatable extends LocatableBase {
  pragma[nomagic]
  override Location getImmediateLocation() {
    result = LocatableBase.super.getImmediateLocation()
    or
    not exists(LocatableBase.super.getImmediateLocation()) and result instanceof UnknownLocation
  }

  /**
   * Gets the primary file where this element occurs.
   */
  File getFile() { result = getLocation().getFile() }
}
