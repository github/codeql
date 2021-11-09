import java
import semmle.code.configfiles.ConfigFiles

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

Location unusedLocation() {
  not exists(Top t | t.getLocation() = result) and
  not exists(XMLLocatable x | x.getLocation() = result) and
  not exists(ConfigLocatable c | c.getLocation() = result) and
  not exists(@diagnostic d | diagnostics(d, _, _, _, _, _, result)) and
  not (result.getFile().getExtension() = "xml" and
       result.getStartLine() = 0 and
       result.getStartColumn() = 0 and
       result.getEndLine() = 0 and
       result.getEndColumn() = 0)
}

from string reason, Location l
where reason = "Bad location" and l = badLocation()
   or reason = "Backwards location" and l = backwardsLocation()
   or reason = "Unused location" and l = unusedLocation()
select reason, l

