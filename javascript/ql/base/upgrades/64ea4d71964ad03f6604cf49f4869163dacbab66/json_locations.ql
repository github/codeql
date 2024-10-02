class Locatable extends @locatable {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from Locatable locatable, Location location
where
  hasLocation(locatable, location) and
  (
    locatable instanceof @json_value or
    locatable instanceof @json_parse_error
  )
select locatable, location
