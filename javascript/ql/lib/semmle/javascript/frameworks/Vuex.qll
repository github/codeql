/**
 * Provides classes and predicates for working with the `vuex` library.
 */

private import javascript
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps

/**
 * Provides classes and predicates for working with the `vuex` library.
 */
module Vuex {
  /** Gets a reference to the Vuex package. */
  API::Node vuex() { result = API::moduleImport("vuex") }

  /**
   * Append a property onto a namespace, while disallowing unbounded growth of strings.
   *
   * The namespace is encoded as a sequence of property names each terminated by a `/`,
   * (to align with how namespaces are represented as strings in Vuex).
   */
  bindingset[base, prop]
  private string appendToNamespace(string base, string prop) {
    result = base + prop + "/" and
    // To avoid constructing infinitely long access paths,
    // allow at most two occurrences of a given property name in the path
    // (one in the base, plus the one we're appending now).
    count(base.indexOf("/" + prop + "/")) <= 1
  }

  /** Gets a reference to a Vuex store in the given `namespace`. */
  API::Node storeRef(string namespace) {
    result = vuex().getMember("Store").getInstance() and namespace = ""
    or
    result = any(Vue::Component v).getInstance().getMember("$store") and
    namespace = ""
    or
    result =
      storeConfigObject(namespace).getMember(["actions", "plugins"]).getAMember().getParameter(0)
  }

  /** Gets a reference to a Vuex store. */
  API::Node storeRef() { result = storeRef(_) }

  /**
   * Gets the options object passed to a Vuex store creation or one of its modules,
   * with `namespace` bound to the namespace of the store.
   */
  API::Node storeConfigObject(string namespace) {
    result = vuex().getMember("Store").getParameter(0) and namespace = ""
    or
    exists(string prev, string child |
      result = storeConfigObject(prev).getMember("modules").getMember(child) and
      namespace = appendToNamespace(prev, child)
    )
  }

  /**
   * Gets the options object passed to a Vuex store creation or one of its modules.
   */
  API::Node storeConfigObject() { result = storeConfigObject(_) }

  /**
   * A call to `mapActions` or similar, which is used to generate helper functions to
   * mix into parts of a Vue component.
   */
  private class MapHelperCall extends API::CallNode {
    string helperName;
    string namespace;

    MapHelperCall() {
      helperName = ["mapActions", "mapGetters", "mapMutations", "mapState"] and
      (
        this = vuex().getMember(helperName).getACall() and
        namespace = ""
        or
        exists(API::CallNode call |
          call = vuex().getMember("createNamespacedHelpers").getACall() and
          namespace = call.getParameter(0).getAValueReachingSink().getStringValue() + "/" and
          this = call.getReturn().getMember(helperName).getACall()
        )
      )
    }

    /** Gets the name of the `vuex` method being invoked, such as `mapGetters`. */
    string getHelperName() { result = helperName }

    /** Gets the namespace prefix to use, or an empty string if no namespace was given. */
    pragma[noinline]
    string getNamespace() {
      this.getNumArgument() = 2 and
      result =
        appendToNamespace(namespace, this.getParameter(0).getAValueReachingSink().getStringValue())
      or
      this.getNumArgument() = 1 and
      result = namespace
    }

    /**
     * Holds if `this.localName` is mapped to `storeName` in the Vuex store.
     */
    predicate hasMapping(string localName, string storeName) {
      // mapGetters('foo')
      this.getLastParameter().getAValueReachingSink().getStringValue() = localName and
      storeName = this.getNamespace() + localName
      or
      // mapGetters(['foo', 'bar'])
      this.getLastParameter().getUnknownMember().getAValueReachingSink().getStringValue() =
        localName and
      storeName = this.getNamespace() + localName
      or
      // mapGetters({foo: 'bar'})
      storeName =
        this.getNamespace() +
          this.getLastParameter().getMember(localName).getAValueReachingSink().getStringValue() and
      localName != "*" // ignore special API graph member named "*"
    }

    /** Gets the Vue component in which the generated functions are installed. */
    Vue::Component getVueComponent() {
      exists(DataFlow::ObjectLiteralNode obj |
        obj.getASpreadProperty() = this.getReturn().getAValueReachableFromSource() and
        result.getOwnOptions().getAMember().asSink() = obj
      )
      or
      result.getOwnOptions().getAMember().asSink() = this
    }
  }

  /**
   * Gets an API node that refers to a property of a Vue component instance,
   * which has been bound by a helper of kind `helperName` to something named `storeName`.
   *
   * For example, `mapGetters({foo: 'bar})` will cause `this.foo` in the affected Vue component
   * to be returned by `getAMappedAccess("mapGetters", "bar")`.
   */
  API::Node getAMappedAccess(string helperName, string storeName) {
    exists(MapHelperCall call, string localName |
      call.getHelperName() = helperName and
      call.hasMapping(localName, storeName) and
      result = call.getVueComponent().getInstance().getMember(localName) and
      localName != "*"
    )
  }

  // -----------------------------------------------------------------------------
  // Flow from getter method return value to getter call
  // -----------------------------------------------------------------------------
  /** Gets a value that is returned by a getter registered with the given name. */
  private DataFlow::Node getterPred(string name) {
    exists(string prefix, string prop |
      result = storeConfigObject(prefix).getMember("getters").getMember(prop).getReturn().asSink() and
      name = prefix + prop
    )
  }

  /** Gets a property access that may receive the produced by a getter of the given name. */
  private DataFlow::Node getterSucc(string name) {
    exists(string prefix, string prop |
      result = storeRef(prefix).getMember("getters").getMember(prop).asSource() and
      prop != "*" and
      name = prefix + prop
    )
    or
    result = getAMappedAccess("mapGetters", name).asSource()
  }

  /** Holds if `pred -> succ` is a step from a getter function to a relevant property access. */
  private predicate getterStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(string name |
      pred = getterPred(name) and
      succ = getterSucc(name)
    )
  }

  // -----------------------------------------------------------------------------
  // --- Flow from commit() to mutation method, or dispatch() to action method ---
  // -----------------------------------------------------------------------------
  /**
   * Gets a node that refers to the `commit` or `dispatch` function of the store.
   *
   * For our purposes, the (`commit`, `mutations`, `mapMutations`) properties
   * behave in nearly the same way as (`dispatch`, `actions`, `mapActions`) so we
   * model them together, with `kind` being either `commit` or `dispatch`.
   */
  API::Node commitLikeFunctionRef(string kind, string prefix) {
    kind = ["commit", "dispatch"] and
    result = storeRef(prefix).getMember(kind)
    or
    kind = "commit" and
    exists(MapHelperCall mapMutations |
      mapMutations.getHelperName() = "mapMutations" and
      result = mapMutations.getLastParameter().getAMember().getParameter(0) and
      prefix = mapMutations.getNamespace()
    )
  }

  /** Gets the map helper that injects functions for committing or dispatching, respectively. */
  private string getMapHelperForCommitKind(string kind) {
    kind = "commit" and result = "mapMutations"
    or
    kind = "dispatch" and result = "mapActions"
  }

  /** Gets the property of the store containing methods handling committed or dispatched values, respectively. */
  private string getStorePropForCommitKind(string kind) {
    kind = "commit" and result = "mutations"
    or
    kind = "dispatch" and result = "actions"
  }

  /** Gets a node that becomes the payload for a commit/dispatch with the given `name.` */
  private DataFlow::Node committedPayloadPred(string kind, string name) {
    exists(API::CallNode commitCall, string prefix |
      commitCall = commitLikeFunctionRef(kind, prefix).getACall()
    |
      // commit('name', payload)
      name = prefix + commitCall.getParameter(0).getAValueReachingSink().getStringValue() and
      result = commitCall.getArgument(1)
      or
      // commit({type: 'name', ...<payload>...})
      name =
        prefix +
          commitCall.getParameter(0).getMember("type").getAValueReachingSink().getStringValue() and
      result = commitCall.getArgument(0)
    )
    or
    // this.name(payload)
    // methods: {...mapMutations(['name'])} }
    result = getAMappedAccess(getMapHelperForCommitKind(kind), name).getParameter(0).asSink()
  }

  /** Gets a node that refers the payload of a committed mutation with the given `name.` */
  private DataFlow::Node committedPayloadSucc(string kind, string name) {
    // mutations: {
    //   name: (state, payload) => { ... }
    // }
    exists(string prefix, string prop |
      result =
        storeConfigObject(prefix)
            .getMember(getStorePropForCommitKind(kind))
            .getMember(prop)
            .getParameter(1)
            .asSource() and
      prop != "*" and
      name = prefix + prop
    )
  }

  /** Holds if `pred -> succ` is a step from a commit/dispatch call to a mutation/action handler. */
  private predicate committedPayloadStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(string kind, string name |
      pred = committedPayloadPred(kind, name) and
      succ = committedPayloadSucc(kind, name)
    )
  }

  // --------------------------------------------------------
  // --- Flow from state assignments to state accesses ------
  // --------------------------------------------------------
  /**
   * Gets an API node that refers to the given access path relative to the root state,
   * where the access path `path` is encoded as a namespace string (see `appendToNamespace`).
   */
  API::Node stateRefByAccessPath(string path) {
    result = storeRef(path).getMember("state")
    or
    result = storeRef().getMember("rootState") and
    path = ""
    or
    result =
      storeConfigObject(path).getMember(["getters", "mutations"]).getAMember().getParameter(0)
    or
    // Getters receive the root state in the third argument
    result = storeConfigObject().getMember("getters").getAMember().getParameter(2) and
    path = ""
    or
    result = storeConfigObject(path).getMember("state")
    or
    exists(string name |
      result = getAMappedAccess("mapState", name) and
      path = name + "/"
    )
    or
    exists(MapHelperCall call |
      call.getHelperName() = "mapState" and
      result = call.getLastParameter().getAMember().getParameter(0) and
      path = call.getNamespace()
    )
    or
    exists(string base, string prop |
      result = stateRefByAccessPath(base).getMember(prop) and
      path = appendToNamespace(base, prop) and
      path.length() < 100
    )
  }

  /** Gets a value that flows into the given access path of the state. */
  DataFlow::Node stateMutationPred(string path) {
    result = stateRefByAccessPath(path).asSink()
    or
    exists(ExtendCall call, string base, string prop |
      call.getDestinationOperand() = stateRefByAccessPath(base).getAValueReachableFromSource() and
      result = call.getASourceOperand().getALocalSource().getAPropertyWrite(prop).getRhs() and
      path = appendToNamespace(base, prop)
    )
  }

  /** Gets a value that refers to the given access path of the state. */
  DataFlow::Node stateMutationSucc(string path) { result = stateRefByAccessPath(path).asSource() }

  /** Holds if `pred -> succ` is a step from state mutation to state access. */
  predicate stateMutationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(string path |
      pred = stateMutationPred(path) and
      succ = stateMutationSucc(path)
    )
  }

  // -------------------------------------------
  // --- Flow from local mapState helpers ------
  // -------------------------------------------
  /**
   * Gets the `x` in `mapState({name: () => x})`.
   */
  DataFlow::Node mapStateHelperPred(Vue::Component component, string name) {
    exists(MapHelperCall call |
      call.getHelperName() = "mapState" and
      component = call.getVueComponent() and
      result = call.getLastParameter().getMember(name).getReturn().asSink()
    )
  }

  /**
   * Holds if `pred -> succ` is a step from a callback passed to `mapState` to a
   * corresponding property access.
   */
  predicate mapStateHelperStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Vue::Component component, string name |
      pred = mapStateHelperPred(component, name) and
      succ = pragma[only_bind_out](component).getInstance().getMember(name).asSource()
    )
  }

  /**
   * A data flow step induced by the Vuex model.
   */
  private class VuexStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      (
        getterStep(pred, succ)
        or
        committedPayloadStep(pred, succ)
        or
        stateMutationStep(pred, succ)
        or
        mapStateHelperStep(pred, succ)
      ) and
      ProgramSlicing::areFilesInSameVuexApp(pragma[only_bind_out](pred).getFile(),
        pragma[only_bind_out](succ).getFile())
    }
  }

  /**
   * To avoid mixing up the state between independent Vuex apps that live in a monorepo,
   * we do a heuristic program slicing based on `package.json` files. For most projects this has no effect.
   */
  private module ProgramSlicing {
    /** Gets the innermost `package.json` file in a directory containing the given file. */
    private PackageJson getPackageJson(Container f) {
      f = result.getFile().getParentContainer()
      or
      not exists(f.getFile("package.json")) and
      result = getPackageJson(f.getParentContainer())
    }

    private predicate packageDependsOn(PackageJson importer, PackageJson dependency) {
      importer.getADependenciesObject("").getADependency(dependency.getPackageName(), _)
    }

    /** Gets a package that can be considered an entry point for a Vuex app. */
    private PackageJson entryPointPackage() {
      result = getPackageJson(storeRef().asSource().getFile())
      or
      // Any package that imports a store-creating package is considered a potential entry point.
      packageDependsOn(result, entryPointPackage())
    }

    pragma[nomagic]
    private predicate arePackagesInSameVuexApp(PackageJson a, PackageJson b) {
      exists(PackageJson entry |
        entry = entryPointPackage() and
        packageDependsOn*(entry, a) and
        packageDependsOn*(entry, b)
      )
    }

    /** Holds if the two files are considered to be part of the same Vuex app. */
    pragma[inline]
    predicate areFilesInSameVuexApp(File a, File b) {
      not exists(PackageJson pkg)
      or
      arePackagesInSameVuexApp(getPackageJson(a), getPackageJson(b))
    }
  }
}
