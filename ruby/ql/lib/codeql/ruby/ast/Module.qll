private import codeql.ruby.AST
private import codeql.ruby.ast.Constant
private import internal.AST
private import internal.Module
private import internal.TreeSitter

/**
 * A representation of a run-time `module` or `class` value.
 */
class Module extends TModule {
  /** Gets a declaration of this module, if any. */
  ModuleBase getADeclaration() { result.getModule() = this }

  /** Gets the super class of this module, if any. */
  Module getSuperClass() { result = getSuperClass(this) }

  /** Gets a `prepend`ed module. */
  Module getAPrependedModule() { result = getAPrependedModule(this) }

  /** Gets an `include`d module. */
  Module getAnIncludedModule() { result = getAnIncludedModule(this) }

  /** Holds if this module is a class. */
  pragma[noinline]
  predicate isClass() { this.getADeclaration() instanceof ClassDeclaration }

  /** Gets a textual representation of this module. */
  string toString() {
    this = TResolved(result)
    or
    exists(Namespace n | this = TUnresolved(n) and result = "...::" + n.toString())
  }

  /** Gets the location of this module. */
  Location getLocation() {
    exists(Namespace n | this = TUnresolved(n) and result = n.getLocation())
    or
    result =
      min(Namespace n, string qName, Location loc, int weight |
        this = TResolved(qName) and
        qName = namespaceDeclaration(n) and
        loc = n.getLocation() and
        if exists(loc.getFile().getRelativePath()) then weight = 0 else weight = 1
      |
        loc
        order by
          weight, count(n.getAStmt()) desc, loc.getFile().getAbsolutePath(), loc.getStartLine(),
          loc.getStartColumn()
      )
  }
}

/**
 * The base class for classes, singleton classes, and modules.
 */
class ModuleBase extends BodyStmt, Scope, TModuleBase {
  /** Gets a method defined in this module/class. */
  MethodBase getAMethod() { result = this.getAStmt() }

  /** Gets the method named `name` in this module/class, if any. */
  MethodBase getMethod(string name) { result = this.getAMethod() and result.getName() = name }

  /** Gets a class defined in this module/class. */
  ClassDeclaration getAClass() { result = this.getAStmt() }

  /** Gets the class named `name` in this module/class, if any. */
  ClassDeclaration getClass(string name) { result = this.getAClass() and result.getName() = name }

  /** Gets a module defined in this module/class. */
  ModuleDeclaration getAModule() { result = this.getAStmt() }

  /** Gets the module named `name` in this module/class, if any. */
  ModuleDeclaration getModule(string name) {
    result = this.getAModule() and result.getName() = name
  }

  /**
   * Gets the value of the constant named `name`, if any.
   *
   * For example, the value of `CONST` is `"const"` in
   * ```rb
   * module M
   *   CONST = "const"
   * end
   * ```
   */
  Expr getConstant(string name) {
    exists(AssignExpr ae, ConstantWriteAccess w |
      ae = this.getAStmt() and
      w = ae.getLeftOperand() and
      w.getName() = name and
      not exists(w.getScopeExpr()) and
      result = ae.getRightOperand()
    )
  }

  /** Gets the representation of the run-time value of this module or class. */
  Module getModule() { none() }
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
class Toplevel extends ModuleBase, TToplevel {
  private Ruby::Program g;

  Toplevel() { this = TToplevel(g) }

  final override string getAPrimaryQlClass() { result = "Toplevel" }

  /**
   * Gets the `n`th `BEGIN` block.
   */
  final BeginBlock getBeginBlock(int n) {
    toGenerated(result) = rank[n + 1](int i, Ruby::BeginBlock b | b = g.getChild(i) | b order by i)
  }

  /**
   * Gets a `BEGIN` block.
   */
  final BeginBlock getABeginBlock() { result = this.getBeginBlock(_) }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getBeginBlock" and result = this.getBeginBlock(_)
  }

  final override Module getModule() { result = TResolved("Object") }

  final override string toString() { result = g.getLocation().getFile().getBaseName() }
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
class Namespace extends ModuleBase, ConstantWriteAccess, TNamespace {
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
  override string getName() { none() }

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
  override Expr getScopeExpr() { none() }

  /**
   * Holds if the module/class name uses the scope resolution operator to access the
   * global scope, as in this example:
   *
   * ```rb
   * class ::Foo
   * end
   * ```
   */
  override predicate hasGlobalScope() { none() }

  final override Module getModule() {
    result = any(string qName | qName = namespaceDeclaration(this) | TResolved(qName))
    or
    result = TUnresolved(this)
  }

  override AstNode getAChild(string pred) {
    result = ModuleBase.super.getAChild(pred) or
    result = ConstantWriteAccess.super.getAChild(pred)
  }

  final override string toString() { result = ConstantWriteAccess.super.toString() }
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
class ClassDeclaration extends Namespace, TClassDeclaration {
  private Ruby::Class g;

  ClassDeclaration() { this = TClassDeclaration(g) }

  final override string getAPrimaryQlClass() { result = "ClassDeclaration" }

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
  final Expr getSuperclassExpr() { toGenerated(result) = g.getSuperclass().getChild() }

  final override string getName() {
    result = g.getName().(Ruby::Token).getValue() or
    result = g.getName().(Ruby::ScopeResolution).getName().(Ruby::Token).getValue()
  }

  final override Expr getScopeExpr() {
    toGenerated(result) = g.getName().(Ruby::ScopeResolution).getScope()
  }

  final override predicate hasGlobalScope() {
    exists(Ruby::ScopeResolution sr |
      sr = g.getName() and
      not exists(sr.getScope())
    )
  }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getSuperclassExpr" and result = this.getSuperclassExpr()
  }
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
class SingletonClass extends ModuleBase, TSingletonClass {
  private Ruby::SingletonClass g;

  SingletonClass() { this = TSingletonClass(g) }

  final override string getAPrimaryQlClass() { result = "SingletonClass" }

  /**
   * Gets the expression resulting in the object on which the singleton class
   * is defined. In the following example, the result is the `Expr` for `foo`:
   *
   * ```rb
   * class << foo
   * end
   * ```
   */
  final Expr getValue() { toGenerated(result) = g.getValue() }

  final override string toString() { result = "class << ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getValue" and result = this.getValue()
  }
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
 * will be two instances of `ModuleDeclaration` in the database.
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
class ModuleDeclaration extends Namespace, TModuleDeclaration {
  private Ruby::Module g;

  ModuleDeclaration() { this = TModuleDeclaration(g) }

  final override string getAPrimaryQlClass() { result = "ModuleDeclaration" }

  final override string getName() {
    result = g.getName().(Ruby::Token).getValue() or
    result = g.getName().(Ruby::ScopeResolution).getName().(Ruby::Token).getValue()
  }

  final override Expr getScopeExpr() {
    toGenerated(result) = g.getName().(Ruby::ScopeResolution).getScope()
  }

  final override predicate hasGlobalScope() {
    exists(Ruby::ScopeResolution sr |
      sr = g.getName() and
      not exists(sr.getScope())
    )
  }
}
