private import codeql.utils.Locations as Locs
import codeql.ruby.internal.LocationsImpl::Inst

/** An entity representing an empty location. */
class EmptyLocation extends Location {
  EmptyLocation() { this.hasLocationInfo("", 0, 0, 0, 0) }
}
