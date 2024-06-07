/** Provides classes for working with files and folders. */

import go
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

  /** Gets a subfolder contained in this folder. */
  Folder getASubFolder() { result = this.getAChildContainer() }
}

/** A file, including files that have not been extracted but are referred to as locations for errors. */
class ExtractedOrExternalFile extends Container, Impl::File, Documentable, ExprParent,
  GoModExprParent, DeclParent, ScopeNode
{
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
    not this.getBaseName() = "-" and
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

/** A dummy file. */
class DummyFile extends ExtractedOrExternalFile {
  DummyFile() { this.getBaseName() = "-" }

  override string getAPrimaryQlClass() { result = "DummyFile" }
}

/** An HTML file. */
class HtmlFile extends File {
  HtmlFile() { this.getExtension().regexpMatch("x?html?") }

  override string getAPrimaryQlClass() { result = "HtmlFile" }
}
