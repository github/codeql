private import codeql.swift.generated.Locatable
private import codeql.swift.elements.File
private import codeql.swift.elements.UnknownLocation

module Impl {
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
}
