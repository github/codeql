class Locatable extends @locatable {
  string toString() { result = "locatable" }
}

class Location extends @location {
  string toString() { result = "location" }
}

class ParExpr extends Locatable, @parexpr {
  override string toString() { result = "(...)" }
}

from Locatable locatable, Location location
where
  hasLocation(locatable, location) and
  not locatable instanceof ParExpr
select locatable, location
