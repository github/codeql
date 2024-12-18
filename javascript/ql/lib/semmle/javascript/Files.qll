/** Provides classes for working with files and folders. */

import javascript
private import NodeModuleResolutionImpl
private import codeql.util.FileSystem
private import internal.Locations

private module FsInput implements InputSig {
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

private module Impl = Make<FsInput>;

class Container = Impl::Container;

/** A folder. */
class Folder extends Container, Impl::Folder {
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

  /** Like `getFile` except `d.ts` is treated as a single extension. */
  private File getFileLongExtension(string stem, string extension) {
    not (stem.matches("%.d") and extension = "ts") and
    result = this.getFile(stem, extension)
    or
    extension = "d.ts" and
    result = this.getFile(stem + ".d", "ts")
  }

  /**
   * Gets the file in this folder that has the given `stem` and any of the supported JavaScript extensions.
   *
   * If there are multiple such files, the one with the "best" extension is chosen based on a
   * prioritized list of file extensions.
   *
   * `js` files are given less preference than files that compile to `js`, to ensure we pick the
   * original source file rather than its compiled output.
   *
   * HTML files will not be found by this method.
   */
  File getJavaScriptFile(string stem) {
    result =
      min(int p, string ext |
        p = getFileExtensionPriority(ext)
      |
        this.getFileLongExtension(stem, ext) order by p
      )
  }

  /** Gets a subfolder contained in this folder. */
  Folder getASubFolder() { result = this.getAChildContainer() }
}

/** A file. */
class File extends Container, Impl::File {
  /**
   * Gets the location of this file.
   *
   * Note that files have special locations starting and ending at line zero, column zero.
   */
  DbLocation getLocation() { result = getLocatableLocation(this) }

  /** Gets the number of lines in this file. */
  int getNumberOfLines() { result = sum(int loc | numlines(this, loc, _, _) | loc) }

  /** Gets the number of lines containing code in this file. */
  int getNumberOfLinesOfCode() { result = sum(int loc | numlines(this, _, loc, _) | loc) }

  /** Gets the number of lines containing comments in this file. */
  int getNumberOfLinesOfComments() { result = sum(int loc | numlines(this, _, _, loc) | loc) }

  /** Gets a toplevel piece of JavaScript code in this file. */
  TopLevel getATopLevel() { result.getFile() = this }

  /**
   * Holds if line number `lineno` of this file is indented to depth `d`
   * using character `c`.
   *
   * This predicate only holds for lines that belong to JavaScript code that
   * start with one or more occurrences of the same whitespace character,
   * followed by at least one non-whitespace character.
   *
   * It does not hold for lines that do not start with a whitespace character,
   * or for lines starting with a string of different whitespace characters
   * (for instance, a mix of tabs and spaces).
   */
  predicate hasIndentation(int lineno, string c, int d) { indentation(this, lineno, c, d) }

  /**
   * Gets the type of this file.
   */
  FileType getFileType() { filetype(this, result) }
}

/**
 * A file type.
 */
class FileType extends string {
  FileType() { this = ["javascript", "html", "typescript", "json", "yaml"] }

  /**
   * Holds if this is the JavaScript file type.
   */
  predicate isJavaScript() { this = "javascript" }

  /**
   * Holds if this is the HTML file type.
   */
  predicate isHtml() { this = "html" }

  /**
   * Holds if this is the TypeScript file type.
   */
  predicate isTypeScript() { this = "typescript" }

  /**
   * Holds if this is the JSON file type.
   */
  predicate isJson() { this = "json" }

  /**
   * Holds if this is the YAML file type.
   */
  predicate isYaml() { this = "yaml" }
}
