private import codeql.swift.generated.Locatable
private import codeql.swift.elements.Location

class Locatable extends LocatableBase {
  override Location getLocation() {
    result = LocatableBase.super.getLocation()
    or
    not exists(LocatableBase.super.getLocation()) and result instanceof UnknownLocation
  }
}
