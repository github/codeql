/**
 * Provides an implementation of  _API graphs_, which are an abstract representation of the API
 * surface used and/or defined by a code base.
 *
 * The nodes of the API graph represent definitions and uses of API components. The edges are
 * directed and labeled; they specify how the components represented by nodes relate to each other.
 * For example, if one of the nodes represents a definition of an API function, then there
 * will be nodes corresponding to the function's parameters, which are connected to the function
 * node by edges labeled `parameter <i>`.
 */

import javascript

/**
 * Provides classes and predicates for working with APIs defined or used in a database.
 */
module API {
  /**
   * An abstract representation of a definition or use of an API component such as a function
   * exported by an npm package, a parameter of such a function, or its result.
   */
  class Node extends Impl::TApiNode {
    /**
     * Gets a data-flow node corresponding to a use of the API component represented by this node.
     *
     * For example, `require('fs').readFileSync` is a use of the function `readFileSync` from the
     * `fs` module, and `require('fs').readFileSync(file)` is a use of the return of that function.
     *
     * This includes indirect uses found via data flow, meaning that in
     * `f(obj.foo); function f(x) {};` both `obj.foo` and `x` are uses of the `foo` member from `obj`.
     *
     * As another example, in the assignment `exports.plusOne = (x) => x+1` the two references to
     * `x` are uses of the first parameter of `plusOne`.
     */
    DataFlow::Node getAUse() {
      exists(DataFlow::SourceNode src | Impl::use(this, src) |
        Impl::trackUseNode(src).flowsTo(result)
      )
    }

    /**
     * Gets an immediate use of the API component represented by this node.
     *
     * For example, `require('fs').readFileSync` is a an immediate use of the `readFileSync` member
     * from the `fs` module.
     *
     * Unlike `getAUse()`, this predicate only gets the immediate references, not the indirect uses
     * found via data flow. This means that in `const x = fs.readFile` only `fs.readFile` is a reference
     * to the `readFile` member of `fs`, neither `x` nor any node that `x` flows to is a reference to
     * this API component.
     */
    DataFlow::SourceNode getAnImmediateUse() { Impl::use(this, result) }

    /**
     * Gets a call to the function represented by this API component.
     */
    DataFlow::CallNode getACall() { result = getReturn().getAnImmediateUse() }

    /**
     * Gets a `new` call to the function represented by this API component.
     */
    DataFlow::NewNode getAnInstantiation() { result = getInstance().getAnImmediateUse() }

    /**
     * Gets an invocation (with our without `new`) to the function represented by this API component.
     */
    DataFlow::InvokeNode getAnInvocation() { result = getACall() or result = getAnInstantiation() }

    /**
     * Gets a data-flow node corresponding to the right-hand side of a definition of the API
     * component represented by this node.
     *
     * For example, in the assignment `exports.plusOne = (x) => x+1`, the function expression
     * `(x) => x+1` is the right-hand side of the  definition of the member `plusOne` of
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
     * Gets a node representing member `m` of this API component.
     *
     * For example, modules have an `exports` member representing their exports, and objects have
     * their properties as members.
     */
    bindingset[m]
    bindingset[result]
    Node getMember(string m) { result = getASuccessor(Label::member(m)) }

    /**
     * Gets a node representing a member of this API component where the name of the member is
     * not known statically.
     */
    Node getUnknownMember() { result = getASuccessor(Label::unknownMember()) }

    /**
     * Gets a node representing a member of this API component where the name of the member may
     * or may not be known statically.
     */
    Node getAMember() {
      result = getASuccessor(Label::member(_)) or
      result = getUnknownMember()
    }

    /**
     * Gets a node representing an instance of this API component, that is, an object whose
     * constructor is the function represented by this node.
     *
     * For example, if this node represents a use of some class `A`, then there might be a node
     * representing instances of `A`, typically corresponding to expressions `new A()` at the
     * source level.
     */
    Node getInstance() { result = getASuccessor(Label::instance()) }

    /**
     * Gets a node representing the `i`th parameter of the function represented by this node.
     */
    bindingset[i]
    Node getParameter(int i) { result = getASuccessor(Label::parameter(i)) }

    /**
     * Gets the number of parameters of the function represented by this node.
     */
    int getNumParameter() {
      result =
        max(string s | exists(getASuccessor(Label::parameterByStringIndex(s))) | s.toInt()) + 1
    }

    /**
     * Gets a node representing the last parameter of the function represented by this node.
     */
    Node getLastParameter() { result = getParameter(getNumParameter() - 1) }

    /**
     * Gets a node representing the receiver of the function represented by this node.
     */
    Node getReceiver() { result = getASuccessor(Label::receiver()) }

    /**
     * Gets a node representing a parameter or the receiver of the function represented by this
     * node.
     */
    Node getAParameter() {
      result = getASuccessor(Label::parameterByStringIndex(_)) or
      result = getReceiver()
    }

    /**
     * Gets a node representing the result of the function represented by this node.
     */
    Node getReturn() { result = getASuccessor(Label::return()) }

    /**
     * Gets a node representing the promised value wrapped in the `Promise` object represented by
     * this node.
     */
    Node getPromised() { result = getASuccessor(Label::promised()) }

    /**
     * Gets a string representation of the lexicographically least among all shortest access paths
     * from the root to this node.
     */
    string getPath() { result = min(string p | p = getAPath(Impl::distanceFromRoot(this)) | p) }

    /**
     * Gets a node such that there is an edge in the API graph between this node and the other
     * one, and that edge is labeled with `lbl`.
     */
    Node getASuccessor(string lbl) { Impl::edge(this, lbl, result) }

    /**
     * Gets a node such that there is an edge in the API graph between that other node and
     * this one, and that edge is labeled with `lbl`
     */
    Node getAPredecessor(string lbl) { this = result.getASuccessor(lbl) }

    /**
     * Gets a node such that there is an edge in the API graph between this node and the other
     * one.
     */
    Node getAPredecessor() { result = getAPredecessor(_) }

    /**
     * Gets a node such that there is an edge in the API graph between that other node and
     * this one.
     */
    Node getASuccessor() { result = getASuccessor(_) }

    /**
     * Holds if this node may take its value from `that` node.
     *
     * In other words, the value of a use of `that` may flow into the right-hand side of a
     * definition of this node.
     */
    predicate refersTo(Node that) { this.getARhs() = that.getAUse() }

    /**
     * Gets the data-flow node that gives rise to this node, if any.
     */
    DataFlow::Node getInducingNode() {
      this = Impl::MkClassInstance(result) or
      this = Impl::MkUse(result) or
      this = Impl::MkDef(result) or
      this = Impl::MkAsyncFuncResult(result)
    }

    /**
     * Holds if this node is located in file `path` between line `startline`, column `startcol`,
     * and line `endline`, column `endcol`.
     *
     * For nodes that do not have a meaningful location, `path` is the empty string and all other
     * parameters are zero.
     */
    predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol) {
      getInducingNode().hasLocationInfo(path, startline, startcol, endline, endcol)
      or
      not exists(getInducingNode()) and
      path = "" and
      startline = 0 and
      startcol = 0 and
      endline = 0 and
      endcol = 0
    }

    /**
     * Gets a textual representation of this node.
     */
    string toString() {
      none() // defined in subclasses
    }

    /**
     * Gets a path of the given `length` from the root to this node.
     */
    private string getAPath(int length) {
      this instanceof Impl::MkRoot and
      length = 0 and
      result = ""
      or
      exists(Node pred, string lbl, string predpath |
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

    /** Gets the shortest distance from the root to this node in the API graph. */
    int getDepth() { result = Impl::distanceFromRoot(this) }
  }

  /** The root node of an API graph. */
  class Root extends Node, Impl::MkRoot {
    override string toString() { result = "root" }
  }

  /** A node corresponding to a definition of an API component. */
  class Definition extends Node, Impl::TDef {
    override string toString() { result = "def " + getPath() }
  }

  /** A node corresponding to the use of an API component. */
  class Use extends Node, Impl::TUse {
    override string toString() { result = "use " + getPath() }
  }

  /** Gets the root node. */
  Root root() { any() }

  /** Gets a node corresponding to an import of module `m`. */
  Node moduleImport(string m) {
    result = Impl::MkModuleImport(m) or
    result = Impl::MkModuleImport(m).(Node).getMember("default")
  }

  /** Gets a node corresponding to an export of module `m`. */
  Node moduleExport(string m) { result = Impl::MkModuleDef(m).(Node).getMember("exports") }

  /** Provides helper predicates for accessing API-graph nodes. */
  module Node {
    /** Gets a node whose type has the given qualified name. */
    Node ofType(string moduleName, string exportedName) {
      exists(TypeName tn |
        tn.hasQualifiedName(moduleName, exportedName) and
        result = Impl::MkCanonicalNameUse(tn).(Node).getInstance()
      )
    }
  }

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
    abstract DataFlow::Node getARhs();
  }

  /**
   * Provides the actual implementation of API graphs, cached for performance.
   *
   * Ideally, we'd like nodes to correspond to (global) access paths, with edge labels
   * corresponding to extending the access path by one element. We also want to be able to map
   * nodes to their definitions and uses in the data-flow graph, and this should happen modulo
   * (inter-procedural) data flow.
   *
   * This, however, is not easy to implement, since access paths can have unbounded length
   * and we need some way of recognizing cycles to avoid non-termination. Unfortunately, expressing
   * a condition like "this node hasn't been involved in constructing any predecessor of
   * this node in the API graph" without negative recursion is tricky.
   *
   * So instead most nodes are directly associated with a data-flow node, representing
   * either a use or a definition of an API component. This ensures that we only have a finite
   * number of nodes. However, we can now have multiple nodes with the same access
   * path, which are essentially indistinguishable for a client of the API.
   *
   * On the other hand, a single node can have multiple access paths (which is, of
   * course, unavoidable). We pick as canonical the alphabetically least access path with
   * shortest length.
   */
  cached
  private module Impl {
    cached
    newtype TApiNode =
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
        or
        m = any(CanonicalName n | isDefined(n)).getExternalModuleName()
      } or
      MkModuleImport(string m) {
        imports(_, m)
        or
        m = any(CanonicalName n | isUsed(n)).getExternalModuleName()
      } or
      MkClassInstance(DataFlow::ClassNode cls) { cls = trackDefNode(_) and hasSemantics(cls) } or
      MkAsyncFuncResult(DataFlow::FunctionNode f) {
        f = trackDefNode(_) and f.getFunction().isAsync() and hasSemantics(f)
      } or
      MkDef(DataFlow::Node nd) { rhs(_, _, nd) } or
      MkUse(DataFlow::Node nd) { use(_, _, nd) } or
      /**
       * A TypeScript canonical name that is defined somewhere, and that isn't a module root.
       * (Module roots are represented by `MkModuleExport` nodes instead.)
       *
       * For most purposes, you probably want to use the `mkCanonicalNameDef` predicate instead of
       * this constructor.
       */
      MkCanonicalNameDef(CanonicalName n) {
        not n.isRoot() and
        isDefined(n)
      } or
      /**
       * A TypeScript canonical name that is used somewhere, and that isn't a module root.
       * (Module roots are represented by `MkModuleImport` nodes instead.)
       *
       * For most purposes, you probably want to use the `mkCanonicalNameUse` predicate instead of
       * this constructor.
       */
      MkCanonicalNameUse(CanonicalName n) {
        not n.isRoot() and
        isUsed(n)
      }

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
      exists(n.(Namespace).getAnAccess())
    }

    private predicate isDefined(CanonicalName n) {
      exists(ASTNode def |
        def = n.(TypeName).getADefinition() or
        def = n.(Namespace).getADefinition()
      |
        not def.isAmbient()
      )
    }

    /** An API-graph node representing definitions of the canonical name `cn`. */
    private TApiNode mkCanonicalNameDef(CanonicalName cn) {
      if cn.isModuleRoot()
      then result = MkModuleExport(cn.getExternalModuleName())
      else result = MkCanonicalNameDef(cn)
    }

    /** An API-graph node representing uses of the canonical name `cn`. */
    private TApiNode mkCanonicalNameUse(CanonicalName cn) {
      if cn.isModuleRoot()
      then result = MkModuleImport(cn.getExternalModuleName())
      else result = MkCanonicalNameUse(cn)
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of a node that should have an
     * incoming edge from `base` labeled `lbl` in the API graph.
     */
    cached
    predicate rhs(TApiNode base, string lbl, DataFlow::Node rhs) {
      hasSemantics(rhs) and
      (
        base = MkRoot() and
        rhs = lbl.(EntryPoint).getARhs()
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
          // from `x` to a definition of `x.prop`
          exists(DataFlow::PropWrite pw | pw = pred.getAPropertyWrite() |
            lbl = Label::memberFromRef(pw) and
            rhs = pw.getRhs()
          )
          or
          // special case: from `require('m')` to an export of `prop` in `m`
          exists(Import imp, Module m, string prop |
            pred = imp.getImportedModuleNode() and
            m = imp.getImportedModule() and
            lbl = Label::member(prop) and
            rhs = m.getAnExportedValue(prop)
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
        exists(int i |
          lbl = Label::parameter(i) and
          argumentPassing(base, i, rhs)
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
     * Holds if `arg` is passed as the `i`th argument to a use of `base`, either by means of a
     * full invocation, or in a partial function application.
     *
     * The receiver is considered to be argument -1.
     */
    private predicate argumentPassing(TApiNode base, int i, DataFlow::Node arg) {
      exists(DataFlow::SourceNode use, DataFlow::SourceNode pred |
        use(base, use) and pred = trackUseNode(use)
      |
        arg = pred.getAnInvocation().getArgument(i)
        or
        arg = pred.getACall().getReceiver() and
        i = -1
        or
        exists(DataFlow::PartialInvokeNode pin, DataFlow::Node callback | pred.flowsTo(callback) |
          pin.isPartialArgument(callback, arg, i)
          or
          arg = pin.getBoundReceiver(callback) and
          i = -1
        )
      )
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of node `nd`.
     */
    cached
    predicate rhs(TApiNode nd, DataFlow::Node rhs) {
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
     * Holds if `ref` is a use of a node that should have an incoming edge from `base` labeled
     * `lbl` in the API graph.
     */
    cached
    predicate use(TApiNode base, string lbl, DataFlow::Node ref) {
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
     * Holds if `ref` is a use of node `nd`.
     */
    cached
    predicate use(TApiNode nd, DataFlow::Node ref) {
      exists(string m, Module mod | nd = MkModuleDef(m) and mod = importableModule(m) |
        ref.(ModuleAsSourceNode).getModule() = mod
      )
      or
      exists(string m, Module mod | nd = MkModuleExport(m) and mod = importableModule(m) |
        ref.(ExportsAsSourceNode).getModule() = mod
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
      exists(DataFlow::ClassNode cls | nd = MkClassInstance(cls) |
        ref = cls.getAReceiverNode()
        or
        ref = cls.(DataFlow::ClassNode::FunctionStyleClass).getAPrototypeReference()
      )
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
     * Gets a node that is inter-procedurally reachable from `nd`, which is a use of some node.
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
      // additional backwards step from `require('m')` to `exports` or `module.exports` in m
      exists(Import imp | imp.getImportedModuleNode() = trackDefNode(nd, t.continue()) |
        result.(ExportsAsSourceNode).getModule() = imp.getImportedModule()
        or
        exists(ModuleAsSourceNode mod |
          mod.getModule() = imp.getImportedModule() and
          result = mod.(DataFlow::SourceNode).getAPropertyRead("exports")
        )
      )
      or
      exists(DataFlow::TypeBackTracker t2 | result = trackDefNode(nd, t2).backtrack(t2, t))
    }

    /**
     * Gets a node that inter-procedurally flows into `nd`, which is a definition of some node.
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
    predicate edge(TApiNode pred, string lbl, TApiNode succ) {
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
      exists(CanonicalName cn1, string n, CanonicalName cn2 |
        pred in [mkCanonicalNameDef(cn1), mkCanonicalNameUse(cn1)] and
        cn2 = cn1.getChild(n) and
        lbl = Label::member(n) and
        succ in [mkCanonicalNameDef(cn2), mkCanonicalNameUse(cn2)]
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
    private predicate edge(TApiNode pred, TApiNode succ) { edge(pred, _, succ) }

    /** Gets the shortest distance from the root to `nd` in the API graph. */
    cached
    int distanceFromRoot(TApiNode nd) = shortestDistances(MkRoot/0, edge/2)(_, nd, result)
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
    s.toInt() >= -1
  }

  /**
   * Gets the `parameter` edge label for the `i`th parameter.
   *
   * The receiver is considered to be parameter -1.
   */
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
 * A CommonJS/AMD `module` variable, considered as a source node.
 */
private class ModuleAsSourceNode extends DataFlow::SourceNode::Range {
  Module m;

  ModuleAsSourceNode() {
    this = DataFlow::ssaDefinitionNode(SSA::implicitInit(m.(NodeModule).getModuleVariable()))
    or
    this = DataFlow::parameterNode(m.(AmdModule).getDefine().getModuleParameter())
  }

  Module getModule() { result = m }
}

/**
 * A CommonJS/AMD `exports` variable, considered as a source node.
 */
private class ExportsAsSourceNode extends DataFlow::SourceNode::Range {
  Module m;

  ExportsAsSourceNode() {
    this = DataFlow::ssaDefinitionNode(SSA::implicitInit(m.(NodeModule).getExportsVariable()))
    or
    this = DataFlow::parameterNode(m.(AmdModule).getDefine().getExportsParameter())
  }

  Module getModule() { result = m }
}
