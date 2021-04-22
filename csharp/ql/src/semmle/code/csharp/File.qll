/**
 * Provides classes representing filesystem files and folders.
 */

/** A file or folder. */
class Container extends @container {
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
  string getAbsolutePath() { none() }

  /**
   * Gets a URL representing the location of this container.
   *
   * For more information see [Providing URLs](https://help.semmle.com/QL/learn-ql/ql/locations.html#providing-urls).
   */
  string getURL() { none() }

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
      absPath = getAbsolutePath() and sourceLocationPrefix(pref)
    |
      absPath = pref and result = ""
      or
      absPath = pref.regexpReplaceAll("/$", "") + "/" + result and
      not result.matches("/%")
    )
  }

  /**
   * Gets the base name of this container including extension, that is, the last
   * segment of its absolute path, or the empty string if it has no segments.
   *
   * Here are some examples of absolute paths and the corresponding base names
   * (surrounded with quotes to avoid ambiguity):
   *
   * <table border="1">
   * <tr><th>Absolute path</th><th>Base name</th></tr>
   * <tr><td>"/tmp/tst.cs"</td><td>"tst.cs"</td></tr>
   * <tr><td>"C:/Program Files (x86)"</td><td>"Program Files (x86)"</td></tr>
   * <tr><td>"/"</td><td>""</td></tr>
   * <tr><td>"C:/"</td><td>""</td></tr>
   * <tr><td>"D:/"</td><td>""</td></tr>
   * <tr><td>"//FileServer/"</td><td>""</td></tr>
   * </table>
   */
  string getBaseName() {
    result = getAbsolutePath().regexpCapture(".*/(([^/]*?)(?:\\.([^.]*))?)", 1)
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
   * <tr><td>"/tmp/tst.cs"</td><td>"cs"</td></tr>
   * <tr><td>"/tmp/.classpath"</td><td>"classpath"</td></tr>
   * <tr><td>"/bin/bash"</td><td>not defined</td></tr>
   * <tr><td>"/tmp/tst2."</td><td>""</td></tr>
   * <tr><td>"/tmp/x.tar.gz"</td><td>"gz"</td></tr>
   * </table>
   */
  string getExtension() { result = getAbsolutePath().regexpCapture(".*/([^/]*?)(\\.([^.]*))?", 3) }

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
   * <tr><td>"/tmp/tst.cs"</td><td>"tst"</td></tr>
   * <tr><td>"/tmp/.classpath"</td><td>""</td></tr>
   * <tr><td>"/bin/bash"</td><td>"bash"</td></tr>
   * <tr><td>"/tmp/tst2."</td><td>"tst2"</td></tr>
   * <tr><td>"/tmp/x.tar.gz"</td><td>"x.tar"</td></tr>
   * </table>
   */
  string getStem() { result = getAbsolutePath().regexpCapture(".*/([^/]*?)(?:\\.([^.]*))?", 1) }

  /** Gets the parent container of this file or folder, if any. */
  Container getParentContainer() { containerparent(result, this) }

  /** Gets a file or sub-folder in this container. */
  Container getAChildContainer() { this = result.getParentContainer() }

  /** Gets a file in this container. */
  File getAFile() { result = getAChildContainer() }

  /** Gets the file in this container that has the given `baseName`, if any. */
  File getFile(string baseName) {
    result = getAFile() and
    result.getBaseName() = baseName
  }

  /** Gets a sub-folder in this container. */
  Folder getAFolder() { result = getAChildContainer() }

  /** Gets the sub-folder in this container that has the given `baseName`, if any. */
  Folder getFolder(string baseName) {
    result = getAFolder() and
    result.getBaseName() = baseName
  }

  /** Gets the file or sub-folder in this container that has the given `name`, if any. */
  Container getChildContainer(string name) {
    result = getAChildContainer() and
    result.getBaseName() = name
  }

  /** Gets the file in this container that has the given `stem` and `extension`, if any. */
  File getFile(string stem, string extension) {
    result = getAChildContainer() and
    result.getStem() = stem and
    result.getExtension() = extension
  }

  /** Gets a sub-folder contained in this container. */
  Folder getASubFolder() { result = getAChildContainer() }

  /**
   * Gets a textual representation of the path of this container.
   *
   * This is the absolute path of the container.
   */
  string toString() { result = getAbsolutePath() }
}

/** A folder. */
class Folder extends Container, @folder {
  override string getAbsolutePath() { folders(this, result, _) }

  override string getURL() { result = "folder://" + getAbsolutePath() }
}

/** A file. */
class File extends Container, @file {
  override string getAbsolutePath() { files(this, result, _, _, _) }

  /** Gets the number of lines in this file. */
  int getNumberOfLines() { numlines(this, result, _, _) }

  /** Gets the number of lines containing code in this file. */
  int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of lines containing comments in this file. */
  int getNumberOfLinesOfComments() { numlines(this, _, _, result) }

  override string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

  /** Holds if this file contains source code. */
  predicate fromSource() { this.getNumberOfLinesOfCode() > 0 }

  /** Holds if this file is a library. */
  predicate fromLibrary() {
    not this.getBaseName() = "" and
    not this.fromSource()
  }

  /**
   * Holds if this source file came from a PDB.
   * A source file can come from a PDB and from regular extraction
   * in the same snapshot.
   */
  predicate isPdbSourceFile() { file_extraction_mode(this, 2) }
}

/**
 * A source file.
 */
class SourceFile extends File {
  SourceFile() { this.fromSource() }

  /** Holds if the file was extracted without building the source code. */
  predicate extractedStandalone() { file_extraction_mode(this, 1) }
}
