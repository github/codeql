private import codeql.ruby.AST
private import codeql.ruby.CFG
private import internal.AST
private import internal.Module
private import internal.TreeSitter
private import internal.Scope

/**
 * A representation of a run-time `module` or `class` value.
 */
class Module extends TModule {
  /** Gets a declaration of this module, if any. */
  ModuleBase getADeclaration() { result.getModule() = this }

  /** Gets the super class of this module, if any. */
  Module getSuperClass() { result = getSuperClass(this) }

  /** Gets an immediate sub class of this module, if any. */
  Module getASubClass() { this = getSuperClass(result) }

  /** Gets a `prepend`ed module. */
  Module getAPrependedModule() { result = getAPrependedModule(this) }

  /** Gets an `include`d module. */
  Module getAnIncludedModule() { result = getAnIncludedModule(this) }

  /** Gets the super class or an included or prepended module. */
  Module getAnImmediateAncestor() {
    result = [this.getSuperClass(), this.getAPrependedModule(), this.getAnIncludedModule()]
  }

  /** Gets a direct subclass or module including or prepending this one. */
  Module getAnImmediateDescendent() { this = result.getAnImmediateAncestor() }

  /** Gets a module that is transitively subclassed, included, or prepended by this module. */
  pragma[inline]
  Module getAnAncestor() { result = this.getAnImmediateAncestor*() }

  /** Gets a module that transitively subclasses, includes, or prepends this module. */
  pragma[inline]
  Module getADescendent() { result = this.getAnImmediateDescendent*() }

  /** Holds if this module is a class. */
  pragma[noinline]
  predicate isClass() {
    this.getADeclaration() instanceof ClassDeclaration
    or
    // If another class extends this, but we can't see the class declaration, assume it's a class
    getSuperClass(_) = this
  }

  /** Gets a textual representation of this module. */
  string toString() {
    this = TResolved(result)
    or
    exists(Namespace n | this = TUnresolved(n) and result = "...::" + n.toString())
  }

  /**
   * Gets the qualified name of this module, if any.
   *
   * Only modules that can be resolved will have a qualified name.
   */
  final string getQualifiedName() { this = TResolved(result) }

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

  /** Gets a constant or `self` access that refers to this module. */
  private Expr getAnImmediateReferenceBase() {
    resolveConstantReadAccess(result) = this
    or
    result.(SelfVariableAccess).getVariable() = this.getADeclaration().getModuleSelfVariable()
  }

  /** Gets a singleton class that augments this module object. */
  SingletonClass getASingletonClass() { result.getValue() = this.getAnImmediateReferenceBase() }

  /**
   * Gets a singleton method on this module, either declared as a singleton method
   * or an instance method on a singleton class.
   *
   * Does not take inheritance into account.
   */
  MethodBase getAnOwnSingletonMethod() {
    result.(SingletonMethod).getObject() = this.getAnImmediateReferenceBase()
    or
    result = this.getASingletonClass().getAMethod().(Method)
  }

  /**
   * Gets an instance method named `name` declared in this module.
   *
   * Does not take inheritance into account.
   */
  Method getOwnInstanceMethod(string name) { result = this.getADeclaration().getMethod(name) }

  /**
   * Gets an instance method declared in this module.
   *
   * Does not take inheritance into account.
   */
  Method getAnOwnInstanceMethod() { result = this.getADeclaration().getMethod(_) }

  /**
   * Gets the instance method named `name` available in this module, including methods inherited
   * from ancestors.
   */
  Method getInstanceMethod(string name) { result = lookupMethod(this, name) }

  /**
   * Gets an instance method available in this module, including methods inherited
   * from ancestors.
   */
  Method getAnInstanceMethod() { result = lookupMethod(this, _) }

  /** Gets a constant or `self` access that refers to this module. */
  Expr getAnImmediateReference() {
    result = this.getAnImmediateReferenceBase()
    or
    result.(SelfVariableAccess).getVariable().getDeclaringScope() = this.getAnOwnSingletonMethod()
  }

  pragma[nomagic]
  private string getEnclosingModuleName() {
    exists(string qname |
      qname = this.getQualifiedName() and
      result = qname.regexpReplaceAll("::[^:]*$", "") and
      qname != result
    )
  }

  pragma[nomagic]
  private string getOwnModuleName() {
    result = this.getQualifiedName().regexpReplaceAll("^.*::", "")
  }

  /**
   * Gets the enclosing module, as it appears in the qualified name of this module.
   *
   * For example, the parent module of `A::B` is `A`, and `A` itself has no parent module.
   */
  pragma[nomagic]
  Module getParentModule() { result.getQualifiedName() = this.getEnclosingModuleName() }

  /**
   * Gets a module named `name` declared inside this one (not aliased), provided
   * that such a module is defined or reopened in the current codebase.
   *
   * For example, for `A::B` the nested module named `C` would be `A::B::C`.
   *
   * Note that this is not the same as constant lookup. If `A::B::C` would resolve to a
   * module whose qualified name is not `A::B::C`, then it will not be found by
   * this predicate.
   */
  pragma[nomagic]
  Module getNestedModule(string name) {
    result.getParentModule() = this and
    result.getOwnModuleName() = name
  }

  /**
   * Holds if this is a built-in module, e.g. `Object`.
   */
  predicate isBuiltin() { isBuiltinModule(this) }
}

/**
 * Gets the enclosing module of `s`, but only if `s` and the module are in the
 * same CFG scope. For example, in
 *
 * ```rb
 * module M
 *   def pub; end
 *   private def priv; end
 * end
 * ```
 *
 * `M` is the enclosing module of `pub` and `priv`, in the same CFG scope, while
 * in
 *
 * ```rb
 * module M
 *   def m
 *     def nested; end
 *   end
 * end
 * ```
 *
 * `M` is the enclosing module of `m`, in the same CFG scope, while `nested` is not.
 */
pragma[nomagic]
private ModuleBase getEnclosingModuleInSameCfgScope(Stmt s) {
  result = s.getEnclosingModule() and
  s.getCfgScope() = [result.(CfgScope), result.getCfgScope()]
}

/**
 * The base class for classes, singleton classes, and modules.
 */
class ModuleBase extends BodyStmt, Scope, TModuleBase {
  /** Gets a method defined in this module/class. */
  MethodBase getAMethod() { this = getEnclosingModuleInSameCfgScope(result) }

  /** Gets the method named `name` in this module/class, if any. */
  MethodBase getMethod(string name) { result = this.getAMethod() and result.getName() = name }

  /** Gets a class defined in this module/class. */
  ClassDeclaration getAClass() { this = getEnclosingModuleInSameCfgScope(result) }

  /** Gets the class named `name` in this module/class, if any. */
  ClassDeclaration getClass(string name) { result = this.getAClass() and result.getName() = name }

  /** Gets a module defined in this module/class. */
  ModuleDeclaration getAModule() { this = getEnclosingModuleInSameCfgScope(result) }

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

  /**
   * Gets the `self` variable in the module-level scope.
   *
   * Does not include the `self` variable from any of the methods in the module.
   */
  SelfVariable getModuleSelfVariable() { result.getDeclaringScope() = this }

  /** Gets the nearest enclosing `Namespace` or `Toplevel`, possibly this module itself. */
  Namespace getNamespaceOrToplevel() {
    result = this
    or
    not this instanceof Namespace and
    result = this.getEnclosingModule().getNamespaceOrToplevel()
  }

  /**
   * Gets an expression denoting the super class or an included or prepended module.
   *
   * For example, `C` is an ancestor expression of `M` in each of the following examples:
   * ```rb
   * class M < C
   * end
   *
   * module M
   *   include C
   *   prepend C
   * end
   * ```
   */
  Expr getAnAncestorExpr() {
    exists(MethodCall call |
      call.getReceiver().(SelfVariableAccess).getVariable() = this.getModuleSelfVariable() and
      call.getMethodName() = ["include", "prepend"] and
      result = call.getArgument(0) and
      scopeOfInclSynth(call) = this // only permit calls directly in the module scope, not in a block
    )
    or
    result = this.(ClassDeclaration).getSuperclassExpr()
  }
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
