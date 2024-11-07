/**
 * Provides classes representing filesystem files and folders.
 */

private import Comments
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

class Container = Impl::Container;

class Folder = Impl::Folder;

bindingset[flag]
private predicate fileHasExtractionFlag(File f, int flag) {
  exists(int i |
    file_extraction_mode(f, i) and
    i.bitAnd(flag) = flag
  )
}

/** A file. */
class File extends Container, Impl::File {
  /** Gets the number of lines in this file. */
  int getNumberOfLines() { numlines(this, result, _, _) }

  /** Gets the number of lines containing code in this file. */
  int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of lines containing comments in this file. */
  int getNumberOfLinesOfComments() { numlines(this, _, _, result) }

  override string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

  /** Holds if this file is a QL test stub file. */
  pragma[noinline]
  predicate isStub() {
    this.extractedQlTest() and
    this.getAbsolutePath().matches("%resources/stubs/%")
  }

  /** Holds if this file contains source code. */
  final predicate fromSource() {
    this.getExtension() = ["cs", "cshtml", "razor"] and
    not this.isStub()
  }

  /** Holds if this file is a library. */
  final predicate fromLibrary() {
    not this.getBaseName() = "" and
    not this.fromSource()
  }

  /**
   * Holds if this source file came from a PDB.
   * A source file can come from a PDB and from regular extraction
   * in the same snapshot.
   */
  predicate isPdbSourceFile() { fileHasExtractionFlag(this, 2) }

  /**
   * Holds if this file was extracted using `codeql test run`.
   */
  predicate extractedQlTest() { fileHasExtractionFlag(this, 4) }
}

/**
 * A source file.
 */
class SourceFile extends File {
  SourceFile() { this.fromSource() }

  /** Holds if the file was extracted without building the source code. */
  predicate extractedStandalone() { fileHasExtractionFlag(this, 1) }
}
