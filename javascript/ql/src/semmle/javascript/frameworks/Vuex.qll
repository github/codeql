/**
 * Provides classes and predicates for working with the `vuex` library.
 */

private import javascript
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps

/** A minimal adapter for the `vue` model based on API nodes. */
private module VueAPI {
  /** A value exported from a `.vue` file. */
  private class VueExportEntryPoint extends API::EntryPoint {
    VueExportEntryPoint() { this = "VueExportEntryPoint" }

    override DataFlow::SourceNode getAUse() { none() }

    override DataFlow::Node getARhs() {
      exists(Module mod |
        mod.getFile() instanceof Vue::VueFile and
        result = mod.getAnExportedValue("default")
      )
    }
  }

  /**
   * An API node representing the object passed to the Vue constructor `new Vue({...})`
   * or equivalent.
   */
  class VueConfigObject extends API::Node {
    VueConfigObject() { this.getARhs() = any(Vue::Instance i).getOwnOptionsObject() }

    /** Gets an API node representing `this` in the Vue component. */
    API::Node getAnInstanceRef() {
      result = getAMember().getReceiver()
      or
      result = getAMember().getAMember().getReceiver()
    }
  }
}

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
    result = any(VueAPI::VueConfigObject v).getAnInstanceRef().getMember("$store") and
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
          namespace = call.getParameter(0).getAValueReachingRhs().getStringValue() + "/" and
          this = call.getReturn().getMember(helperName).getACall()
        )
      )
    }

    /** Gets the name of the `vuex` method being invoked, such as `mapGetters`. */
    string getHelperName() { result = helperName }

    /** Gets the namespace prefix to use, or an empty string if no namespace was given. */
    pragma[noinline]
    string getNamespace() {
      getNumArgument() = 2 and
      result = appendToNamespace(namespace, getParameter(0).getAValueReachingRhs().getStringValue())
      or
      getNumArgument() = 1 and
      result = namespace
    }

    /**
     * Holds if `this.localName` is mapped to `storeName` in the Vuex store.
     */
    predicate hasMapping(string localName, string storeName) {
      // mapGetters('foo')
      getLastParameter().getAValueReachingRhs().getStringValue() = localName and
      storeName = getNamespace() + localName
      or
      // mapGetters(['foo', 'bar'])
      getLastParameter().getUnknownMember().getAValueReachingRhs().getStringValue() = localName and
      storeName = getNamespace() + localName
      or
      // mapGetters({foo: 'bar'})
      storeName =
        getNamespace() +
          getLastParameter().getMember(localName).getAValueReachingRhs().getStringValue() and
      localName != "*" // ignore special API graph member named "*"
    }

    /** Gets the Vue component in which the generated functions are installed. */
    VueAPI::VueConfigObject getVueConfigObject() {
      exists(DataFlow::ObjectLiteralNode obj |
        obj.getASpreadProperty() = getReturn().getAUse() and
        result.getAMember().getARhs() = obj
      )
      or
      result.getAMember().getARhs() = this
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
      result = call.getVueConfigObject().getAnInstanceRef().getMember(localName) and
      localName != "*"
    )
  }

  // -----------------------------------------------------------------------------
  // Flow from getter method return value to getter call
  // -----------------------------------------------------------------------------
  /** Gets a value that is returned by a getter registered with the given name. */
  private DataFlow::Node getterPred(string name) {
    exists(string prefix, string prop |
      result = storeConfigObject(prefix).getMember("getters").getMember(prop).getReturn().getARhs() and
      name = prefix + prop
    )
  }

  /** Gets a property access that may receive the produced by a getter of the given name. */
  private DataFlow::Node getterSucc(string name) {
    exists(string prefix, string prop |
      result = storeRef(prefix).getMember("getters").getMember(prop).getAnImmediateUse() and
      prop != "*" and
      name = prefix + prop
    )
    or
    result = getAMappedAccess("mapGetters", name).getAnImmediateUse()
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
      name = prefix + commitCall.getParameter(0).getAValueReachingRhs().getStringValue() and
      result = commitCall.getArgument(1)
      or
      // commit({type: 'name', ...<payload>...})
      name =
        prefix +
          commitCall.getParameter(0).getMember("type").getAValueReachingRhs().getStringValue() and
      result = commitCall.getArgument(0)
    )
    or
    // this.name(payload)
    // methods: {...mapMutations(['name'])} }
    result = getAMappedAccess(getMapHelperForCommitKind(kind), name).getParameter(0).getARhs()
  }

  /** Gets a node that refers the payload of a comitted mutation with the given `name.` */
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
            .getAnImmediateUse() and
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
      path = appendToNamespace(base, prop)
    )
  }

  /** Gets a value that flows into the given access path of the state. */
  DataFlow::Node stateMutationPred(string path) {
    result = stateRefByAccessPath(path).getARhs()
    or
    exists(ExtendCall call, string base, string prop |
      call.getDestinationOperand() = stateRefByAccessPath(base).getAUse() and
      result = call.getASourceOperand().getALocalSource().getAPropertyWrite(prop).getRhs() and
      path = appendToNamespace(base, prop)
    )
  }

  /** Gets a value that refers to the given access path of the state. */
  DataFlow::Node stateMutationSucc(string path) {
    result = stateRefByAccessPath(path).getAnImmediateUse()
  }

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
  DataFlow::Node mapStateHelperPred(VueAPI::VueConfigObject vue, string name) {
    exists(MapHelperCall call |
      call.getHelperName() = "mapState" and
      vue = call.getVueConfigObject() and
      result = call.getLastParameter().getMember(name).getReturn().getARhs()
    )
  }

  /**
   * Holds if `pred -> succ` is a step from a callback passed to `mapState` to a
   * corresponding property access.
   */
  predicate mapStateHelperStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(VueAPI::VueConfigObject vue, string name |
      pred = mapStateHelperPred(vue, name) and
      succ = pragma[only_bind_out](vue).getAnInstanceRef().getMember(name).getAnImmediateUse()
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
    private PackageJSON getPackageJson(Container f) {
      f = result.getFile().getParentContainer()
      or
      not exists(f.getFile("package.json")) and
      result = getPackageJson(f.getParentContainer())
    }

    private predicate packageDependsOn(PackageJSON importer, PackageJSON dependency) {
      importer.getADependenciesObject("").getADependency(dependency.getPackageName(), _)
    }

    /** A package that can be considered an entry point for a Vuex app. */
    private PackageJSON entryPointPackage() {
      result = getPackageJson(storeRef().getAnImmediateUse().getFile())
      or
      // Any package that imports a store-creating package is considered a potential entry point.
      packageDependsOn(result, entryPointPackage())
    }

    pragma[nomagic]
    private predicate arePackagesInSameVuexApp(PackageJSON a, PackageJSON b) {
      exists(PackageJSON entry |
        entry = entryPointPackage() and
        packageDependsOn*(entry, a) and
        packageDependsOn*(entry, b)
      )
    }

    /** Holds if the two files are considered to be part of the same Vuex app. */
    pragma[inline]
    predicate areFilesInSameVuexApp(File a, File b) {
      not exists(PackageJSON pkg)
      or
      arePackagesInSameVuexApp(getPackageJson(a), getPackageJson(b))
    }
  }
}
