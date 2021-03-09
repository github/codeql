private import codeql_ruby.AST
private import codeql_ruby.ast.Constant
private import internal.Module

/**
 * The base class for classes, singleton classes, and modules.
 */
class ModuleBase extends BodyStatement, Scope {
  override ModuleBase::Range range;

  /** Gets a method defined in this module/class. */
  MethodBase getAMethod() { result = this.getAStmt() }

  /** Gets the method named `name` in this module/class, if any. */
  MethodBase getMethod(string name) { result = this.getAMethod() and result.getName() = name }

  /** Gets a class defined in this module/class. */
  Class getAClass() { result = this.getAStmt() }

  /** Gets the class named `name` in this module/class, if any. */
  Class getClass(string name) { result = this.getAClass() and result.getName() = name }

  /** Gets a module defined in this module/class. */
  Module getAModule() { result = this.getAStmt() }

  /** Gets the module named `name` in this module/class, if any. */
  Module getModule(string name) { result = this.getAModule() and result.getName() = name }
}

/**
 * A Ruby source file.
 *
 * ```rb
 * def main
 *   puts "hello world!"
 * end
 * main
 * ```
 */
class Toplevel extends ModuleBase, @program {
  final override Toplevel::Range range;

  final override string getAPrimaryQlClass() { result = "Toplevel" }

  /**
   * Gets the `n`th `BEGIN` block.
   */
  final BeginBlock getBeginBlock(int n) { result = range.getBeginBlock(n) }

  /**
   * Gets a `BEGIN` block.
   */
  final BeginBlock getABeginBlock() { result = getBeginBlock(_) }
}

/**
 * A class or module definition.
 *
 * ```rb
 * class Foo
 *   def bar
 *   end
 * end
 * module Bar
 *   class Baz
 *   end
 * end
 * ```
 */
class Namespace extends ModuleBase, ConstantWriteAccess {
  override Namespace::Range range;

  override string getAPrimaryQlClass() { result = "Namespace" }

  /**
   * Gets the name of the module/class. In the following example, the result is
   * `"Foo"`.
   * ```rb
   * class Foo
   * end
   * ```
   *
   * N.B. in the following example, where the module/class name uses the scope
   * resolution operator, the result is the name being resolved, i.e. `"Bar"`.
   * Use `getScopeExpr` to get the `Foo` for `Foo`.
   * ```rb
   * module Foo::Bar
   * end
   * ```
   */
  override string getName() { result = range.getName() }

  /**
   * Gets the scope expression used in the module/class name's scope resolution
   * operation, if any.
   *
   * In the following example, the result is the `Expr` for `Foo`.
   *
   * ```rb
   * module Foo::Bar
   * end
   * ```
   *
   * However, there is no result for the following example, since there is no
   * scope resolution operation.
   *
   * ```rb
   * module Baz
   * end
   * ```
   */
  override Expr getScopeExpr() { result = range.getScopeExpr() }

  /**
   * Holds if the module/class name uses the scope resolution operator to access the
   * global scope, as in this example:
   *
   * ```rb
   * class ::Foo
   * end
   * ```
   */
  override predicate hasGlobalScope() { range.hasGlobalScope() }
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
class Class extends Namespace, @class {
  final override Class::Range range;

  final override string getAPrimaryQlClass() { result = "Class" }

  /**
   * Gets the `Expr` used as the superclass in the class definition, if any.
   *
   * In the following example, the result is a `ConstantReadAccess`.
   * ```rb
   * class Foo < Bar
   * end
   * ```
   *
   * In the following example, where the superclass is a call expression, the
   * result is a `Call`.
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
class Module extends Namespace, @module {
  final override Module::Range range;

  final override string getAPrimaryQlClass() { result = "Module" }
}
