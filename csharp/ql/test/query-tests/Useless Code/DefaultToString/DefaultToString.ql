import csharp
import Useless_code.DefaultToStringQuery

class MyDefaultToStringType extends DefaultToStringType {
  // A workaround for generating empty URLs for non-source locations, because qltest
  // does not support non-source locations
  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(Location l | l = this.getLocation() |
      if l instanceof SourceLocation
      then l.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      else
        any(EmptyLocation el).hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }
}
