class LocationBase = @location_default or @location_stmt or @location_expr;

class Location extends LocationBase {
  string toString() { none() }
}

class Container extends @container {
  string toString() { none() }
}

from Location l, Container c, int startLine, int startColumn, int endLine, int endColumn
where
  locations_default(l, c, startLine, startColumn, endLine, endColumn)
  or
  locations_stmt(l, c, startLine, startColumn, endLine, endColumn)
  or
  locations_expr(l, c, startLine, startColumn, endLine, endColumn)
select l, c, startLine, startColumn, endLine, endColumn
