/**
 * A shared library for reasoning about locations.
 * - `LocationsSig` is a basic API that every language is expected to implement.
 * - `Make` is a full implementation of a Location API.
 */

/** Provides classes for working with locations. */
signature module LocationsSig {
  class Location;

  predicate locations(
    Location loc, File file, int startLine, int startColum, int endLine, int endColumn
  );

  class Container {
    string getAbsolutePath();

    Container getParentContainer();
  }

  class File extends Container;

  class Folder extends Container;

  string getSourceLocationPrefix();
}

/** A API for working with Locations. */
module Make<LocationsSig LocImpl> {
  /** A file or folder. */
  abstract class Container instanceof LocImpl::Container {
    /** Gets a file or sub-folder in this container. */
    Container getAChildContainer() { this = result.getParentContainer() }

    /** Gets a file in this container. */
    File getAFile() { result = this.getAChildContainer() }

    /** Gets a sub-folder in this container. */
    Folder getAFolder() { result = this.getAChildContainer() }

    /**
     * Gets the absolute, canonical path of this container, using forward slashes
     * as path separator.
     *
     * The path starts with a _root prefix_ followed by zero or more _path
     * segments_ separated by forward slashes.
     *
     * The root prefix is of one of the following forms:
     *
     *   1. A single forward slash `/` (Unix-style)
     *   2. An upper-case drive letter followed by a colon and a forward slash,
     *      such as `C:/` (Windows-style)
     *   3. Two forward slashes, a computer name, and then another forward slash,
     *      such as `//FileServer/` (UNC-style)
     *
     * Path segments are never empty (that is, absolute paths never contain two
     * contiguous slashes, except as part of a UNC-style root prefix). Also, path
     * segments never contain forward slashes, and no path segment is of the
     * form `.` (one dot) or `..` (two dots).
     *
     * Note that an absolute path never ends with a forward slash, except if it is
     * a bare root prefix, that is, the path has no path segments. A container
     * whose absolute path has no segments is always a `Folder`, not a `File`.
     */
    string getAbsolutePath() { result = LocImpl::Container.super.getAbsolutePath() }

    /**
     * Gets the base name of this container including extension, that is, the last
     * segment of its absolute path, or the empty string if it has no segments.
     *
     * Here are some examples of absolute paths and the corresponding base names
     * (surrounded with quotes to avoid ambiguity):
     *
     * <table border="1">
     * <tr><th>Absolute path</th><th>Base name</th></tr>
     * <tr><td>"/tmp/tst.go"</td><td>"tst.go"</td></tr>
     * <tr><td>"C:/Program Files (x86)"</td><td>"Program Files (x86)"</td></tr>
     * <tr><td>"/"</td><td>""</td></tr>
     * <tr><td>"C:/"</td><td>""</td></tr>
     * <tr><td>"D:/"</td><td>""</td></tr>
     * <tr><td>"//FileServer/"</td><td>""</td></tr>
     * </table>
     */
    string getBaseName() {
      result = this.getAbsolutePath().regexpCapture(".*/(([^/]*?)(?:\\.([^.]*))?)", 1)
    }

    /**
     * Gets the extension of this container, that is, the suffix of its base name
     * after the last dot character, if any.
     *
     * In particular,
     *
     *  - if the name does not include a dot, there is no extension, so this
     *    predicate has no result;
     *  - if the name ends in a dot, the extension is the empty string;
     *  - if the name contains multiple dots, the extension follows the last dot.
     *
     * Here are some examples of absolute paths and the corresponding extensions
     * (surrounded with quotes to avoid ambiguity):
     *
     * <table border="1">
     * <tr><th>Absolute path</th><th>Extension</th></tr>
     * <tr><td>"/tmp/tst.go"</td><td>"go"</td></tr>
     * <tr><td>"/tmp/.classpath"</td><td>"classpath"</td></tr>
     * <tr><td>"/bin/bash"</td><td>not defined</td></tr>
     * <tr><td>"/tmp/tst2."</td><td>""</td></tr>
     * <tr><td>"/tmp/x.tar.gz"</td><td>"gz"</td></tr>
     * </table>
     */
    string getExtension() {
      result = this.getAbsolutePath().regexpCapture(".*/([^/]*?)(\\.([^.]*))?", 3)
    }

    /** Gets the file in this container that has the given `baseName`, if any. */
    File getFile(string baseName) {
      result = this.getAFile() and
      result.getBaseName() = baseName
    }

    /** Gets the sub-folder in this container that has the given `baseName`, if any. */
    Folder getFolder(string baseName) {
      result = this.getAFolder() and
      result.getBaseName() = baseName
    }

    /** Gets the parent container of this file or folder, if any. */
    Container getParentContainer() { result = LocImpl::Container.super.getParentContainer() }

    /**
     * Gets the relative path of this file or folder from the root folder of the
     * analyzed source location. The relative path of the root folder itself is
     * the empty string.
     *
     * This has no result if the container is outside the source root, that is,
     * if the root folder is not a reflexive, transitive parent of this container.
     */
    string getRelativePath() {
      exists(string absPath, string pref |
        absPath = this.getAbsolutePath() and pref = LocImpl::getSourceLocationPrefix()
      |
        absPath = pref and result = ""
        or
        absPath = pref.regexpReplaceAll("/$", "") + "/" + result and
        not result.matches("/%")
      )
    }

    /**
     * Gets the stem of this container, that is, the prefix of its base name up to
     * (but not including) the last dot character if there is one, or the entire
     * base name if there is not.
     *
     * Here are some examples of absolute paths and the corresponding stems
     * (surrounded with quotes to avoid ambiguity):
     *
     * <table border="1">
     * <tr><th>Absolute path</th><th>Stem</th></tr>
     * <tr><td>"/tmp/tst.go"</td><td>"tst"</td></tr>
     * <tr><td>"/tmp/.classpath"</td><td>""</td></tr>
     * <tr><td>"/bin/bash"</td><td>"bash"</td></tr>
     * <tr><td>"/tmp/tst2."</td><td>"tst2"</td></tr>
     * <tr><td>"/tmp/x.tar.gz"</td><td>"x.tar"</td></tr>
     * </table>
     */
    string getStem() {
      result = this.getAbsolutePath().regexpCapture(".*/([^/]*?)(?:\\.([^.]*))?", 1)
    }

    /**
     * Gets a URL representing the location of this container.
     *
     * For more information see https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#providing-urls.
     */
    abstract string getURL();

    /**
     * Gets a textual representation of the path of this container.
     *
     * This is the absolute path of the container.
     */
    string toString() { result = this.getAbsolutePath() }
  }

  /** A folder. */
  class Folder extends Container instanceof LocImpl::Folder {
    /** Gets the URL of this folder. */
    override string getURL() { result = "folder://" + this.getAbsolutePath() }

    /** Gets the file or subfolder in this folder that has the given `name`, if any. */
    Container getChildContainer(string name) {
      result = this.getAChildContainer() and
      result.getBaseName() = name
    }

    /** Gets the file in this folder that has the given `stem` and `extension`, if any. */
    File getFile(string stem, string extension) {
      result = this.getAChildContainer() and
      result.getStem() = stem and
      result.getExtension() = extension
    }

    /** Gets a subfolder contained in this folder. */
    Folder getASubFolder() { result = this.getAChildContainer() }
  }

  /** A file. */
  class File extends Container instanceof LocImpl::File {
    /** Gets the URL of this file. */
    override string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

    /** Holds if this file was extracted from ordinary source code. */
    predicate fromSource() { any() }
  }

  /**
   * A location as given by a file, a start line, a start column,
   * an end line, and an end column.
   *
   * For more information about locations see [LGTM locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  class Location instanceof LocImpl::Location {
    /** Gets the file for this location. */
    File getFile() { LocImpl::locations(this, result, _, _, _, _) }

    /** Gets the 1-based line number (inclusive) where this location starts. */
    int getStartLine() { LocImpl::locations(this, _, result, _, _, _) }

    /** Gets the 1-based column number (inclusive) where this location starts. */
    int getStartColumn() { LocImpl::locations(this, _, _, result, _, _) }

    /** Gets the 1-based line number (inclusive) where this location ends. */
    int getEndLine() { LocImpl::locations(this, _, _, _, result, _) }

    /** Gets the 1-based column number (inclusive) where this location ends. */
    int getEndColumn() { LocImpl::locations(this, _, _, _, _, result) }

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
     * [LGTM locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      exists(File f |
        LocImpl::locations(this, f, startline, startcolumn, endline, endcolumn) and
        filepath = f.getAbsolutePath()
      )
    }

    /** Holds if this location starts strictly before the specified location. */
    pragma[inline]
    predicate strictlyBefore(Location that) {
      this.getFile() = that.getFile() and
      (
        this.getStartLine() < that.getStartLine()
        or
        this.getStartLine() = that.getStartLine() and this.getStartColumn() < that.getStartColumn()
      )
    }

    /** Holds if this location ends after location `that`. */
    pragma[inline]
    predicate endsAfter(Location that) {
      this.getFile() = that.getFile() and
      (
        this.getEndLine() > that.getEndLine()
        or
        this.getEndLine() = that.getEndLine() and this.getEndColumn() > that.getEndColumn()
      )
    }

    /**
     * Holds if this location contains location `that`, meaning that it starts
     * before and ends after it.
     */
    predicate contains(Location that) { this.strictlyBefore(that) and this.endsAfter(that) }

    /** Holds if this location is empty. */
    predicate isEmpty() { exists(int l, int c | LocImpl::locations(this, _, l, c, l, c - 1)) }
  }
}
