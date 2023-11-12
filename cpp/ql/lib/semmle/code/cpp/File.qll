/**
 * Provides classes representing files and folders.
 */

import semmle.code.cpp.Element
import semmle.code.cpp.Declaration
import semmle.code.cpp.metrics.MetricFile
private import codeql.util.FileSystem

private module Input implements InputSig {
  abstract class ContainerBase extends @container {
    abstract string getAbsolutePath();

    ContainerBase getParentContainer() {
      containerparent(unresolveElement(result), underlyingElement(this))
    }

    string toString() { result = this.getAbsolutePath() }
  }

  class FolderBase extends ContainerBase, @folder {
    override string getAbsolutePath() { folders(underlyingElement(this), result) }
  }

  class FileBase extends ContainerBase, @file {
    override string getAbsolutePath() { files(underlyingElement(this), result) }
  }

  predicate hasSourceLocationPrefix = sourceLocationPrefix/1;
}

private module Impl = Make<Input>;

/** A file or folder. */
class Container extends ElementBase, Impl::Container {
  override string toString() { result = Impl::Container.super.toString() }
}

/**
 * A folder that was observed on disk during the build process.
 *
 * For the example folder name of "/usr/home/me", the path decomposes to:
 *
 *  1. "/usr/home" - see `getParentContainer`.
 *  2. "me" - see `getBaseName`.
 *
 * To get the full path, use `getAbsolutePath`.
 */
class Folder extends Container, Impl::Folder {
  override string getAPrimaryQlClass() { result = "Folder" }
}

/**
 * A file that was observed on disk during the build process.
 *
 * For the example filename of "/usr/home/me/myprogram.c", the filename
 * decomposes to:
 *
 *  1. "/usr/home/me" - see `getParentContainer`.
 *  2. "myprogram.c" - see `getBaseName`.
 *
 * The base name further decomposes into the _stem_ and _extension_ -- see
 * `getStem` and `getExtension`. To get the full path, use `getAbsolutePath`.
 */
class File extends Container, Locatable, Impl::File {
  override string getAPrimaryQlClass() { result = "File" }

  override Location getLocation() {
    result.getContainer() = this and
    result.hasLocationInfo(_, 0, 0, 0, 0)
  }

  /** Holds if this file was compiled as C (at any point). */
  predicate compiledAsC() { fileannotations(underlyingElement(this), 1, "compiled as c", "1") }

  /** Holds if this file was compiled as C++ (at any point). */
  predicate compiledAsCpp() { fileannotations(underlyingElement(this), 1, "compiled as c++", "1") }

  /**
   * Holds if this file was compiled by a Microsoft compiler (at any point).
   *
   * Note: currently unreliable - on some projects only some of the files that
   * are compiled by a Microsoft compiler are detected by this predicate.
   */
  predicate compiledAsMicrosoft() {
    exists(File f, Compilation c |
      c.getAFileCompiled() = f and
      (
        c.getAnArgument() = "--microsoft" or
        c.getAnArgument()
            .toLowerCase()
            .replaceAll("\\", "/")
            .matches(["%/cl.exe", "%/clang-cl.exe"])
      ) and
      f.getAnIncludedFile*() = this
    )
  }

  /** Gets a top-level element declared in this file. */
  Declaration getATopLevelDeclaration() { result.getAFile() = this and result.isTopLevel() }

  /** Gets a declaration in this file. */
  Declaration getADeclaration() { result.getAFile() = this }

  /** Holds if this file uses the given macro. */
  predicate usesMacro(Macro m) {
    exists(MacroInvocation mi |
      mi.getFile() = this and
      mi.getMacro() = m
    )
  }

  /**
   * Gets a file that is directly included from this file (using a
   * pre-processor directive like `#include`).
   */
  File getAnIncludedFile() {
    exists(Include i | i.getFile() = this and i.getIncludedFile() = result)
  }

  /**
   * Holds if this file may be from source. This predicate holds for all files
   * except the dummy file, whose name is the empty string, which contains
   * declarations that are built into the compiler.
   */
  override predicate fromSource() { numlines(underlyingElement(this), _, _, _) }

  /** Gets the metric file. */
  MetricFile getMetrics() { result = this }

  /**
   * Gets the remainder of the base name after the first dot character. Note
   * that the name of this predicate is in plural form, unlike `getExtension`,
   * which gets the remainder of the base name after the _last_ dot character.
   *
   * Predicates `getStem` and `getExtension` should be preferred over
   * `getShortName` and `getExtensions` since the former pair is compatible
   * with the file libraries of other languages.
   * Note the slight difference between this predicate and `getStem`:
   * for example, for "file.tar.gz", this predicate will have the result
   * "tar.gz", while `getExtension` will have the result "gz".
   */
  string getExtensions() {
    exists(string name, int firstDotPos |
      name = this.getBaseName() and
      firstDotPos = min([name.indexOf("."), name.length() - 1]) and
      result = name.suffix(firstDotPos + 1)
    )
  }

  /**
   * Gets the short name of this file, that is, the prefix of its base name up
   * to (but not including) the first dot character if there is one, or the
   * entire base name if there is not. For example, if the full name is
   * "/path/to/filename.a.bcd" then the short name is "filename".
   *
   * Predicates `getStem` and `getExtension` should be preferred over
   * `getShortName` and `getExtensions` since the former pair is compatible
   * with the file libraries of other languages.
   * Note the slight difference between this predicate and `getStem`:
   * for example, for "file.tar.gz", this predicate will have the result
   * "file", while `getStem` will have the result "file.tar".
   */
  string getShortName() {
    exists(string name, int firstDotPos |
      name = this.getBaseName() and
      firstDotPos = min([name.indexOf("."), name.length()]) and
      result = name.prefix(firstDotPos)
    )
    or
    this.getAbsolutePath() = "" and
    result = ""
  }
}

/**
 * Holds if any file was compiled by a Microsoft compiler.
 */
predicate anyFileCompiledAsMicrosoft() { any(File f).compiledAsMicrosoft() }

/**
 * A C/C++ header file, as determined (mainly) by file extension.
 *
 * For the related notion of whether a file is included anywhere (using a
 * pre-processor directive like `#include`), use `Include.getIncludedFile`.
 */
class HeaderFile extends File {
  HeaderFile() {
    this.getExtension().toLowerCase() =
      ["h", "r", "hpp", "hxx", "h++", "hh", "hp", "tcc", "tpp", "txx", "t++"]
    or
    not exists(this.getExtension()) and
    exists(Include i | i.getIncludedFile() = this)
  }

  override string getAPrimaryQlClass() { result = "HeaderFile" }

  /**
   * Holds if this header file does not contain any declaration entries or top level
   * declarations.  For example it might be:
   *  - a file containing only preprocessor directives and/or comments
   *  - an empty file
   *  - a file that contains non-top level code or data that's included in an
   *    unusual way
   */
  predicate noTopLevelCode() {
    not exists(DeclarationEntry de | de.getFile() = this) and
    not exists(Declaration d | d.getFile() = this and d.isTopLevel()) and
    not exists(UsingEntry ue | ue.getFile() = this)
  }
}

/**
 * A C source file, as determined by file extension.
 *
 * For the related notion of whether a file is compiled as C code, use
 * `File.compiledAsC`.
 */
class CFile extends File {
  CFile() { this.getExtension().toLowerCase() = ["c", "i"] }

  override string getAPrimaryQlClass() { result = "CFile" }
}

/**
 * A C++ source file, as determined by file extension.
 *
 * For the related notion of whether a file is compiled as C++ code, use
 * `File.compiledAsCpp`.
 */
class CppFile extends File {
  CppFile() {
    this.getExtension().toLowerCase() =
      ["cpp", "cxx", "c++", "cc", "cp", "icc", "ipp", "ixx", "i++", "ii"]
    // Note: .C files are indistinguishable from .c files on some
    // file systems, so we just treat them as CFile's.
  }

  override string getAPrimaryQlClass() { result = "CppFile" }
}
