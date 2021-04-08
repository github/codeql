import python

/** A file */
class File extends Container {
  File() { files(this, _, _, _, _) }

  /** DEPRECATED: Use `getAbsolutePath` instead. */
  deprecated override string getName() { result = this.getAbsolutePath() }

  /** DEPRECATED: Use `getAbsolutePath` instead. */
  deprecated string getFullName() { result = this.getAbsolutePath() }

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
    this.getAbsolutePath() = filepath and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  /** Whether this file is a source code file. */
  predicate fromSource() {
    /* If we start to analyse .pyc files, then this will have to change. */
    any()
  }

  /** Gets a short name for this file (just the file name) */
  string getShortName() {
    exists(string simple, string ext | files(this, _, simple, ext, _) | result = simple + ext)
  }

  private int lastLine() {
    result = max(int i | exists(Location l | l.getFile() = this and l.getEndLine() = i))
  }

  /** Whether line n is empty (it contains neither code nor comment). */
  predicate emptyLine(int n) {
    n in [0 .. this.lastLine()] and
    not occupied_line(this, n)
  }

  string getSpecifiedEncoding() {
    exists(Comment c, Location l | l = c.getLocation() and l.getFile() = this |
      l.getStartLine() < 3 and
      result = c.getText().regexpCapture(".*coding[:=]\\s*([-\\w.]+).*", 1)
    )
  }

  override string getAbsolutePath() { files(this, result, _, _, _) }

  /** Gets the URL of this file. */
  override string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

  override Container getImportRoot(int n) {
    /* File stem must be a legal Python identifier */
    this.getStem().regexpMatch("[^\\d\\W]\\w*") and
    result = this.getParent().getImportRoot(n)
  }

  /**
   * Gets the contents of this file as a string.
   * This will only work for those non-python files that
   * are specified to be extracted.
   */
  string getContents() { file_contents(this, result) }
}

private predicate occupied_line(File f, int n) {
  exists(Location l | l.getFile() = f |
    l.getStartLine() = n
    or
    exists(StrConst s | s.getLocation() = l | n in [l.getStartLine() .. l.getEndLine()])
  )
}

/** A folder (directory) */
class Folder extends Container {
  Folder() { folders(this, _, _) }

  /** DEPRECATED: Use `getAbsolutePath` instead. */
  deprecated override string getName() { result = this.getAbsolutePath() }

  /** DEPRECATED: Use `getBaseName` instead. */
  deprecated string getSimple() { folders(this, _, result) }

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
    this.getAbsolutePath() = filepath and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  override string getAbsolutePath() { folders(this, result, _) }

  /** Gets the URL of this folder. */
  override string getURL() { result = "folder://" + this.getAbsolutePath() }

  override Container getImportRoot(int n) {
    this.isImportRoot(n) and result = this
    or
    /* Folder must be a legal Python identifier */
    this.getBaseName().regexpMatch("[^\\d\\W]\\w*") and
    result = this.getParent().getImportRoot(n)
  }
}

/**
 * A container is an abstract representation of a file system object that can
 * hold elements of interest.
 */
abstract class Container extends @container {
  Container getParent() { containerparent(result, this) }

  /** Gets a child of this container */
  deprecated Container getChild() { containerparent(this, result) }

  /**
   * Gets a textual representation of the path of this container.
   *
   * This is the absolute path of the container.
   */
  string toString() { result = this.getAbsolutePath() }

  /** Gets the name of this container */
  abstract string getName();

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

  /** Whether this file or folder is part of the standard library */
  predicate inStdlib() { this.inStdlib(_, _) }

  /**
   * Whether this file or folder is part of the standard library
   * for version `major.minor`
   */
  predicate inStdlib(int major, int minor) {
    exists(Module m |
      m.getPath() = this and
      m.inStdLib(major, minor)
    )
  }

  /* Standard cross-language API */
  /** Gets a file or sub-folder in this container. */
  Container getAChildContainer() { containerparent(this, result) }

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
   * <tr><td>"/tmp/tst.py"</td><td>"tst.py"</td></tr>
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
   * <tr><td>"/tmp/tst.py"</td><td>"py"</td></tr>
   * <tr><td>"/tmp/.gitignore"</td><td>"gitignore"</td></tr>
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
   * <tr><td>"/tmp/tst.py"</td><td>"tst"</td></tr>
   * <tr><td>"/tmp/.gitignore"</td><td>""</td></tr>
   * <tr><td>"/bin/bash"</td><td>"bash"</td></tr>
   * <tr><td>"/tmp/tst2."</td><td>"tst2"</td></tr>
   * <tr><td>"/tmp/x.tar.gz"</td><td>"x.tar"</td></tr>
   * </table>
   */
  string getStem() { result = getAbsolutePath().regexpCapture(".*/([^/]*?)(?:\\.([^.]*))?", 1) }

  File getFile(string baseName) {
    result = this.getAFile() and
    result.getBaseName() = baseName
  }

  Folder getFolder(string baseName) {
    result = this.getAFolder() and
    result.getBaseName() = baseName
  }

  Container getParentContainer() { this = result.getAChildContainer() }

  Container getChildContainer(string baseName) {
    result = this.getAChildContainer() and
    result.getBaseName() = baseName
  }

  /**
   * Gets a URL representing the location of this container.
   *
   * For more information see [Providing URLs](https://help.semmle.com/QL/learn-ql/ql/locations.html#providing-urls).
   */
  abstract string getURL();

  /** Holds if this folder is on the import path. */
  predicate isImportRoot() { this.isImportRoot(_) }

  /**
   * Holds if this folder is on the import path, at index `n` in the list of
   * paths. The list of paths is composed of the paths passed to the extractor and
   * `sys.path`.
   */
  predicate isImportRoot(int n) { this.getName() = import_path_element(n) }

  /** Holds if this folder is the root folder for the standard library. */
  predicate isStdLibRoot(int major, int minor) {
    major = major_version() and
    minor = minor_version() and
    this.isStdLibRoot()
  }

  /** Holds if this folder is the root folder for the standard library. */
  predicate isStdLibRoot() {
    /*
     * Look for a standard lib module and find its import path
     * We use `os` as it is the most likely to be imported and
     * `tty` because it is small for testing.
     */

    exists(Module m | m.getName() = "os" or m.getName() = "tty" |
      m.getFile().getImportRoot() = this
    )
  }

  /** Gets the path element from which this container would be loaded. */
  Container getImportRoot() {
    exists(int n |
      result = this.getImportRoot(n) and
      not exists(int m |
        exists(this.getImportRoot(m)) and
        m < n
      )
    )
  }

  /** Gets the path element from which this container would be loaded, given the index into the list of possible paths `n`. */
  abstract Container getImportRoot(int n);
}

private string import_path_element(int n) {
  exists(string path, string pathsep, int k |
    path = get_path("extractor.path") and k = 0
    or
    path = get_path("sys.path") and k = count(get_path("extractor.path").splitAt(pathsep))
  |
    py_flags_versioned("os.pathsep", pathsep, _) and
    result = path.splitAt(pathsep, n - k).replaceAll("\\", "/")
  )
}

private string get_path(string name) { py_flags_versioned(name, result, _) }

class Location extends @location {
  /** Gets the file for this location */
  File getFile() { result = this.getPath() }

  private Container getPath() {
    locations_default(this, result, _, _, _, _)
    or
    exists(Module m | locations_ast(this, m, _, _, _, _) | result = m.getPath())
  }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() {
    locations_default(this, _, result, _, _, _) or
    locations_ast(this, _, result, _, _, _)
  }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() {
    locations_default(this, _, _, result, _, _) or
    locations_ast(this, _, _, result, _, _)
  }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() {
    locations_default(this, _, _, _, result, _) or
    locations_ast(this, _, _, _, result, _)
  }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() {
    locations_default(this, _, _, _, _, result) or
    locations_ast(this, _, _, _, _, result)
  }

  /** Gets a textual representation of this element. */
  string toString() {
    result = this.getPath().getAbsolutePath() + ":" + this.getStartLine().toString()
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
    exists(File f | f.getAbsolutePath() = filepath |
      locations_default(this, f, startline, startcolumn, endline, endcolumn)
      or
      exists(Module m | m.getFile() = f |
        locations_ast(this, m, startline, startcolumn, endline, endcolumn)
      )
    )
    or
    // Packages have no suitable filepath, so we use just the path instead.
    exists(Module m | not exists(m.getFile()) |
      filepath = m.getPath().getAbsolutePath() and
      locations_ast(this, m, startline, startcolumn, endline, endcolumn)
    )
  }
}

/** A non-empty line in the source code */
class Line extends @py_line {
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
    exists(Module m |
      m.getFile().getAbsolutePath() = filepath and
      endline = startline and
      startcolumn = 1 and
      py_line_lengths(this, m, startline, endcolumn)
    )
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Module m | py_line_lengths(this, m, _, _) |
      result = m.getFile().getShortName() + ":" + this.getLineNumber().toString()
    )
  }

  /** Gets the line number of this line */
  int getLineNumber() { py_line_lengths(this, _, result, _) }

  /** Gets the length of this line */
  int getLength() { py_line_lengths(this, _, _, result) }

  /** Gets the file for this line */
  Module getModule() { py_line_lengths(this, result, _, _) }
}

/**
 * A syntax error. Note that if there is a syntax error in a module,
 * much information about that module will be lost
 */
class SyntaxError extends Location {
  SyntaxError() { py_syntax_error_versioned(this, _, major_version().toString()) }

  override string toString() { result = "Syntax Error" }

  /** Gets the message corresponding to this syntax error */
  string getMessage() { py_syntax_error_versioned(this, result, major_version().toString()) }
}

/**
 * An encoding error. Note that if there is an encoding error in a module,
 * much information about that module will be lost
 */
class EncodingError extends SyntaxError {
  EncodingError() {
    /* Leave spaces around 'decode' in unlikely event it occurs as a name in a syntax error */
    this.getMessage().toLowerCase().matches("% decode %")
  }

  override string toString() { result = "Encoding Error" }
}
