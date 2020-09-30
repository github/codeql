/**
 * Provides models of "portals", that is, interface points between different
 * components of a code base. A typical example of a portal is a parameter
 * of a function exported by an npm package (which is the only kind of component
 * we support at the moment).
 *
 * Portals have entry and exit nodes. For example, the (unique) exit node of
 * the parameter of an exported function is the `ParameterNode` corresponding
 * to that parameter, while its entries are all nodes corresponding to arguments
 * passed into the parameter via a call.
 *
 * The API of this library is not stable yet and may change.
 */

import javascript

private newtype TPortal =
  MkGlobalObjectPortal() or
  MkNpmPackagePortal(string pkgName) {
    NpmPackagePortal::imports(_, pkgName) or
    NpmPackagePortal::imports(_, pkgName, _) or
    NpmPackagePortal::exports(pkgName, _) or
    MemberPortal::exports(pkgName, _, _)
  } or
  MkMemberPortal(Portal base, string prop) {
    (
      MemberPortal::reads(base, prop, _, _) or
      MemberPortal::writes(base, prop, _, _)
    ) and
    // only consider alpha-numeric properties, excluding special properties
    // and properties whose names look like they are meant to be internal
    prop.regexpMatch("(?!prototype$|__)[a-zA-Z_]\\w*")
  } or
  MkInstancePortal(Portal base) {
    InstancePortal::instanceUse(base, _, _) or
    InstancePortal::instanceDef(base, _, _) or
    InstancePortal::instanceMemberDef(base, _, _, _)
  } or
  MkParameterPortal(Portal base, int i) {
    ParameterPortal::parameter(base, i, _, _) or
    ParameterPortal::argument(base, i, _, _)
  } or
  MkReturnPortal(Portal base) {
    ReturnPortal::calls(_, base, _) or
    ReturnPortal::returns(base, _, _)
  }

/**
 * A portal, that is, an interface point between different npm packages.
 */
cached
class Portal extends TPortal {
  /**
   * Gets an exit node for this portal, that is, a node from which data
   * that comes through the portal emerges. The flag `isRemote`
   * indicates whether data read from this node may come from a different
   * package.
   */
  cached
  abstract DataFlow::SourceNode getAnExitNode(boolean isRemote);

  /**
   * Gets an entry node for this portal, that is, a node through which data
   * enters the portal. The flag `escapes` indicates whether data written to
   * the node may escape to a different package.
   */
  cached
  abstract DataFlow::Node getAnEntryNode(boolean escapes);

  /**
   * Gets the member portal with the given `name` of this portal, if any.
   */
  cached
  MemberPortal getMember(string name) {
    result.getName() = name and
    result.getBasePortal() = this
  }

  /**
   * Gets the instance portal of this portal, if any.
   */
  cached
  InstancePortal getInstance() { result.getBasePortal() = this }

  /**
   * Gets the portal of parameter `idx` of this portal, if any.
   */
  cached
  ParameterPortal getParameter(int idx) {
    result.getIndex() = idx and
    result.getBasePortal() = this
  }

  /**
   * Gets the return value portal of this portal, if any.
   */
  cached
  ReturnPortal getReturn() { result.getBasePortal() = this }

  /**
   * Gets the `i`th base portal of this portal.
   *
   * The `0`th base portal is the portal itself, the `n+1`st base portal is the `n`th base portal
   * of the portal `p` of which this is a member, instance, parameter, or return portal.
   */
  cached
  Portal getBasePortal(int i) {
    i = 0 and
    result = this
    or
    result = this.(CompoundPortal).getBasePortal().getBasePortal(i - 1)
  }

  /**
   * Gets a textual representation of this portal.
   *
   * Different portals must have different `toString`s, so the result of
   * this predicate can be used to uniquely identify a portal.
   */
  cached
  abstract string toString();

  /**
   * INTERNAL: Do not use outside this library.
   *
   * The constructor depth of this portal, used to limit the number of
   * portals.
   */
  cached
  abstract int depth();
}

/**
 * A portal representing the global object.
 */
private class GlobalObjectPortal extends Portal, MkGlobalObjectPortal {
  override DataFlow::SourceNode getAnExitNode(boolean isRemote) {
    result = DataFlow::globalObjectRef() and
    isRemote = true
  }

  override DataFlow::Node getAnEntryNode(boolean escapes) { none() }

  override string toString() { result = "(global)" }

  override int depth() { result = 1 }
}

/**
 * A portal representing the exports value of the main module of an npm
 * package (that is, a value of `module.exports` for CommonJS modules, or
 * the module namespace object for ES2015 modules).
 *
 * Assignments to `module.exports` are entries to this portal, while
 * imports are exits.
 */
private class NpmPackagePortal extends Portal, MkNpmPackagePortal {
  string pkgName;

  NpmPackagePortal() { this = MkNpmPackagePortal(pkgName) }

  /** Gets the name of the npm package. */
  string getName() { result = pkgName }

  override DataFlow::SourceNode getAnExitNode(boolean isRemote) {
    NpmPackagePortal::imports(result, pkgName) and
    isRemote = false
  }

  override DataFlow::Node getAnEntryNode(boolean escapes) {
    NpmPackagePortal::exports(pkgName, result) and
    escapes = true
  }

  override string toString() { result = "(root https://www.npmjs.com/package/" + pkgName + ")" }

  override int depth() { result = 1 }
}

private module NpmPackagePortal {
  /** Gets an import of `imported` inside package `importer`. */
  pragma[noinline]
  private DataFlow::SourceNode getAModuleImport(NPMPackage importer, string imported) {
    result = DataFlow::moduleImport(imported) and
    result.getTopLevel() = importer.getAModule()
  }

  /** Gets an import of `member` from `imported` inside package `importer`. */
  pragma[noinline]
  private DataFlow::SourceNode getAModuleMemberImport(
    NPMPackage importer, string imported, string member
  ) {
    result = DataFlow::moduleMember(imported, member) and
    result.getTopLevel() = importer.getAModule()
  }

  /** Holds if `imp` is an import of package `pkgName`. */
  predicate imports(DataFlow::SourceNode imp, string pkgName) {
    exists(NPMPackage pkg |
      imp = getAModuleImport(pkg, pkgName) and
      pkgName.regexpMatch("[^./].*")
    )
  }

  /** Holds if `imp` imports `member` from package `pkgName`. */
  predicate imports(DataFlow::SourceNode imp, string pkgName, string member) {
    exists(NPMPackage pkg |
      imp = getAModuleMemberImport(pkg, pkgName, member) and
      pkgName.regexpMatch("[^./].*")
    )
  }

  /** Gets the main module of package `pkgName`. */
  Module packageMain(string pkgName) {
    exists(PackageJSON pkg |
      // don't construct portals for private packages
      not pkg.isPrivate() and
      // don't construct portals for vendored-in packages
      exists(Folder pkgDir | pkgDir = pkg.getFile().getParentContainer() |
        pkgDir.getRelativePath() = ""
        or
        not pkgDir.getParentContainer().getBaseName() = "node_modules"
      ) and
      pkg.getPackageName() = pkgName and
      result = pkg.getMainModule()
    )
  }

  /** Holds if the main module of package `pkgName` exports `exp`. */
  predicate exports(string pkgName, DataFlow::Node exp) {
    exists(Module m | m = packageMain(pkgName) |
      exists(AnalyzedPropertyWrite apw |
        apw.writes(m.(AnalyzedModule).getModuleObject(), "exports", exp)
      )
      or
      exists(DataFlow::PropWrite export | exp = export |
        export.getRhs() = m.(ES2015Module).getAnExportedValue("default")
      )
    )
  }
}

/**
 * Gets the maximum depth a portal may have.
 *
 * This is a somewhat crude way of preventing us from constructing infinitely many portals.
 */
private int maxdepth() { result = 10 }

/**
 * A portal that is constructed over some base portal.
 */
abstract private class CompoundPortal extends Portal {
  Portal base;

  bindingset[this]
  CompoundPortal() {
    // bound size of portal to prevent infinite recursion
    base.depth() < maxdepth()
  }

  /** Gets the base portal over which this portal is constructed. */
  Portal getBasePortal() { result = base }

  override int depth() { result = base.depth() + 1 }
}

/**
 * A portal corresponding to a named property of objects flowing through another portal.
 *
 * Entries to this portal are the right-hand sides of writes to the property, while
 * property reads are exits.
 */
private class MemberPortal extends CompoundPortal, MkMemberPortal {
  string prop;

  MemberPortal() { this = MkMemberPortal(base, prop) }

  /** Gets the name of this member. */
  string getName() { result = prop }

  override DataFlow::SourceNode getAnExitNode(boolean isRemote) {
    MemberPortal::reads(base, prop, result, isRemote)
  }

  override DataFlow::Node getAnEntryNode(boolean escapes) {
    MemberPortal::writes(base, prop, result, escapes)
  }

  override string toString() { result = "(member " + prop + " " + base + ")" }
}

private module MemberPortal {
  /** Gets a node representing a value flowing through `base`, that is, either an entry node or an exit node. */
  private DataFlow::SourceNode portalBaseRef(Portal base, boolean escapes) {
    result = base.getAnExitNode(escapes)
    or
    result = base.getAnEntryNode(escapes).getALocalSource()
  }

  /** Holds if `read` is a read of property `prop` of a value flowing through `base`. */
  predicate reads(Portal base, string prop, DataFlow::SourceNode read, boolean isRemote) {
    read = portalBaseRef(base, isRemote).getAPropertyRead(prop)
    or
    // imports are a kind of property read
    exists(string pkg |
      NpmPackagePortal::imports(read, pkg, prop) and
      base = MkNpmPackagePortal(pkg) and
      isRemote = false
    )
    or
    // global variable reads are a kind of property read
    base instanceof GlobalObjectPortal and
    read = DataFlow::globalVarRef(prop) and
    isRemote = true
  }

  /** Holds if the main module of `pkgName` exports `rhs` under the name `prop`. */
  predicate exports(string pkgName, string prop, DataFlow::Node rhs) {
    exists(AnalyzedModule m, AnalyzedPropertyWrite apw |
      m = NpmPackagePortal::packageMain(pkgName) and
      apw.writes(m.getAnExportsValue(), prop, rhs)
    )
  }

  /**
   * Holds if there is a write to property `prop` of a value flowing through `base`, and `rhs` is the
   * right-hand side of that write.
   */
  predicate writes(Portal base, string prop, DataFlow::Node rhs, boolean escapes) {
    portalBaseRef(base, escapes).hasPropertyWrite(prop, rhs)
    or
    InstancePortal::instanceMemberDef(base.(InstancePortal).getBasePortal(), prop, rhs, escapes)
    or
    // exports are a kind of property write.
    exists(string pkgName |
      exports(pkgName, prop, rhs) and
      base = MkNpmPackagePortal(pkgName) and
      escapes = true
    )
    or
    // global variable writes are a kind of property write
    base instanceof GlobalObjectPortal and
    exists(AssignExpr assgn |
      assgn.getLhs() = DataFlow::globalVarRef(prop).asExpr() and
      rhs = assgn.getRhs().flow()
    ) and
    escapes = true
  }
}

/**
 * A portal corresponding to an instantiation of functions or classes flowing through
 * another portal.
 *
 * Entries to this portal are the return values of functions that flow through the base
 * portal (to model the fact that `new f()` evaluates to the return value of `f` it is
 * non-primitive), while exits are `new` expressions and other expressions referring to
 * instances of functions/classes flowing through the base portal.
 */
private class InstancePortal extends CompoundPortal, MkInstancePortal {
  InstancePortal() { this = MkInstancePortal(base) }

  override DataFlow::SourceNode getAnExitNode(boolean isRemote) {
    InstancePortal::instanceUse(base, result, isRemote)
  }

  override DataFlow::Node getAnEntryNode(boolean escapes) {
    InstancePortal::instanceDef(base, result, escapes)
  }

  override string toString() { result = "(instance " + base + ")" }
}

private module InstancePortal {
  /**
   * Holds if `ctor` is a class, or a function that looks like a constructor function,
   * that is, it contains a `this` expression.
   */
  private predicate instantiable(DataFlow::Node ctor) {
    ctor.getAstNode() instanceof ClassDefinition
    or
    exists(ThisExpr thiz | ctor = thiz.getBinder().flow())
  }

  /** Holds if `i` represents instances of `ctor`, which flows into `base`. */
  private predicate isInstance(
    Portal base, DataFlow::SourceNode ctor, AbstractInstance i, boolean escapes
  ) {
    ctor = DataFlow::valueNode(i.getConstructor().getDefinition()) and
    ctor.flowsTo(base.getAnEntryNode(escapes)) and
    instantiable(ctor)
  }

  /** Holds if `nd` is an expression evaluating to an instance of `base`. */
  predicate instanceUse(Portal base, DataFlow::SourceNode nd, boolean isRemote) {
    nd = base.getAnExitNode(isRemote).getAnInstantiation()
    or
    isInstance(base, _, nd.analyze().getAValue(), isRemote)
  }

  /**
   * Holds if there is a definition of a property `name` on an instance of `base`, and `rhs` is the
   * right-hand side of that definition.
   */
  predicate instanceMemberDef(Portal base, string name, DataFlow::Node rhs, boolean escapes) {
    exists(AbstractInstance i, DataFlow::SourceNode ctor | isInstance(base, ctor, i, escapes) |
      // ES2015 instance method
      exists(MemberDefinition mem |
        mem = ctor.getAstNode().(ClassDefinition).getAMember() and
        not mem.isStatic() and
        not mem instanceof ConstructorDefinition
      |
        name = mem.getName() and
        rhs = DataFlow::valueNode(mem.getInit())
      )
      or
      // ES5 instance method
      exists(DataFlow::PropWrite pw |
        pw = ctor.getAPropertyRead("prototype").getAPropertyWrite(name) and
        rhs = pw.getRhs()
      )
    )
  }

  /** Holds if `nd` is a return node of a function flowing into `base`. */
  predicate instanceDef(Portal base, DataFlow::Node nd, boolean escapes) {
    exists(DataFlow::FunctionNode fn |
      isInstance(base, fn, _, escapes) and
      nd = fn.getAReturn() and
      instantiable(fn)
    )
  }
}

/**
 * A portal corresponding to a positional parameter of another portal.
 *
 * Arguments to functions flowing through the base portal are entries, while the corresponding
 * parameter nodes are exits.
 */
class ParameterPortal extends CompoundPortal, MkParameterPortal {
  int i;

  ParameterPortal() { this = MkParameterPortal(base, i) }

  /** Gets the index of the parameterb represented by this portal. */
  int getIndex() { result = i }

  override DataFlow::SourceNode getAnExitNode(boolean isRemote) {
    ParameterPortal::parameter(base, i, result, isRemote)
  }

  override DataFlow::Node getAnEntryNode(boolean escapes) {
    ParameterPortal::argument(base, i, result, escapes)
  }

  override string toString() { result = "(parameter " + i + " " + base + ")" }
}

private module ParameterPortal {
  /** Holds if `param` is the `i`th parameter of a function flowing through `base`. */
  predicate parameter(Portal base, int i, DataFlow::SourceNode param, boolean isRemote) {
    param = base.getAnEntryNode(isRemote).getALocalSource().(DataFlow::FunctionNode).getParameter(i)
  }

  /** Holds if `arg` is the `i`th argument passed to an invocation of a function flowing through `base`. */
  predicate argument(Portal base, int i, DataFlow::Node arg, boolean escapes) {
    exists(DataFlow::InvokeNode invk |
      invk = base.getAnExitNode(escapes).getAnInvocation() and
      arg = invk.getArgument(i)
    )
  }
}

/**
 * A portal corresponding to the return value of another portal.
 *
 * Returned expressions are entries, calls are exits.
 */
class ReturnPortal extends CompoundPortal, MkReturnPortal {
  ReturnPortal() { this = MkReturnPortal(base) }

  override DataFlow::SourceNode getAnExitNode(boolean isRemote) {
    ReturnPortal::calls(result, base, isRemote)
  }

  override DataFlow::Node getAnEntryNode(boolean escapes) {
    ReturnPortal::returns(base, result, escapes)
  }

  override string toString() { result = "(return " + base + ")" }
}

private module ReturnPortal {
  /** Holds if `invk` is a call to a function flowing through `callee`. */
  predicate calls(DataFlow::InvokeNode invk, Portal callee, boolean isRemote) {
    invk = callee.getAnExitNode(isRemote).getAnInvocation()
  }

  /** Holds if `ret` is a return node of a function flowing through `callee`. */
  predicate returns(Portal base, DataFlow::Node ret, boolean escapes) {
    ret = base.getAnEntryNode(escapes).getALocalSource().(DataFlow::FunctionNode).getAReturn()
  }
}
