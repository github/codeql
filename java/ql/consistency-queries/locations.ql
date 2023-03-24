import java
import semmle.code.configfiles.ConfigFiles
import semmle.code.java.Diagnostics

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

// Normally a location should tag at least one locatable entity.
// Note this is not absolutely necessarily a bug (it does not always indicate a location is
// an orphan in database terms), because classes that are seen both as source code and as a
// .class file are extracted using both locations, with `Top.getLocation` filtering out the
// class-file location when both a source- and a class-file location are  present in the
// database. However at present the Java extractor always uses the class-file location at
// least to locate a `File`, so such a location does end up with a single use.
Location unusedLocation() {
  not exists(Top t | t.getLocation() = result) and
  not exists(XmlLocatable x | x.getLocation() = result) and
  not exists(ConfigLocatable c | c.getLocation() = result) and
  not exists(Diagnostic d | d.getLocation() = result) and
  not (
    result.getFile().getExtension() = "xml" and
    result.getStartLine() = 0 and
    result.getStartColumn() = 0 and
    result.getEndLine() = 0 and
    result.getEndColumn() = 0
  )
}

from string reason, Location l
where
  reason = "Bad location" and l = badLocation()
  or
  reason = "Backwards location" and l = backwardsLocation()
  or
  reason = "Unused location" and l = unusedLocation()
select reason, l
