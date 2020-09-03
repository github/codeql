/**
 * Provides an implementation of  _API graphs_, which are an abstract representation of the API
 * surface of an NPM package.
 *
 * The nodes of the API graph are called _features_, with labeled edges representing how features
 * relate to each other. For example, if one of the API features represents a function, then there
 * will be features corresponding to the function's parameters, which are connected to the function
 * feature by edges labeled `parameter <i>`. There are special _points-to_ edges labeled with the
 * empty string which express the fact that one feature is an alias for another.
 */

import javascript

/**
 * Provides classes and predicates for working with APIs defined or used in a database.
 */
module API {
  /**
   * An abstract representation of an API feature such as a function exported by an npm package,
   * a parameter of such a function, or its result.
   */
  class Feature extends Impl::TFeature {
    /**
     * Gets a data-flow node corresponding to a use of this API feature.
     *
     * For example, `require('fs').readFileSync` is a use of the feature `readFileSync` from the
     * `fs` module, and `require('fs').readFileSync(file)` is a use of the result of that function.
     *
     * As another example, in the assignment `exports.plusOne = (x) => x+1` the two references to
     * `x` are uses of the feature corresponding to the first parameter of `plusOne`.
     */
    DataFlow::Node getAUse() {
      exists(DataFlow::SourceNode src | Impl::use(this, src) |
        Impl::trackUseNode(src).flowsTo(result)
      )
    }

    /**
     * Gets a data-flow node corresponding to the right-hand side of a definition of this API
     * feature.
     *
     * For example, in the assignment `exports.plusOne = (x) => x+1`, the function expression
     * `(x) => x+1` is the right-hand side of the  definition of the member feature `plusOne` of
     * the enclosing module, and the expression `x+1` is the right-had side of the definition of
     * its result.
     *
     * Note that for parameters, it is the arguments flowing into that parameter that count as
     * right-hand sides of the definition, not the declaration of the parameter itself.
     * Consequently, in `require('fs').readFileSync(file)`, `file` is the right-hand
     * side of a definition of the first parameter of `readFileSync` from the `fs` module.
     */
    DataFlow::Node getARhs() { Impl::rhs(this, result) }

    /**
     * Gets a feature representing member `m` of this one.
     */
    bindingset[m]
    bindingset[result]
    Feature getMember(string m) { result = getASuccessor(Label::member(m)) }

    /**
     * Gets a feature representing a member with a computed name of this one.
     */
    Feature getUnknownMember() { result = getASuccessor(Label::unknownMember()) }

    /**
     * Gets a feature representing a member of this one.
     */
    Feature getAMember() {
      result = getASuccessor(Label::member(_)) or
      result = getUnknownMember()
    }

    /**
     * Gets a feature representing an instance of this one, that is, an object whose
     * constructor is this feature.
     */
    Feature getInstance() { result = getASuccessor(Label::instance()) }

    /**
     * Gets a feature representing the `i`th parameter of this one.
     */
    bindingset[i]
    Feature getParameter(int i) { result = getASuccessor(Label::parameter(i)) }

    /**
     * Gets the number of parameters of this feature.
     */
    int getNumParameter() {
      result =
        max(string s | exists(getASuccessor(Label::parameterByStringIndex(s))) | s.toInt()) + 1
    }

    /**
     * Gets a feature representing the last parameter of this one.
     */
    Feature getLastParameter() { result = getParameter(getNumParameter() - 1) }

    /**
     * Gets a feature representing the receiver of this one.
     */
    Feature getReceiver() { result = getASuccessor(Label::receiver()) }

    /**
     * Gets a feature representing a parameter or the receiver of this one.
     */
    Feature getAParameter() {
      result = getASuccessor(Label::parameterByStringIndex(_)) or
      result = getReceiver()
    }

    /**
     * Gets a feature representing the result of this one.
     */
    Feature getReturn() { result = getASuccessor(Label::return()) }

    /**
     * Gets a feature representing the promised value wrapped in this promise.
     */
    Feature getPromised() { result = getASuccessor(Label::promised()) }

    /**
     * Gets a string representation of the lexicographically least among all shortest access paths
     * from the root to this feature.
     */
    string getPath() { result = min(string p | p = getAPath(Impl::distanceFromRoot(this)) | p) }

    /**
     * Gets a feature such that there is an edge in the API graph between this feature and the other
     * one, and that edge is labeled with `lbl`. This predicate skips through points-to edges.
     */
    Feature getASuccessor(string lbl) { Impl::edge(this, lbl, result) }

    /**
     * Gets a feature such that there is an edge in the API graph between that other feature and
     * this one, and that edge is labeled with `lbl`. This predicate skips through points-to edges.
     */
    Feature getAPredecessor(string lbl) { this = result.getASuccessor(lbl) }

    /**
     * Gets a feature such that there is an edge in the API graph between this feature and the other
     * one, possibly skipping through points-to edges.
     */
    Feature getAPredecessor() { result = getAPredecessor(_) }

    /**
     * Gets a feature such that there is an edge in the API graph between that other feature and
     * this one, possibly skipping through points-to edges.
     */
    Feature getASuccessor() { result = getASuccessor(_) }

    /**
     * Holds if this feature may take its value from `that` feature.
     *
     * In other words, the value of a use of `that` may flow into the right-hand side of a
     * definition of this feature.
     */
    predicate refersTo(Feature that) { this.getARhs() = that.getAUse() }

    /**
     * Gets the unique data-flow that gives rise to this feature, if any.
     */
    private DataFlow::Node getRepresentativeNode() {
      this = Impl::MkClassInstance(result) or
      this = Impl::MkUse(result) or
      this = Impl::MkDef(result) or
      this = Impl::MkAsyncFuncResult(result)
    }

    /**
     * Holds if this feature is located in file `path` between line `startline`, column `startcol`,
     * and line `endline`, column `endcol`.
     *
     * For features that do not have a meaningful location, `path` is the empty string and all other
     * parameters are zero.
     */
    predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol) {
      getRepresentativeNode().hasLocationInfo(path, startline, startcol, endline, endcol)
      or
      not exists(getRepresentativeNode()) and
      path = "" and
      startline = 0 and
      startcol = 0 and
      endline = 0 and
      endcol = 0
    }

    /**
     * Gets a textual representation of this feature.
     */
    string toString() {
      none() // defined in subclasses
    }

    /**
     * Gets a path of the given `length` from the root to this feature.
     */
    private string getAPath(int length) {
      this instanceof Impl::MkRoot and
      length = 0 and
      result = ""
      or
      exists(Feature pred, string lbl, string predpath |
        Impl::edge(pred, lbl, this) and
        lbl != "" and
        predpath = pred.getAPath(length - 1) and
        exists(string space | if length = 1 then space = "" else space = " " |
          result = "(" + lbl + space + predpath + ")" and
          // avoid producing strings longer than 1MB
          result.length() < 1000 * 1000
        )
      ) and
      length in [1 .. Impl::distanceFromRoot(this)]
    }
  }

  /** The root feature of an API graph. */
  class Root extends Feature, Impl::MkRoot {
    override string toString() { result = "root" }
  }

  /** A feature corresponding to a definition of an API component. */
  class Definition extends Feature, Impl::TDef {
    override string toString() { result = "def " + getPath() }
  }

  /** A feature corresponding to the use of an API component. */
  class Use extends Feature, Impl::TUse {
    override string toString() { result = "use " + getPath() }
  }

  /** Gets the root feature. */
  Root root() { any() }

  /** Gets a feature corresponding to an import of module `m`. */
  Feature moduleImport(string m) {
    result = Impl::MkModuleImport(m) or
    result = Impl::MkModuleImport(m).(Feature).getMember("default")
  }

  /** Gets a feature corresponding to an export of module `m`. */
  Feature moduleExport(string m) { result = Impl::MkModuleDef(m).(Feature).getMember("exports") }

  /**
   * An API entry point.
   *
   * Extend this class to define additional API entry points other than modules.
   * Typical examples include global variables.
   */
  abstract class EntryPoint extends string {
    bindingset[this]
    EntryPoint() { any() }

    /** Gets a data-flow node that uses this entry point. */
    abstract DataFlow::SourceNode getAUse();

    /** Gets a data-flow node that defines this entry point. */
    abstract DataFlow::Node getADef();
  }

  /**
   * Provides the actual implementation of API graphs, cached for performance.
   *
   * Ideally, we'd like features to correspond to (global) access paths, with edge labels
   * corresponding to extending the access path by one element, or (in the case of points-to
   * edges) recording alias information. We also want to be able to map features to their
   * definitions and uses in the data-flow graph, and this should happen modulo
   * (inter-procedural) data flow.
   *
   * This, however, is not easy to implement, since access paths can have unbounded length
   * and we need some way of recognizing cycles to avoid non-termination. However, expressing
   * a condition like "this node hasn't been involved in constructing any predecessor of
   * this feature in the API graph" without negative recursion is tricky.
   *
   * So instead most features are directly associated with a data-flow node, representing
   * either a use or a definition of the feature. This ensures that we only have a finite
   * number of features. However, we can now have multiple features with the same access
   * path, which are essentially indistinguishable for a client of the API.
   *
   * On the other hand, a single feature can have multiple access paths (which is, of
   * course, unavoidable). We pick as canonical the alphabetically least access path with
   * shortest length.
   */
  cached
  private module Impl {
    cached
    newtype TFeature =
      MkRoot() or
      MkModuleDef(string m) { exists(MkModuleExport(m)) } or
      MkModuleUse(string m) { exists(MkModuleImport(m)) } or
      MkModuleExport(string m) {
        exists(Module mod | mod = importableModule(m) |
          // exclude modules that don't actually export anything
          exports(m, _)
          or
          exports(m, _, _)
          or
          exists(NodeModule nm | nm = mod |
            exists(SSA::implicitInit([nm.getModuleVariable(), nm.getExportsVariable()]))
          )
        )
      } or
      MkModuleImport(string m) { imports(_, m) } or
      MkClassInstance(DataFlow::ClassNode cls) { cls = trackDefNode(_) and hasSemantics(cls) } or
      MkAsyncFuncResult(DataFlow::FunctionNode f) {
        f = trackDefNode(_) and f.getFunction().isAsync() and hasSemantics(f)
      } or
      MkDef(DataFlow::Node nd) { rhs(_, _, nd) } or
      MkUse(DataFlow::Node nd) { use(_, _, nd) } or
      MkCanonicalNameDef(CanonicalName n) { isDefined(n) } or
      MkCanonicalNameUse(CanonicalName n) { isUsed(n) }

    class TDef = MkModuleDef or TNonModuleDef;

    class TNonModuleDef =
      MkModuleExport or MkClassInstance or MkAsyncFuncResult or MkDef or MkCanonicalNameDef;

    class TUse = MkModuleUse or MkModuleImport or MkUse or MkCanonicalNameUse;

    private predicate hasSemantics(DataFlow::Node nd) { not nd.getTopLevel().isExterns() }

    /** Holds if `imp` is an import of module `m`. */
    private predicate imports(DataFlow::Node imp, string m) {
      imp = DataFlow::moduleImport(m) and
      // path must not start with a dot or a slash
      m.regexpMatch("[^./].*") and
      hasSemantics(imp)
    }

    /** Gets the definition of module `m`. */
    private Module importableModule(string m) {
      exists(NPMPackage pkg, PackageJSON json |
        json = pkg.getPackageJSON() and not json.isPrivate()
      |
        result = pkg.getMainModule() and
        not result.isExterns() and
        m = pkg.getPackageName()
      )
    }

    private predicate isUsed(CanonicalName n) {
      exists(n.(TypeName).getAnAccess()) or
      exists(n.(Namespace).getAnAccess()) or
      exists(InvokeExpr invk | invk.getResolvedCalleeName() = n)
    }

    private predicate isDefined(CanonicalName n) {
      exists(ASTNode def |
        def = n.(TypeName).getADefinition() or
        def = n.(Namespace).getADefinition() or
        def = n.(CanonicalFunctionName).getADefinition()
      |
        not def.isAmbient()
      )
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of a feature that should have an
     * incoming edge from `base` labeled `lbl` in the API graph.
     */
    cached
    predicate rhs(TFeature base, string lbl, DataFlow::Node rhs) {
      hasSemantics(rhs) and
      (
        base = MkRoot() and
        rhs = lbl.(EntryPoint).getADef()
        or
        exists(string m, string prop |
          base = MkModuleExport(m) and
          lbl = Label::member(prop) and
          exports(m, prop, rhs)
        )
        or
        exists(DataFlow::Node def, DataFlow::SourceNode pred |
          rhs(base, def) and pred = trackDefNode(def)
        |
          exists(DataFlow::PropWrite pw | pw = pred.getAPropertyWrite() |
            lbl = Label::memberFromRef(pw) and
            rhs = pw.getRhs()
          )
          or
          exists(DataFlow::FunctionNode fn | fn = pred |
            not fn.getFunction().isAsync() and
            lbl = Label::return() and
            rhs = fn.getAReturn()
          )
          or
          lbl = Label::promised() and
          PromiseFlow::storeStep(rhs, pred, Promises::valueProp())
        )
        or
        exists(DataFlow::ClassNode cls, string name |
          base = MkClassInstance(cls) and
          lbl = Label::member(name) and
          rhs = cls.getInstanceMethod(name)
        )
        or
        exists(DataFlow::FunctionNode f |
          base = MkAsyncFuncResult(f) and
          lbl = Label::promised() and
          rhs = f.getAReturn()
        )
        or
        exists(DataFlow::SourceNode src, DataFlow::InvokeNode invk |
          use(base, src) and invk = trackUseNode(src).getAnInvocation()
        |
          exists(int i |
            lbl = Label::parameter(i) and
            rhs = invk.getArgument(i)
          )
          or
          lbl = Label::receiver() and
          rhs = invk.(DataFlow::CallNode).getReceiver()
        )
        or
        exists(DataFlow::SourceNode src, DataFlow::PropWrite pw |
          use(base, src) and pw = trackUseNode(src).getAPropertyWrite() and rhs = pw.getRhs()
        |
          lbl = Label::memberFromRef(pw)
        )
      )
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of feature `nd`.
     */
    cached
    predicate rhs(TFeature nd, DataFlow::Node rhs) {
      exists(string m | nd = MkModuleExport(m) | exports(m, rhs))
      or
      nd = MkDef(rhs)
      or
      exists(CanonicalName n | nd = MkCanonicalNameDef(n) |
        rhs = n.(Namespace).getADefinition().flow() or
        rhs = n.(CanonicalFunctionName).getADefinition().flow()
      )
    }

    /**
     * Holds if `ref` is a use of a feature that should have an incoming edge from `base` labeled
     * `lbl` in the API graph.
     */
    cached
    predicate use(TFeature base, string lbl, DataFlow::Node ref) {
      hasSemantics(ref) and
      (
        base = MkRoot() and
        ref = lbl.(EntryPoint).getAUse()
        or
        exists(DataFlow::SourceNode src, DataFlow::SourceNode pred |
          use(base, src) and pred = trackUseNode(src)
        |
          // `module.exports` is special: it is a use of a def-node, not a use-node,
          // so we want to exclude it here
          (base instanceof TNonModuleDef or base instanceof TUse) and
          lbl = Label::memberFromRef(ref) and
          ref = pred.getAPropertyRead()
          or
          lbl = Label::instance() and
          ref = pred.getAnInstantiation()
          or
          lbl = Label::return() and
          ref = pred.getAnInvocation()
          or
          lbl = Label::promised() and
          PromiseFlow::loadStep(pred, ref, Promises::valueProp())
        )
        or
        exists(DataFlow::Node def, DataFlow::FunctionNode fn |
          rhs(base, def) and fn = trackDefNode(def)
        |
          exists(int i |
            lbl = Label::parameter(i) and
            ref = fn.getParameter(i)
          )
          or
          lbl = Label::receiver() and
          ref = fn.getReceiver()
        )
        or
        exists(DataFlow::Node def, DataFlow::ClassNode cls, int i |
          rhs(base, def) and cls = trackDefNode(def)
        |
          lbl = Label::parameter(i) and
          ref = cls.getConstructor().getParameter(i)
        )
        or
        exists(TypeName tn |
          base = MkCanonicalNameUse(tn) and
          lbl = Label::instance() and
          ref = getANodeWithType(tn)
        )
      )
    }

    /**
     * Holds if `ref` is a use of feature `nd`.
     */
    cached
    predicate use(TFeature nd, DataFlow::Node ref) {
      exists(string m, Module mod | nd = MkModuleDef(m) and mod = importableModule(m) |
        ref = DataFlow::ssaDefinitionNode(SSA::implicitInit(mod.(NodeModule).getModuleVariable()))
        or
        ref = DataFlow::parameterNode(mod.(AmdModule).getDefine().getModuleParameter())
      )
      or
      exists(string m, Module mod | nd = MkModuleExport(m) and mod = importableModule(m) |
        ref = DataFlow::ssaDefinitionNode(SSA::implicitInit(mod.(NodeModule).getExportsVariable()))
        or
        ref = DataFlow::parameterNode(mod.(AmdModule).getDefine().getExportsParameter())
        or
        exists(DataFlow::Node base | use(MkModuleDef(m), base) |
          ref = trackUseNode(base).getAPropertyRead("exports")
        )
      )
      or
      exists(string m |
        nd = MkModuleImport(m) and
        ref = DataFlow::moduleImport(m)
      )
      or
      exists(DataFlow::ClassNode cls | nd = MkClassInstance(cls) | ref = cls.getAReceiverNode())
      or
      nd = MkUse(ref)
      or
      exists(CanonicalName n | nd = MkCanonicalNameUse(n) | ref.asExpr() = n.getAnAccess())
    }

    /** Holds if module `m` exports `rhs`. */
    private predicate exports(string m, DataFlow::Node rhs) {
      exists(Module mod | mod = importableModule(m) |
        rhs = mod.(AmdModule).getDefine().getModuleExpr().flow()
        or
        exports(m, "default", rhs)
        or
        exists(ExportAssignDeclaration assgn | assgn.getTopLevel() = mod |
          rhs = assgn.getExpression().flow()
        )
        or
        rhs = mod.(Closure::ClosureModule).getExportsVariable().getAnAssignedExpr().flow()
      )
    }

    /** Holds if module `m` exports `rhs` under the name `prop`. */
    private predicate exports(string m, string prop, DataFlow::Node rhs) {
      exists(ExportDeclaration exp | exp.getEnclosingModule() = importableModule(m) |
        rhs = exp.getSourceNode(prop)
        or
        exists(Variable v |
          exp.exportsAs(v, prop) and
          rhs = v.getAnAssignedExpr().flow()
        )
      )
    }

    private DataFlow::SourceNode trackUseNode(DataFlow::SourceNode nd, DataFlow::TypeTracker t) {
      t.start() and
      use(_, nd) and
      result = nd
      or
      exists(DataFlow::TypeTracker t2 | result = trackUseNode(nd, t2).track(t2, t))
    }

    /**
     * Gets a node that is inter-procedurally reachable from `nd`, which is a use of some feature.
     */
    cached
    DataFlow::SourceNode trackUseNode(DataFlow::SourceNode nd) {
      result = trackUseNode(nd, DataFlow::TypeTracker::end())
    }

    private DataFlow::SourceNode trackDefNode(DataFlow::Node nd, DataFlow::TypeBackTracker t) {
      t.start() and
      rhs(_, nd) and
      result = nd.getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = trackDefNode(nd, t2).backtrack(t2, t))
    }

    /**
     * Gets a node that inter-procedurally flows into `nd`, which is a definition of some feature.
     */
    cached
    DataFlow::SourceNode trackDefNode(DataFlow::Node nd) {
      result = trackDefNode(nd, DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getANodeWithType(TypeName tn) {
      exists(string moduleName, string typeName |
        tn.hasQualifiedName(moduleName, typeName) and
        result.hasUnderlyingType(moduleName, typeName)
      )
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph that is labeled with `lbl`.
     */
    cached
    predicate edge(TFeature pred, string lbl, TFeature succ) {
      exists(string m |
        pred = MkRoot() and
        lbl = Label::mod(m)
      |
        succ = MkModuleDef(m)
        or
        succ = MkModuleUse(m)
      )
      or
      exists(string m |
        pred = MkModuleDef(m) and
        lbl = Label::member("exports") and
        succ = MkModuleExport(m)
        or
        pred = MkModuleUse(m) and
        lbl = Label::member("exports") and
        succ = MkModuleImport(m)
      )
      or
      exists(DataFlow::SourceNode ref |
        use(pred, lbl, ref) and
        succ = MkUse(ref)
      )
      or
      exists(DataFlow::Node rhs |
        rhs(pred, lbl, rhs) and
        succ = MkDef(rhs)
      )
      or
      exists(DataFlow::Node def |
        rhs(pred, def) and
        lbl = Label::instance() and
        succ = MkClassInstance(trackDefNode(def))
      )
      or
      exists(CanonicalName cn |
        pred = MkRoot() and
        lbl = Label::mod(cn.getExternalModuleName())
      |
        succ = MkCanonicalNameUse(cn) or
        succ = MkCanonicalNameDef(cn)
      )
      or
      exists(CanonicalName cn1, CanonicalName cn2 |
        cn2 = cn1.getAChild() and
        lbl = Label::member(cn2.getName())
      |
        (pred = MkCanonicalNameDef(cn1) or pred = MkCanonicalNameUse(cn1)) and
        (succ = MkCanonicalNameDef(cn2) or succ = MkCanonicalNameUse(cn2))
      )
      or
      exists(DataFlow::Node nd, DataFlow::FunctionNode f |
        pred = MkDef(nd) and
        f = trackDefNode(nd) and
        lbl = Label::return() and
        succ = MkAsyncFuncResult(f)
      )
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph.
     */
    private predicate edge(TFeature pred, TFeature succ) { edge(pred, _, succ) }

    /** Gets the shortest distance from the root to `nd` in the API graph. */
    cached
    int distanceFromRoot(TFeature nd) = shortestDistances(MkRoot/0, edge/2)(_, nd, result)
  }

  import Label as EdgeLabel
}

private module Label {
  /** Gets the edge label for the module `m`. */
  bindingset[m]
  bindingset[result]
  string mod(string m) { result = "module " + m }

  /** Gets the `member` edge label for member `m`. */
  bindingset[m]
  bindingset[result]
  string member(string m) { result = "member " + m }

  /** Gets the `member` edge label for the unknown member. */
  string unknownMember() { result = "member *" }

  /** Gets the `member` edge label for the given property reference. */
  string memberFromRef(DataFlow::PropRef pr) {
    exists(string pn | pn = pr.getPropertyName() |
      result = member(pn) and
      // only consider properties with alphanumeric(-ish) names, excluding special properties
      // and properties whose names look like they are meant to be internal
      pn.regexpMatch("(?!prototype$|__)[a-zA-Z_$][\\w\\-.$]*")
    )
    or
    not exists(pr.getPropertyName()) and
    result = unknownMember()
  }

  /** Gets the `instance` edge label. */
  string instance() { result = "instance" }

  /**
   * Gets the `parameter` edge label for the parameter `s`.
   *
   * This is an internal helper predicate; use `parameter` instead.
   */
  bindingset[result]
  bindingset[s]
  string parameterByStringIndex(string s) {
    result = "parameter " + s and
    s.toInt() >= 0
  }

  /** Gets the `parameter` edge label for the `i`th parameter. */
  bindingset[i]
  string parameter(int i) { result = parameterByStringIndex(i.toString()) }

  /** Gets the `parameter` edge label for the receiver. */
  string receiver() { result = "parameter -1" }

  /** Gets the `return` edge label. */
  string return() { result = "return" }

  /** Gets the `promised` edge label connecting a promise to its contained value. */
  string promised() { result = "promised" }
}

/**
 * A CommonJS `module` or `exports` variable, considered as a source node.
 */
private class AdditionalSourceNode extends DataFlow::SourceNode::Range {
  AdditionalSourceNode() {
    exists(NodeModule m, Variable v |
      v in [m.getModuleVariable(), m.getExportsVariable()] and
      this = DataFlow::ssaDefinitionNode(SSA::implicitInit(v))
    )
  }
}
