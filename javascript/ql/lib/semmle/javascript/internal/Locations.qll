/** Provides classes for working with locations and program elements that have locations. */

import javascript

// Should _not_ be cached, as that would require the data flow stage to be evaluated
// in order to evaluate the AST stage. Ideally, we would cache each injector separately,
// but that's not possible. Instead, we cache all predicates that need the injectors
// to be tuple numbered.
newtype TLocation =
  TDbLocation(@location loc) or
  TSynthLocation(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    any(SsaDefinition def).hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
    // avoid overlap with existing DB locations
    not exists(File f |
      locations_default(_, f, startline, startcolumn, endline, endcolumn) and
      f.getAbsolutePath() = filepath
    )
  }

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 *
 * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
 */
abstract class LocationImpl extends TLocation {
  /** Gets the file for this location. */
  abstract File getFile();

  /** Gets the 1-based line number (inclusive) where this location starts. */
  abstract int getStartLine();

  /** Gets the 1-based column number (inclusive) where this location starts. */
  abstract int getStartColumn();

  /** Gets the 1-based line number (inclusive) where this location ends. */
  abstract int getEndLine();

  /** Gets the 1-based column number (inclusive) where this location ends. */
  abstract int getEndColumn();

  /** Gets the number of lines covered by this location. */
  int getNumLines() { result = this.getEndLine() - this.getStartLine() + 1 }

  /** Holds if this location starts before location `that`. */
  pragma[inline]
  predicate startsBefore(Location that) {
    exists(string f, int sl1, int sc1, int sl2, int sc2 |
      this.hasLocationInfo(f, sl1, sc1, _, _) and
      that.hasLocationInfo(f, sl2, sc2, _, _)
    |
      sl1 < sl2
      or
      sl1 = sl2 and sc1 < sc2
    )
  }

  /** Holds if this location ends after location `that`. */
  pragma[inline]
  predicate endsAfter(Location that) {
    exists(string f, int el1, int ec1, int el2, int ec2 |
      this.hasLocationInfo(f, _, _, el1, ec1) and
      that.hasLocationInfo(f, _, _, el2, ec2)
    |
      el1 > el2
      or
      el1 = el2 and ec1 > ec2
    )
  }

  /**
   * Holds if this location contains location `that`, meaning that it starts
   * before and ends after it.
   */
  predicate contains(Location that) { this.startsBefore(that) and this.endsAfter(that) }

  /** Holds if this location is empty. */
  predicate isEmpty() { exists(int l, int c | this.hasLocationInfo(_, l, c, l, c - 1)) }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getFile().getBaseName() + ":" + this.getStartLine().toString() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  abstract predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  );
}

class DbLocationImpl extends LocationImpl instanceof DbLocation {
  override File getFile() { result = DbLocation.super.getFile() }

  override int getStartLine() { result = DbLocation.super.getStartLine() }

  override int getStartColumn() { result = DbLocation.super.getStartColumn() }

  override int getEndLine() { result = DbLocation.super.getEndLine() }

  override int getEndColumn() { result = DbLocation.super.getEndColumn() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    DbLocation.super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class SynthLocationImpl extends LocationImpl, TSynthLocation {
  override File getFile() { synthLocationInfo(this, result.getAbsolutePath(), _, _, _, _) }

  override int getStartLine() { synthLocationInfo(this, _, result, _, _, _) }

  override int getStartColumn() { synthLocationInfo(this, _, _, result, _, _) }

  override int getEndLine() { synthLocationInfo(this, _, _, _, result, _) }

  override int getEndColumn() { synthLocationInfo(this, _, _, _, _, result) }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    synthLocationInfo(this, filepath, startline, startcolumn, endline, endcolumn)
  }
}

cached
private module Cached {
  cached
  DbLocation getLocatableLocation(@locatable l) {
    exists(@location loc |
      hasLocation(l, loc) or
      xmllocations(l, loc) or
      json_locations(l, loc) or
      yaml_locations(l, loc)
    |
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
private module CachedInDataFlowStage {
  private import semmle.javascript.internal.CachedStages

  cached
  predicate synthLocationInfo(
    SynthLocationImpl l, string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    Stages::DataFlowStage::ref() and
    l = TSynthLocation(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private import CachedInDataFlowStage
