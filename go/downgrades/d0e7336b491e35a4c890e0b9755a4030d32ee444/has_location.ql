class Locatable_ extends @locatable {
  string toString() { result = "Locatable" }
}

class Location_ extends @location {
  string toString() { result = "Location" }
}

class Expr_ extends @expr {
  string toString() { result = "Expr" }
}

// The schema for has_location is:
//
// has_location(unique int locatable: @locatable ref, int location: @location ref);
//
// The synthesized `@rangeelementexpr` nodes (kind 55) are removed by the
// accompanying `exprs` downgrade, so their locations must be removed too.
from Locatable_ locatable, Location_ location
where
  has_location(locatable, location) and
  not exists(Expr_ e | e = locatable and exprs(e, 55, _, _))
select locatable, location
