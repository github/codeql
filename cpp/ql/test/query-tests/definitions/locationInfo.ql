import definitions

/**
 * An element that is the source of a jump-to-definition link.
 */
class Link extends Top {
  Link() { exists(definitionOf(this, _)) }
}

/**
 * Gets the length of the longest line in file `f`.
 */
pragma[nomagic]
private int maxCols(File f) { result = max(Location l | l.getFile() = f | l.getEndColumn()) }

/**
 * Gets the location of an element that has a link-to-definition (in a similar manner to
 * `Location.charLoc`)
 */
predicate linkLocationInfo(Link e, string filepath, int begin, int end) {
  exists(File f, int maxCols, int startline, int startcolumn, int endline, int endcolumn |
    e.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
    f.getAbsolutePath() = filepath and
    maxCols = maxCols(f) and
    begin = (startline * maxCols) + startcolumn and
    end = (endline * maxCols) + endcolumn
  )
}

/**
 * Gets a string describing a problem with a `Link`.
 */
string issues(Link e) {
  strictcount(Top def | def = definitionOf(e, _)) > 1 and
  result = "has more than one definition"
  or
  exists(string filepath1, int begin1, int end1, Link e2, string filepath2, int begin2, int end2 |
    linkLocationInfo(e, filepath1, begin1, end1) and
    linkLocationInfo(e2, filepath2, begin2, end2) and
    filepath1 = filepath2 and
    not end1 < begin2 and
    not begin1 > end2 and
    e != e2 and
    not e.isFromTemplateInstantiation(_) and
    not e2.isFromTemplateInstantiation(_)
  ) and
  result = "overlaps another link"
}

from Link e
select e, issues(e)
