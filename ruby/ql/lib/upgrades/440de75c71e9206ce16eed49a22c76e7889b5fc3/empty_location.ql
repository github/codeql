class EmptyFile extends @file {
  EmptyFile() { files(this, "") }

  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

from EmptyFile f, Location l
where locations_default(l, f, 0, 0, 0, 0)
select l
