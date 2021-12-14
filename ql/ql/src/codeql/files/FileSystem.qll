/** Provides classes for working with files and folders. */

private import codeql_ql.ast.internal.TreeSitter
private import codeql.Locations

/** A file or folder. */
abstract class Container extends @container {
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
  abstract string getAbsolutePath();

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
  Container getParentContainer() { containerparent(result, this) }

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
      absPath = this.getAbsolutePath() and sourceLocationPrefix(pref)
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
   * For more information see https://lgtm.com/help/ql/locations#providing-urls.
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
class Folder extends Container, @folder {
  override string getAbsolutePath() { folders(this, result) }

  /** Gets the URL of this folder. */
  override string getURL() { result = "folder://" + this.getAbsolutePath() }
}

/** A file. */
class File extends Container, @file {
  override string getAbsolutePath() { files(this, result) }

  /** Gets the URL of this file. */
  override string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

  /** Gets a token in this file. */
  private QL::Token getAToken() { result.getLocation().getFile() = this }

  /** Holds if `line` contains a token. */
  private predicate line(int line, boolean comment) {
    exists(QL::Token token, Location l |
      token = this.getAToken() and
      l = token.getLocation() and
      line in [l.getStartLine() .. l.getEndLine()] and
      if token instanceof @ql_token_block_comment or token instanceof @ql_token_line_comment
      then comment = true
      else comment = false
    )
  }

  /** Gets the number of lines in this file. */
  int getNumberOfLines() { result = max([0, this.getAToken().getLocation().getEndLine()]) }

  /** Gets the number of lines of code in this file. */
  int getNumberOfLinesOfCode() { result = count(int line | this.line(line, false)) }

  /** Gets the number of lines of comments in this file. */
  int getNumberOfLinesOfComments() { result = count(int line | this.line(line, true)) }

  /** Holds if this file was extracted from ordinary source code. */
  predicate fromSource() { any() }
}
