class Locatable extends @locatable {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from Locatable locatable, Location location
where
  hasLocation(locatable, location) and
  not locatable instanceof @yaml_node and
  not locatable instanceof @yaml_error
select locatable, location
