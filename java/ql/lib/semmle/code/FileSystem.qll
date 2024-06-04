/** Provides classes for working with files and folders. */

import Location
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

/** A file or folder. */
class Container extends Impl::Container, Top {
  override string toString() { result = Impl::Container.super.toString() }
}

/** A folder. */
class Folder extends Container, Impl::Folder {
  override string getAPrimaryQlClass() { result = "Folder" }
}

/**
 * A file.
 *
 * Note that `File` extends `Container` as it may be a `jar` file.
 */
class File extends Container, Impl::File {
  override string getAPrimaryQlClass() { result = "File" }

  /** Holds if this is a (Java or Kotlin) source file. */
  predicate isSourceFile() { this.isJavaSourceFile() or this.isKotlinSourceFile() }

  /** Holds if this is a Java source file. */
  predicate isJavaSourceFile() { this.getExtension() = "java" }

  /** Holds if this is a Kotlin source file. */
  predicate isKotlinSourceFile() { this.getExtension() = "kt" }
}

/**
 * A Java archive file with a ".jar" extension.
 */
class JarFile extends File {
  JarFile() { this.getExtension() = "jar" }

  /**
   * Gets the main attribute with the specified `key`
   * from this JAR file's manifest.
   */
  string getManifestMainAttribute(string key) { jarManifestMain(this, key, result) }

  /**
   * Gets the "Specification-Version" main attribute
   * from this JAR file's manifest.
   */
  string getSpecificationVersion() {
    result = this.getManifestMainAttribute("Specification-Version")
  }

  /**
   * Gets the "Implementation-Version" main attribute
   * from this JAR file's manifest.
   */
  string getImplementationVersion() {
    result = this.getManifestMainAttribute("Implementation-Version")
  }

  /**
   * Gets the per-entry attribute for the specified `entry` and `key`
   * from this JAR file's manifest.
   */
  string getManifestEntryAttribute(string entry, string key) {
    jarManifestEntries(this, entry, key, result)
  }

  override string getAPrimaryQlClass() { result = "JarFile" }
}
