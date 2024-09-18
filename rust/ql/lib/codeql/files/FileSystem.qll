/** Provides classes for working with files and folders. */

private import codeql.Locations
private import codeql.util.FileSystem
private import codeql.rust.elements.SourceFile
private import codeql.rust.elements.AstNode

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

/** A file. */
class File extends Container, Impl::File {
  /** Holds if this file was extracted from ordinary source code. */
  predicate fromSource() { any() }

  /**
   * Gets the number of lines containing code in this file. This value
   * is approximate.
   */
  int getNumberOfLinesOfCode() {
    result =
      count(int line |
        exists(AstNode node, Location loc |
          not node instanceof SourceFile and loc = node.getLocation()
        |
          node.getFile() = this and
          line = [loc.getStartLine(), loc.getEndLine()] and
          not loc instanceof EmptyLocation
        )
      )
  }
}
