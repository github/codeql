private import codeql.swift.elements.decl.ClassDecl
private import codeql.swift.elements.decl.StructDecl
private import codeql.swift.elements.decl.NominalTypeDecl

/**
 * A `class` or `struct` declaration. For example `MyStruct` or `MyClass` in the following example:
 * ```swift
 * struct MyStruct {
 *   // ...
 * }
 *
 * class MyClass {
 *   // ...
 * }
 * ```
 */
final class ClassOrStructDecl extends NominalTypeDecl {
  ClassOrStructDecl() {
    this instanceof ClassDecl
    or
    this instanceof StructDecl
  }
}
