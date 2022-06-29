private import codeql.swift.generated.Locatable
private import codeql.swift.elements.File

class Locatable extends LocatableBase {
  pragma[nomagic]
  override Location getLocation() {
    result = LocatableBase.super.getLocation()
    or
    not exists(LocatableBase.super.getLocation()) and result instanceof UnknownLocation
  }

  /**
   * Gets the primary file where this element occurs.
   */
  File getFile() { result = getLocation().getFile() }
}
