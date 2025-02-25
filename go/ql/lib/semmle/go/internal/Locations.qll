/** Provides classes for working with locations and program elements that have locations. */

import go

/** Provides the input to `LocationClass`. */
signature module LocationClassInputSig {
  class Base;

  predicate locationInfo(
    Base b, string filepath, int startline, int startcolumn, int endline, int endcolumn
  );

  File getFile(Base b);
}

/** Provides a class layer for locations. */
module LocationClass<LocationClassInputSig Input> {
  private import Input

  /**
   * A location as given by a file, a start line, a start column,
   * an end line, and an end column.
   *
   * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  final class Location instanceof Base {
    /** Gets the file for this location. */
    File getFile() { result = getFile(this) }

    /** Gets the 1-based line number (inclusive) where this location starts. */
    int getStartLine() { locationInfo(this, _, result, _, _, _) }

    /** Gets the 1-based column number (inclusive) where this location starts. */
    int getStartColumn() { locationInfo(this, _, _, result, _, _) }

    /** Gets the 1-based line number (inclusive) where this location ends. */
    int getEndLine() { locationInfo(this, _, _, _, result, _) }

    /** Gets the 1-based column number (inclusive) where this location ends. */
    int getEndColumn() { locationInfo(this, _, _, _, _, result) }

    /** Gets the number of lines covered by this location. */
    int getNumLines() { result = this.getEndLine() - this.getStartLine() + 1 }

    /** Gets a textual representation of this element. */
    string toString() {
      exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
        this.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
        result = filepath + "@" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
      )
    }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      locationInfo(this, filepath, startline, startcolumn, endline, endcolumn)
    }
  }
}

pragma[nomagic]
predicate basicBlockLocation(
  BasicBlock bb, string filepath, int startline, int startcolumn, int endline, int endcolumn
) {
  bb.getFirstNode().hasLocationInfo(filepath, startline, startcolumn, _, _) and
  bb.getLastNode().hasLocationInfo(_, _, _, endline, endcolumn)
}

// Should _not_ be cached, as that would require the data flow stage to be evaluated
// in order to evaluate the AST stage. Ideally, we would cache each injector separately,
// but that's not possible. Instead, we cache all predicates that need the injectors
// to be tuple numbered.
newtype TLocation =
  TDbLocation(@location loc) or
  TBasicBlockLocation(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    basicBlockLocation(_, filepath, startline, startcolumn, endline, endcolumn) and
    // avoid overlap with existing DB locations
    not existingDBLocation(filepath, startline, startcolumn, endline, endcolumn)
  } or
  TDataFlowNodeLocation(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    any(DataFlow::Node n).hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
    // avoid overlap with existing DB or basic block locations
    not existingDBOrBasicBlockLocation(filepath, startline, startcolumn, endline, endcolumn)
  }

pragma[nomagic]
private predicate existingDBLocation(
  string filepath, int startline, int startcolumn, int endline, int endcolumn
) {
  exists(File f |
    locations_default(_, f, startline, startcolumn, endline, endcolumn) and
    f.getAbsolutePath() = filepath
  )
}

pragma[nomagic]
private predicate existingDBOrBasicBlockLocation(
  string filepath, int startline, int startcolumn, int endline, int endcolumn
) {
  existingDBLocation(filepath, startline, startcolumn, endline, endcolumn)
  or
  basicBlockLocation(_, filepath, startline, startcolumn, endline, endcolumn)
}

cached
private module Cached {
  cached
  DbLocation getLocatableLocation(@locatable l) {
    exists(@location loc |
      has_location(l, loc) or
      xmllocations(l, loc)
    |
      result = TDbLocation(loc)
    )
  }

  cached
  DbLocation getDiagnosticLocation(@diagnostic d) {
    exists(@location loc |
      diagnostics(d, _, _, _, _, loc) and
      result = TDbLocation(loc)
    )
  }

  cached
  predicate dbLocationInfo(
    DbLocation l, File f, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(@location loc |
      l = TDbLocation(loc) and
      locations_default(loc, f, startline, startcolumn, endline, endcolumn)
    )
  }
}

import Cached

cached
private module BasicBlocks {
  cached
  predicate basicBlockLocationInfo(
    DbOrBasicBlockLocation l, string filepath, int startline, int startcolumn, int endline,
    int endcolumn
  ) {
    l = TBasicBlockLocation(filepath, startline, startcolumn, endline, endcolumn)
  }

  cached
  DbOrBasicBlockLocation getBasicBlockLocation(BasicBlock bb) {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      basicBlockLocation(bb, filepath, startline, startcolumn, endline, endcolumn) and
      result.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }
}

import BasicBlocks

cached
private module DataFlowNodes {
  cached
  predicate dataFlowNodeLocationInfo(
    Location l, string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    l = TDataFlowNodeLocation(filepath, startline, startcolumn, endline, endcolumn)
  }

  cached
  Location getDataFlowNodeLocation(DataFlow::Node n) {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      n.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      result.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }
}

import DataFlowNodes
