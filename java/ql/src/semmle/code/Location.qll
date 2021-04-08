/**
 * Provides classes and predicates for working with locations.
 *
 * Locations represent parts of files and are used to map elements to their source location.
 */

import FileSystem
import semmle.code.java.Element

/** Holds if element `e` has name `name`. */
predicate hasName(Element e, string name) {
  classes(e, name, _, _)
  or
  interfaces(e, name, _, _)
  or
  primitives(e, name)
  or
  constrs(e, name, _, _, _, _)
  or
  methods(e, name, _, _, _, _)
  or
  fields(e, name, _, _, _)
  or
  packages(e, name)
  or
  files(e, _, name, _, _)
  or
  paramName(e, name)
  or
  exists(int pos |
    params(e, _, pos, _, _) and
    not paramName(e, _) and
    name = "p" + pos
  )
  or
  localvars(e, name, _, _)
  or
  typeVars(e, name, _, _, _)
  or
  wildcards(e, name, _)
  or
  arrays(e, name, _, _, _)
  or
  modifiers(e, name)
}

/**
 * Top is the root of the QL type hierarchy; it defines some default
 * methods for obtaining locations and a standard `toString()` method.
 */
class Top extends @top {
  /** Gets the source location for this element. */
  Location getLocation() { fixedHasLocation(this, result, _) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f, Location l | fixedHasLocation(this, l, f) |
      locations_default(l, f, startline, startcolumn, endline, endcolumn) and
      filepath = f.getAbsolutePath()
    )
  }

  /** Gets the file associated with this element. */
  File getFile() { fixedHasLocation(this, _, result) }

  /**
   * Gets the total number of lines that this element ranges over,
   * including lines of code, comment and whitespace-only lines.
   */
  int getTotalNumberOfLines() { numlines(this, result, _, _) }

  /** Gets the number of lines of code that this element ranges over. */
  int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of comment lines that this element ranges over. */
  int getNumberOfCommentLines() { numlines(this, _, _, result) }

  /** Gets a textual representation of this element. */
  cached
  string toString() { hasName(this, result) }
}

/** A location maps language elements to positions in source files. */
class Location extends @location {
  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { locations_default(this, _, result, _, _, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { locations_default(this, _, _, result, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { locations_default(this, _, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { locations_default(this, _, _, _, _, result) }

  /**
   * Gets the total number of lines that this location ranges over,
   * including lines of code, comment and whitespace-only lines.
   */
  int getNumberOfLines() {
    exists(@sourceline s | hasLocation(s, this) |
      numlines(s, result, _, _)
      or
      not numlines(s, _, _, _) and result = 0
    )
  }

  /** Gets the number of lines of code that this location ranges over. */
  int getNumberOfLinesOfCode() {
    exists(@sourceline s | hasLocation(s, this) |
      numlines(s, _, result, _)
      or
      not numlines(s, _, _, _) and result = 0
    )
  }

  /** Gets the number of comment lines that this location ranges over. */
  int getNumberOfCommentLines() {
    exists(@sourceline s | hasLocation(s, this) |
      numlines(s, _, _, result)
      or
      not numlines(s, _, _, _) and result = 0
    )
  }

  /** Gets the file containing this location. */
  File getFile() { locations_default(this, result, _, _, _, _) }

  /** Gets a string representation containing the file and range for this location. */
  string toString() {
    exists(File f, int startLine, int endLine |
      locations_default(this, f, startLine, _, endLine, _)
    |
      if endLine = startLine
      then result = f.toString() + ":" + startLine.toString()
      else result = f.toString() + ":" + startLine.toString() + "-" + endLine.toString()
    )
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f | locations_default(this, f, startline, startcolumn, endline, endcolumn) |
      filepath = f.getAbsolutePath()
    )
  }
}

private predicate hasSourceLocation(Top l, Location loc, File f) {
  hasLocation(l, loc) and f = loc.getFile() and f.getExtension() = "java"
}

cached
private predicate fixedHasLocation(Top l, Location loc, File f) {
  hasSourceLocation(l, loc, f)
  or
  hasLocation(l, loc) and not hasSourceLocation(l, _, _) and locations_default(loc, f, _, _, _, _)
}
