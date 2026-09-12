import cpp

// Locations should either be :0:0:0:0 locations (UnknownLocation, or
// a whole file), or all 4 fields should be positive.
from Location l
where
  [l.getStartLine(), l.getEndLine(), l.getStartColumn(), l.getEndColumn()] != 0 and
  [l.getStartLine(), l.getEndLine(), l.getStartColumn(), l.getEndColumn()] < 1
select l
