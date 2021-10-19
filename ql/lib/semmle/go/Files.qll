/** Provides classes for working with files and folders. */

import go

/** A file or folder. */
abstract class Container extends @container {
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
   * Gets a URL representing the location of this container.
   *
   * For more information see https://lgtm.com/help/ql/locations#providing-urls.
   */
  abstract string getURL();

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

  /** Gets the parent container of this file or folder, if any. */
  Container getParentContainer() { containerparent(result, this) }

  /** Gets a file or sub-folder in this container. */
  Container getAChildContainer() { this = result.getParentContainer() }

  /** Gets a file in this container. */
  File getAFile() { result = this.getAChildContainer() }

  /** Gets the file in this container that has the given `baseName`, if any. */
  File getFile(string baseName) {
    result = this.getAFile() and
    result.getBaseName() = baseName
  }

  /** Gets a sub-folder in this container. */
  Folder getAFolder() { result = this.getAChildContainer() }

  /** Gets the sub-folder in this container that has the given `baseName`, if any. */
  Folder getFolder(string baseName) {
    result = this.getAFolder() and
    result.getBaseName() = baseName
  }

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

  /** Gets the URL of this folder. */
  override string getURL() { result = "folder://" + this.getAbsolutePath() }
}

/** Any file, including files that have not been extracted but are referred to as locations for errors. */
class ExtractedOrExternalFile extends Container, @file, Documentable, ExprParent, GoModExprParent,
  DeclParent, ScopeNode {
  override Location getLocation() { has_location(this, result) }

  override string getAbsolutePath() { files(this, result) }

  /** Gets the number of lines in this file. */
  int getNumberOfLines() { numlines(this, result, _, _) }

  /** Gets the number of lines containing code in this file. */
  int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of lines containing comments in this file. */
  int getNumberOfLinesOfComments() { numlines(this, _, _, result) }

  /** Gets the package name as specified in the package clause of this file. */
  Ident getPackageNameExpr() { result = this.getChildExpr(0) }

  /** Gets the name of the package to which this file belongs. */
  string getPackageName() { result = this.getPackageNameExpr().getName() }

  /** Holds if this file contains at least one build constraint. */
  pragma[noinline]
  predicate hasBuildConstraints() { exists(BuildConstraintComment bc | this = bc.getFile()) }

  /**
   * Holds if this file contains build constraints that ensure that it
   * is only built on architectures of bit size `bitSize`, which can be
   * 32 or 64.
   */
  predicate constrainsIntBitSize(int bitSize) {
    this.explicitlyConstrainsIntBitSize(bitSize) or
    this.implicitlyConstrainsIntBitSize(bitSize)
  }

  /**
   * Holds if this file contains explicit build constraints that ensure
   * that it is only built on an architecture of bit size `bitSize`,
   * which can be 32 or 64.
   */
  predicate explicitlyConstrainsIntBitSize(int bitSize) {
    exists(BuildConstraintComment bcc | this = bcc.getFile() |
      forex(string disjunct | disjunct = bcc.getADisjunct() |
        disjunct.splitAt(",").(Architecture).getBitSize() = bitSize
        or
        disjunct.splitAt("/").(Architecture).getBitSize() = bitSize
      )
    )
  }

  /**
   * Holds if this file has a name which acts as an implicit build
   * constraint that ensures that it is only built on an
   * architecture of bit size `bitSize`, which can be 32 or 64.
   */
  predicate implicitlyConstrainsIntBitSize(int bitSize) {
    exists(Architecture arch | arch.getBitSize() = bitSize |
      this.getStem().regexpMatch("(?i).*_\\Q" + arch + "\\E(_test)?")
    )
  }

  override string toString() { result = Container.super.toString() }

  /** Gets the URL of this file. */
  override string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

  /** Gets the `i`th child comment group. */
  CommentGroup getCommentGroup(int i) { comment_groups(result, this, i) }

  /** Gets a child comment group. */
  CommentGroup getACommentGroup() { result = this.getCommentGroup(_) }

  /** Gets the number of child comment groups of this file. */
  int getNumCommentGroups() { result = count(this.getACommentGroup()) }

  override string getAPrimaryQlClass() { result = "ExtractedOrExternalFile" }
}

/** A file that has been extracted. */
class File extends ExtractedOrExternalFile {
  File() {
    // getAChild is specifically for the Go AST and so does not apply to non-go files
    // we care about all non-go extracted files, as only go files can have `@file` entries due to requiring a file entry for diagnostic errors
    not this.getExtension() = "go"
    or
    exists(this.getAChild())
  }

  override string getAPrimaryQlClass() { result = "File" }
}

/** A Go file. */
class GoFile extends File {
  GoFile() { this.getExtension() = "go" }

  override string getAPrimaryQlClass() { result = "GoFile" }
}

/** An HTML file. */
class HtmlFile extends File {
  HtmlFile() { this.getExtension().regexpMatch("x?html?") }

  override string getAPrimaryQlClass() { result = "HtmlFile" }
}
