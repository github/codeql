/**
 * Provides a limited public interface to name/type resolution information.
 */

private import javascript
private import semmle.javascript.internal.NameResolution
private import semmle.javascript.internal.TypeResolution
private import semmle.javascript.internal.UnderlyingTypes

/**
 * Interface for accessing name-resolution info about type names.
 */
class TypeNameBindingNode extends NameResolution::Node {
  /**
   * Holds if type refers to, or is an alias for, the given type name relative to the global scope.
   *
   * For example:
   * ```ts
   * var x: Document; // hasQualifiedName("Document")
   * var x: Electron; // hasQualifiedName("Electron")
   * var x: Electron.BrowserWindow; // hasQualifiedName("Electron.BrowserWindow")
   * ```
   */
  predicate hasQualifiedName(string qualifiedName) {
    NameResolution::nodeRefersToModule(this, "global", qualifiedName)
  }

  /**
   * Holds if this refers a value exported by the given module, with the given
   * qualified name. If the `qualifiedName` is empty, this refers to the module itself.
   *
   * For example, the type annotations below have the following name bindings:
   * ```ts
   * import { Request } from "express";
   *
   * var x: Request; // hasUnderlyingType("express", "Request")
   * var x: Request | null; // no result (see hasUnderlyingType)
   * var x: Request & { prop: string }; // no result (see hasUnderlyingType)
   *
   * interface CustomSubtype extends Request {}
   *
   * var x: CustomSubtype; // no result (see hasUnderlyingType)
   *
   * var x: typeof import("express"); // hasUnderlyingType("express", "")
   * ```
   */
  predicate hasQualifiedName(string moduleName, string qualifiedName) {
    NameResolution::nodeRefersToModule(this, moduleName, qualifiedName)
  }

  /**
   * Holds if this type refers to the given type exported from the given module, after
   * unfolding unions and intersections, and following subtype relations.
   *
   * For example:
   * ```ts
   * import { Request } from "express";
   *
   * var x: Request; // hasUnderlyingType("express", "Request")
   * var x: Request | null; // hasUnderlyingType("express", "Request")
   * var x: Request & { prop: string }; // hasUnderlyingType("express", "Request")
   *
   * interface CustomSubtype extends Request {}
   *
   * var x: CustomSubtype; // hasUnderlyingType("express", "Request")
   * ```
   */
  predicate hasUnderlyingType(string moduleName, string qualifiedName) {
    UnderlyingTypes::nodeHasUnderlyingType(this, moduleName, qualifiedName)
  }

  /**
   * Holds if this type refers to the given type from the global scope, after
   * unfolding unions and intersections, and following subtype relations.
   *
   * For example:
   * ```ts
   * var x: Document; // hasUnderlyingType("Document")
   * var x: Document | null; // hasUnderlyingType("Document")
   * var x: Document & { prop: string }; // hasUnderlyingType("Document")
   *
   * interface CustomSubtype extends Document {}
   *
   * var x: CustomSubtype; // hasUnderlyingType("Document")
   * ```
   */
  predicate hasUnderlyingType(string qualifiedName) {
    UnderlyingTypes::nodeHasUnderlyingType(this, qualifiedName)
  }

  /**
   * Gets the declaration of the type being referenced by this name.
   *
   * For example:
   * ```ts
   * class Foo {}
   *
   * type T = Foo;
   * var x: T; // getTypeDefinition() maps T to the class Foo above
   * ```
   *
   * Note that this has no result for function-style classes referenced from
   * a JSDoc comment.
   */
  TypeDefinition getTypeDefinition() { TypeResolution::trackType(result) = this }

  /**
   * Gets a class that this type refers to, after unfolding unions and intersections (but not subtyping).
   *
   * For example, the type of `x` maps to the class `C` in each example below:
   * ```ts
   * class C {}
   *
   * var x: C;
   * var x: C | null;
   * var x: C & { prop: string };
   * ```
   */
  DataFlow::ClassNode getAnUnderlyingClass() {
    UnderlyingTypes::nodeHasUnderlyingClassType(this, result)
  }

  /**
   * Holds if this type contains `string` or `any`, possibly wrapped in a promise.
   */
  predicate hasUnderlyingStringOrAnyType() { TypeResolution::hasUnderlyingStringOrAnyType(this) }

  /**
   * Holds if this refers to a type that is considered untaintable (if actually enforced at runtime).
   *
   * Specifically, the types `number`, `boolean`, `null`, `undefined`, `void`, `never`, as well as literal types (`"foo"`)
   * and enums and enum members have this property.
   */
  predicate isSanitizingPrimitiveType() { TypeResolution::isSanitizingPrimitiveType(this) }
}

/**
 * Interface for accessing name-resolution info about expressions.
 */
class ExprNameBindingNode extends NameResolution::Node {
  /**
   * Holds if this refers a value exported by the given module, with the given
   * qualified name. If the `qualifiedName` is empty, this refers to the module itself.
   *
   * For example, the type annotations below have the following name bindings:
   * ```ts
   * import * as f from "foo";
   *
   * var x = f; // hasQualifiedName(f, "")
   * var x = f.x.y; // hasQualifiedName(f, "x.y")
   * ```
   */
  predicate hasQualifiedName(string moduleName, string qualifiedName) {
    NameResolution::nodeRefersToModule(this, moduleName, qualifiedName)
  }

  /**
   * Gets the class, or function acting as a class, referenced by this name.
   *
   * ```ts
   * class Foo {}
   * const T = Foo;
   * var x = T; // getClassNode() maps T to the class Foo above
   *
   * function Bar() {}
   * Bar.prototype.blah = function() {};
   * const S = Bar;
   * var x = S; // getClassNode() maps S to the function Bar above
   * ```
   */
  DataFlow::ClassNode getClassNode() { NameResolution::nodeRefersToClass(this, result) }
}
