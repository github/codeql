/**
 * Provides the `Location` class to give a location for each
 * program element.
 *
 * There are two types of location: `SourceLocation` and `Assembly`.
 * A `SourceLocation` provides a section of text in a source file
 * containing the program element.
 *
 * An `Assembly` is a location in a reference. The same element
 * may have both `SourceLocation` and `Assembly` locations,
 * or even several `Assembly` locations if the assembly file
 * is copied during the build process.
 */

import File
private import Attribute
private import semmle.code.csharp.commons.Compilation

/**
 * A location of a program element.
 */
class Location extends @location {
  /** Gets the file of the location. */
  File getFile() { none() }

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
    none()
  }

  /** Gets a textual representation of this location. */
  string toString() { none() }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  final int getStartLine() { this.hasLocationInfo(_, result, _, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  final int getEndLine() { this.hasLocationInfo(_, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  final int getStartColumn() { this.hasLocationInfo(_, _, result, _, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  final int getEndColumn() { this.hasLocationInfo(_, _, _, _, result) }

  /** Holds if this location starts strictly before the specified location. */
  bindingset[this, other]
  pragma[inline_late]
  predicate strictlyBefore(Location other) {
    this.getFile() = other.getFile() and
    (
      this.getStartLine() < other.getStartLine()
      or
      this.getStartLine() = other.getStartLine() and this.getStartColumn() < other.getStartColumn()
    )
  }

  /** Holds if this location starts before the specified location. */
  bindingset[this, other]
  pragma[inline_late]
  predicate before(Location other) {
    this.getStartLine() < other.getStartLine()
    or
    this.getStartLine() = other.getStartLine() and this.getStartColumn() <= other.getStartColumn()
  }
}

/** An empty location. */
class EmptyLocation extends Location {
  EmptyLocation() { this.hasLocationInfo("", 0, 0, 0, 0) }
}

/**
 * A location in source code, comprising of a source file and a segment of text
 * within the file.
 */
class SourceLocation extends Location, @location_default {
  /** Gets the location that takes into account `#line` directives, if any. */
  SourceLocation getMappedLocation() {
    locations_mapped(this, result) and
    not exists(LineDirective l | l.getALocation() = this)
  }

  override File getFile() { locations_default(this, result, _, _, _, _) }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f | locations_default(this, f, startline, startcolumn, endline, endcolumn) |
      filepath = f.getAbsolutePath()
    )
  }

  override string toString() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      this.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    |
      result = filepath + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }
}

bindingset[version]
private int versionField(string version, int field) {
  exists(string format, int i |
    format = "(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)|" + "(\\d+)\\.(\\d+)\\.(\\d+)|" + "(\\d+)\\.(\\d+)" and
    result = version.regexpCapture(format, i).toInt()
  |
    i = [1, 5, 8] and
    field = 1
    or
    i = [2, 6, 9] and
    field = 2
    or
    i = [3, 7] and
    field = 3
    or
    i = 4 and
    field = 4
  ) and
  result >= 0 and
  result <= 255
}

/** An assembly version, for example `4.0.0.0` or `4.5`. */
class Version extends string {
  private int major;

  bindingset[this]
  Version() { major = versionField(this, 1) }

  bindingset[this]
  private int getVersionField(int field) {
    field = 1 and
    result = major
    or
    field in [2 .. 4] and
    result = versionField(this, field)
  }

  /**
   * Gets field `field` of this version.
   * If the field is unspecified in the version string, then the result is `0`.
   */
  bindingset[this]
  int getField(int field) {
    result = this.getVersionField(field)
    or
    field in [2 .. 4] and
    not exists(this.getVersionField(field)) and
    result = 0
  }

  bindingset[this]
  private string getCanonicalizedField(int field) {
    exists(string s, int length |
      s = this.getVersionField(field).toString() and
      length = s.length()
    |
      // make each field consist of 3 digits
      result = concat(int i | i in [1 .. 3 - length] | "0") + s
    )
  }

  /**
   * Gets a canonicalized version of this string, where lexicographical ordering
   * corresponds to version ordering.
   */
  bindingset[this]
  string getCanonicalizedVersion() {
    exists(string res, int length |
      res =
        strictconcat(int field, string s |
          s = this.getCanonicalizedField(field)
        |
          s, "." order by field
        ) and
      length = res.length()
    |
      // make each canonicalized version consist of 4 chunks of 3 digits separated by a dot
      result = res + concat(int i | i = [1 .. 15 - length] / 4 and i > 0 | ".000")
    )
  }

  /** Gets the major version, for example `1` in `1.2.3.4`. */
  bindingset[this]
  int getMajor() { result = major }

  /** Gets the major revision, for example `2` in `1.2.3.4`. */
  bindingset[this]
  int getMajorRevision() { result = this.getField(2) }

  /**
   * Gets the minor version, for example `3` in `1.2.3.4`.
   * If the minor version is unspecified, then the result is `0`.
   */
  bindingset[this]
  int getMinor() { result = this.getField(3) }

  /**
   * Gets the minor revision, for example `4` in `1.2.3.4`.
   * If the minor revision is unspecified, then the result is `0`.
   */
  bindingset[this]
  int getMinorRevision() { result = this.getField(4) }

  /**
   * Holds if this version is earlier than `other`.
   * For example, `4.0.0.0` is earlier than `4.5`.
   */
  bindingset[this, other]
  predicate isEarlierThan(Version other) {
    this.getCanonicalizedVersion() < other.getCanonicalizedVersion()
  }

  /**
   * Compares two versions and returns
   * - 0 if this version equals `other`. Note that `4.0` and `4.0.0.0` are considered to be equal.
   * - -1 if this version is before `other`
   * - 1 if this version is after `other`
   */
  bindingset[this, other]
  int compareTo(Version other) {
    if this.isEarlierThan(other)
    then result = -1
    else
      if other.isEarlierThan(this)
      then result = 1
      else result = 0
  }
}

/**
 * A .NET assembly location.
 */
class Assembly extends Location, Attributable, @assembly {
  /** Gets the full name of this assembly, including its version and public token. */
  string getFullName() { assemblies(this, _, result, _, _) }

  /** Gets the name of this assembly. */
  string getName() { assemblies(this, _, _, result, _) }

  /** Gets the version of this assembly. */
  Version getVersion() { assemblies(this, _, _, _, result) }

  /** Gets the compilation producing this assembly, if any. */
  Compilation getCompilation() { compilation_assembly(result, this) }

  override File getFile() { assemblies(this, result, _, _, _) }

  override string toString() { result = this.getFullName() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f |
      assemblies(this, f, _, _, _) and
      filepath = f.getAbsolutePath() and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    )
  }
}
