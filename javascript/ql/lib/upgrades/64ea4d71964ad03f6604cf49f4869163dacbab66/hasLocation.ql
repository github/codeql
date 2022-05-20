class Locatable extends @locatable {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from Locatable locatable, Location location
where
  hasLocation(locatable, location) and
  not locatable instanceof @json_value and
  not locatable instanceof @json_parse_error
select locatable, location
