/** Provides classes for working with files and folders. */

import python
private import codeql.util.FileSystem

private module Input implements InputSig {
  abstract class ContainerBase extends @container {
    abstract string getAbsolutePath();

    ContainerBase getParentContainer() { containerparent(result, this) }

    string toString() { result = this.getAbsolutePath() }
  }

  class FolderBase extends ContainerBase, @folder {
    override string getAbsolutePath() { folders(this, result) }
  }

  class FileBase extends ContainerBase, @file {
    override string getAbsolutePath() { files(this, result) }
  }

  predicate hasSourceLocationPrefix = sourceLocationPrefix/1;
}

private module Impl = Make<Input>;

/** A file */
class File extends Container, Impl::File {
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
    this.getAbsolutePath() = filepath and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  /** Whether this file is a source code file. */
  predicate fromSource() {
    /* If we start to analyze .pyc files, then this will have to change. */
    any()
  }

  /** Gets a short name for this file (just the file name) */
  string getShortName() { result = this.getBaseName() }

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

  /** Holds if this file is likely to get executed directly, and thus act as an entry point for execution. */
  predicate isPossibleEntryPoint() {
    // Only consider files in the source code, and not things like the standard library
    exists(this.getRelativePath()) and
    (
      // The file doesn't have the extension `.py` but still contains Python statements
      not this.getExtension().matches("py%") and
      exists(Stmt s | s.getLocation().getFile() = this)
      or
      // The file contains the usual `if __name__ == '__main__':` construction
      exists(If i, Name name, StringLiteral main, Cmpop op |
        i.getScope().(Module).getFile() = this and
        op instanceof Eq and
        i.getTest().(Compare).compares(name, op, main) and
        name.getId() = "__name__" and
        main.getText() = "__main__"
      ) and
      // Exclude files named `__main__.py`. These are often _not_ meant to be run directly, but
      // contain this construct anyway.
      //
      // Their presence in a package (say, `foo`) means one can execute the package directly using
      // `python -m foo` (which will run the `foo/__main__.py` file). Since being an entry point for
      // execution means treating imports as absolute, this causes trouble, since when run with
      // `python -m`, the interpreter uses the usual package semantics.
      not this.getShortName() = "__main__.py"
      or
      // The file contains a `#!` line referencing the python interpreter
      exists(Comment c |
        c.getLocation().getFile() = this and
        c.getLocation().getStartLine() = 1 and
        c.getText().regexpMatch("^#! */.*python(2|3)?[ \\\\t]*$")
      )
    )
  }
}

private predicate occupied_line(File f, int n) {
  exists(Location l | l.getFile() = f |
    l.getStartLine() = n
    or
    exists(StringLiteral s | s.getLocation() = l | n in [l.getStartLine() .. l.getEndLine()])
  )
}

/** A folder (directory) */
class Folder extends Container, Impl::Folder {
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
    this.getAbsolutePath() = filepath and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

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
class Container extends Impl::Container {
  Container getParent() { result = this.getParentContainer() }

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

  override Container getParentContainer() { result = super.getParentContainer() }

  Container getChildContainer(string baseName) {
    result = this.getAChildContainer() and
    result.getBaseName() = baseName
  }

  /** Holds if this folder is on the import path. */
  predicate isImportRoot() { this.isImportRoot(_) }

  /**
   * Holds if this folder is on the import path, at index `n` in the list of
   * paths. The list of paths is composed of the paths passed to the extractor and
   * `sys.path`.
   */
  predicate isImportRoot(int n) { this.getAbsolutePath() = import_path_element(n) }

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
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
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
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
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
