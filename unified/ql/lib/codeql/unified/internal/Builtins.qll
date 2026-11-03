/**
 * Provides classes for builtins.
 */

private import unified

/** The folder containing builtins. */
class BuiltinsFolder extends Folder {
  BuiltinsFolder() {
    not exists(this.getRelativePath()) and
    this.getBaseName() = "builtins" and
    this.getParentContainer().getBaseName() = "tools"
  }
}

private class BuiltinsTypesFile extends File {
  BuiltinsTypesFile() {
    this.getBaseName() = "types.swift" and
    this.getParentContainer() instanceof BuiltinsFolder
  }
}

/**
 * A builtin type, such as `Bool` and `String`.
 *
 * Builtin types are represented as class-like declarations.
 */
class BuiltinClassLikeDeclaration extends ClassLikeDeclaration {
  BuiltinClassLikeDeclaration() { this.getFile() instanceof BuiltinsTypesFile }
}
