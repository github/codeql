import java

// Locations should either be :0:0:0:0 locations (UnknownLocation, or
// a whole file), or all 4 fields should be positive.
Location badLocation() {
  [result.getStartLine(), result.getEndLine(), result.getStartColumn(), result.getEndColumn()] != 0 and
  [result.getStartLine(), result.getEndLine(), result.getStartColumn(), result.getEndColumn()] < 1
}

// The start should not be after the end.
Location backwardsLocation() {
  result.getStartLine() > result.getEndLine()
  or
  result.getStartLine() = result.getEndLine() and
  result.getStartColumn() > result.getEndColumn()
}

from Location l
where l = badLocation() or l = backwardsLocation()
select l

