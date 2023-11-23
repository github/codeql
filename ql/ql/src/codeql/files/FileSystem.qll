/** Provides classes for working with files and folders. */

private import codeql_ql.ast.internal.TreeSitter
private import codeql.Locations
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

/** A file. */
class File extends Container, Impl::File {
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
