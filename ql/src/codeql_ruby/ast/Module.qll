private import codeql_ruby.AST
private import internal.Module

/**
 * The base class for classes, singleton classes, and modules.
 */
class ModuleBase extends BodyStatement {
  override ModuleBase::Range range;

  /** Gets a method defined in this module/class. */
  Method getAMethod() { result = this.getAnExpr() }

  /** Gets the method named `name` in this module/class, if any. */
  Method getMethod(string name) { result = this.getAMethod() and result.getName() = name }

  /** Gets a class defined in this module/class. */
  Class getAClass() { result = this.getAnExpr() }

  /** Gets the class named `name` in this module/class, if any. */
  Class getClass(string name) { result = this.getAClass() and result.getName() = name }

  /** Gets a module defined in this module/class. */
  Module getAModule() { result = this.getAnExpr() }

  /** Gets the module named `name` in this module/class, if any. */
  Module getModule(string name) { result = this.getAModule() and result.getName() = name }
}

/**
 * A class definition.
 *
 * ```rb
 * class Foo
 *   def bar
 *   end
 * end
 * ```
 */
class Class extends ModuleBase {
  final override Class::Range range;

  final override string getAPrimaryQlClass() { result = "Class" }

  /**
   * Gets the name of the class. In the following example, the result is
   * `"Foo"`.
   * ```rb
   * class Foo
   * end
   * ```
   *
   * N.B. in the following example, where the class name is a scope resolution,
   * the result is the name being resolved, i.e. `"Bar"`. Use
   * `getScopeResolutionName` to get the complete `ScopeResolution`.
   * ```rb
   * class Foo::Bar
   * end
   * ```
   */
  final string getName() { result = range.getName() }

  /**
   * Gets the scope resolution used to define the class name, if any. In the
   * following example, the result is the `ScopeResolution` for `Foo::Bar`,
   * while `getName()` returns `"Bar"`.
   * ```rb
   * class Foo::Bar
   * end
   * ```
   *
   * In the following example, the name is not a scope resolution, so there is
   * no result.
   * ```rb
   * class Baz
   * end
   * ```
   */
  final ScopeResolution getNameScopeResolution() { result = range.getNameScopeResolution() }

  /**
   * Gets the `Expr` used as the superclass in the class definition, if any.
   *
   * TODO: add example for `class A < Foo` once we have `ConstantAccess`
   *
   * For example, where the superclass is a call expression, the result is a
   * `Call`.
   * ```rb
   * class C < foo()
   * end
   * ```
   */
  final Expr getSuperclassExpr() { result = range.getSuperclassExpr() }
}

/**
 * A definition of a singleton class on an object.
 *
 * ```rb
 * class << foo
 *   def bar
 *     p 'bar'
 *   end
 * end
 * ```
 */
class SingletonClass extends ModuleBase, @singleton_class {
  final override SingletonClass::Range range;

  final override string getAPrimaryQlClass() { result = "Class" }

  /**
   * Gets the expression resulting in the object on which the singleton class
   * is defined. In the following example, the result is the `Expr` for `foo`:
   *
   * ```rb
   * class << foo
   * end
   * ```
   */
  final Expr getValue() { result = range.getValue() }
}

/**
 * A module definition.
 *
 * ```rb
 * module Foo
 *   class Bar
 *   end
 * end
 * ```
 *
 * N.B. this class represents a single instance of a module definition. In the
 * following example, classes `Bar` and `Baz` are both defined in the module
 * `Foo`, but in two syntactically distinct definitions, meaning that there
 * will be two instances of `Module` in the database.
 *
 * ```rb
 * module Foo
 *   class Bar; end
 * end
 *
 * module Foo
 *   class Baz; end
 * end
 * ```
 */
class Module extends ModuleBase, @module {
  final override Module::Range range;

  final override string getAPrimaryQlClass() { result = "Module" }

  /**
   * Gets the name of the module. In the following example, the result is
   * `"Foo"`.
   * ```rb
   * module Foo
   * end
   * ```
   *
   * N.B. in the following example, where the module name is a scope
   * resolution, the result is the name being resolved, i.e. `"Bar"`. Use
   * `getScopeResolutionName` to get the complete `ScopeResolution`.
   * ```rb
   * module Foo::Bar
   * end
   * ```
   */
  final string getName() { result = range.getName() }

  /**
   * Gets the scope resolution used to define the module name, if any. In the
   * following example, the result is the `ScopeResolution` for `Foo::Bar`,
   * while `getName()` returns `"bar"`.
   * ```rb
   * module Foo::Bar
   * end
   * ```
   *
   * In the following example, the name is not a scope resolution, so this
   * predicate has no result:
   * ```rb
   * module Baz
   * end
   * ```
   */
  final ScopeResolution getNameScopeResolution() { result = range.getNameScopeResolution() }
}
