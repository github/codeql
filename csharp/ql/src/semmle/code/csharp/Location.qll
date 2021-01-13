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
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
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
  exists(string format |
    format = "(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)" or
    format = "(\\d+)\\.(\\d+)\\.(\\d+)" or
    format = "(\\d+)\\.(\\d+)"
  |
    result = version.regexpCapture(format, field).toInt()
  ) and
  result >= 0 and
  result <= 255
}

/** An assembly version, for example `4.0.0.0` or `4.5`. */
class Version extends string {
  bindingset[this]
  Version() { exists(versionField(this, 1)) }

  /**
   * Gets field `field` of this version.
   * If the field is unspecified in the version string, then the result is `0`.
   */
  bindingset[this]
  int getField(int field) {
    field in [1 .. 4] and
    if exists(versionField(this, field)) then result = versionField(this, field) else result = 0
  }

  /** Gets the major version, for example `1` in `1.2.3.4`. */
  bindingset[this]
  int getMajor() { result = this.getField(1) }

  /** Gets the major revision, for example `2` in `1.2.3.4`. */
  bindingset[this]
  int getMajorRevision() { result = this.getField(2) }

  /**
   * Gets the minor version, for example `3` in `1.2.3.4`.
   * If the minor version is unspecifed, then the result is `0`.
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
    exists(int i | this.getField(i) < other.getField(i) |
      forall(int j | j in [1 .. i - 1] | this.getField(j) = other.getField(j))
    )
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
