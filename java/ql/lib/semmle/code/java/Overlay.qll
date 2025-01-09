overlay[local?]
module;

import java

overlay[local]
pragma[nomagic]
predicate hasOverlay() { databaseMetadata("isOverlay", "true") }

overlay[local]
string getRawFile(@locatable el) {
  exists(@location loc, @file file |
    hasLocation(el, loc) and
    locations_default(loc, file, _, _, _, _) and
    files(file, result)
  )
}

overlay[local]
string getRawFileForLoc(@location l) {
  exists(@file f | locations_default(l, f, _, _, _, _) and files(f, result))
}

overlay[local]
pragma[nomagic]
predicate discardFile(string file) {
  hasOverlay() and
  exists(@expr e | callableEnclosingExpr(e, _) and file = getRawFile(e))
}
