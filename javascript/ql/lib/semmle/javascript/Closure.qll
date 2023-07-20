/**
 * Provides classes for working with the Closure-Library module system.
 */

import javascript

module Closure {
  /**
   * A reference to a Closure namespace.
   */
  class ClosureNamespaceRef extends DataFlow::Node instanceof ClosureNamespaceRef::Range {
    /**
     * Gets the namespace being referenced.
     */
    string getClosureNamespace() { result = super.getClosureNamespace() }
  }

  module ClosureNamespaceRef {
    /**
     * A reference to a Closure namespace.
     *
     * Can be subclassed to classify additional nodes as namespace references.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the namespace being referenced.
       */
      abstract string getClosureNamespace();
    }
  }

  /**
   * A data flow node that returns the value of a closure namespace.
   */
  class ClosureNamespaceAccess extends ClosureNamespaceRef instanceof ClosureNamespaceAccess::Range {
  }

  module ClosureNamespaceAccess {
    /**
     * A data flow node that returns the value of a closure namespace.
     *
     * Can be subclassed to classify additional nodes as namespace accesses.
     */
    abstract class Range extends ClosureNamespaceRef::Range { }
  }

  /**
   * A call to a method on the `goog.` namespace, as a closure reference.
   */
  abstract private class DefaultNamespaceRef extends DataFlow::MethodCallNode,
    ClosureNamespaceRef::Range
  {
    DefaultNamespaceRef() { this = DataFlow::globalVarRef("goog").getAMethodCall() }

    override string getClosureNamespace() { result = this.getArgument(0).getStringValue() }
  }

  /**
   * Holds if `node` is the data flow node corresponding to the expression in
   * a top-level expression statement.
   */
  private predicate isTopLevelExpr(DataFlow::Node node) {
    any(TopLevel tl).getAChildStmt().(ExprStmt).getExpr().flow() = node
  }

  /**
   * A top-level call to `goog.provide`.
   */
  private class DefaultClosureProvideCall extends DefaultNamespaceRef {
    DefaultClosureProvideCall() {
      this.getMethodName() = "provide" and
      isTopLevelExpr(this)
    }
  }

  /**
   * A top-level call to `goog.provide`.
   */
  class ClosureProvideCall extends ClosureNamespaceRef, DataFlow::MethodCallNode instanceof DefaultClosureProvideCall
  { }

  /**
   * A call to `goog.require`.
   */
  private class DefaultClosureRequireCall extends DefaultNamespaceRef, ClosureNamespaceAccess::Range
  {
    DefaultClosureRequireCall() { this.getMethodName() = "require" }
  }

  /**
   * A call to `goog.require`.
   */
  class ClosureRequireCall extends ClosureNamespaceAccess, DataFlow::MethodCallNode instanceof DefaultClosureRequireCall
  { }

  /**
   * A top-level call to `goog.module` or `goog.declareModuleId`.
   */
  private class DefaultClosureModuleDeclaration extends DefaultNamespaceRef {
    DefaultClosureModuleDeclaration() {
      (this.getMethodName() = "module" or this.getMethodName() = "declareModuleId") and
      isTopLevelExpr(this)
    }
  }

  /**
   * A top-level call to `goog.module` or `goog.declareModuleId`.
   */
  class ClosureModuleDeclaration extends ClosureNamespaceRef, DataFlow::MethodCallNode instanceof DefaultClosureModuleDeclaration
  { }

  private GlobalVariable googVariable() { variables(result, "goog", any(GlobalScope sc)) }

  pragma[nomagic]
  private MethodCallExpr googModuleDeclExpr() {
    result.getReceiver() = googVariable().getAnAccess() and
    result.getMethodName() = ["module", "declareModuleId"]
  }

  pragma[nomagic]
  private MethodCallExpr googModuleDeclExprInContainer(StmtContainer container) {
    result = googModuleDeclExpr() and
    container = result.getContainer()
  }

  pragma[noinline]
  private ClosureRequireCall getARequireInTopLevel(ClosureModule m) { result.getTopLevel() = m }

  /**
   * A module using the Closure module system, declared using `goog.module()` or `goog.declareModuleId()`.
   */
  class ClosureModule extends Module {
    ClosureModule() { exists(googModuleDeclExprInContainer(this)) }

    /**
     * Gets the call to `goog.module` or `goog.declareModuleId` in this module.
     */
    ClosureModuleDeclaration getModuleDeclaration() { result.getTopLevel() = this }

    /**
     * Gets the namespace of this module.
     */
    string getClosureNamespace() { result = this.getModuleDeclaration().getClosureNamespace() }

    override Module getAnImportedModule() {
      result.(ClosureModule).getClosureNamespace() =
        getARequireInTopLevel(this).getClosureNamespace()
    }

    /**
     * Gets the top-level `exports` variable in this module, if this module is defined by
     * a `good.module` call.
     *
     * This variable denotes the object exported from this module.
     *
     * Has no result for ES6 modules using `goog.declareModuleId`.
     */
    Variable getExportsVariable() {
      this.getModuleDeclaration().getMethodName() = "module" and
      result = this.getScope().getVariable("exports")
    }

    override DataFlow::Node getAnExportedValue(string name) {
      exists(DataFlow::PropWrite write, Expr base |
        result = write.getRhs() and
        write.writes(base.flow(), name, _) and
        (
          base = this.getExportsVariable().getAReference()
          or
          base = this.getExportsVariable().getAnAssignedExpr()
        )
      )
    }

    override DataFlow::Node getABulkExportedNode() {
      result = this.getExportsVariable().getAnAssignedExpr().flow()
    }
  }

  /**
   * A global Closure script, that is, a toplevel that is executed in the global scope and
   * contains a toplevel call to `goog.provide` or `goog.require`.
   */
  class ClosureScript extends TopLevel {
    ClosureScript() {
      not this instanceof ClosureModule and
      (
        any(ClosureProvideCall provide).getTopLevel() = this
        or
        any(ClosureRequireCall require).getTopLevel() = this
      )
    }

    /** Gets the identifier of a namespace required by this module. */
    string getARequiredNamespace() {
      exists(ClosureRequireCall require |
        require.getTopLevel() = this and
        result = require.getClosureNamespace()
      )
    }

    /** Gets the identifer of a namespace provided by this module. */
    string getAProvidedNamespace() {
      exists(ClosureProvideCall require |
        require.getTopLevel() = this and
        result = require.getClosureNamespace()
      )
    }
  }

  /**
   * Holds if `name` is a closure namespace, including proper namespace prefixes.
   */
  pragma[noinline]
  predicate isClosureNamespace(string name) {
    exists(string namespace | namespace = any(ClosureNamespaceRef ref).getClosureNamespace() |
      name = namespace.substring(0, namespace.indexOf("."))
      or
      name = namespace
    )
    or
    name = "goog" // The closure libraries themselves use the "goog" namespace
  }

  /**
   * Holds if a prefix of `name` is a closure namespace.
   */
  bindingset[name]
  private predicate hasClosureNamespacePrefix(string name) {
    isClosureNamespace(name.substring(0, name.indexOf(".")))
    or
    isClosureNamespace(name)
  }

  /**
   * Gets the closure namespace path addressed by the given data flow node, if any.
   */
  string getClosureNamespaceFromSourceNode(DataFlow::SourceNode node) {
    node = AccessPath::getAReferenceOrAssignmentTo(result) and
    hasClosureNamespacePrefix(result)
  }

  /**
   * Gets the closure namespace path written to by the given property write, if any.
   */
  string getWrittenClosureNamespace(DataFlow::PropWrite node) {
    node.getRhs() = AccessPath::getAnAssignmentTo(result) and
    hasClosureNamespacePrefix(result)
  }

  /**
   * Gets a data flow node that refers to the given value exported from a Closure module.
   */
  DataFlow::SourceNode moduleImport(string moduleName) {
    getClosureNamespaceFromSourceNode(result) = moduleName
  }

  /**
   * A call to `goog.bind`, as a partial function invocation.
   */
  private class BindCall extends DataFlow::PartialInvokeNode::Range, DataFlow::CallNode {
    BindCall() { this = moduleImport("goog.bind").getACall() }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      index >= 0 and
      callback = this.getArgument(0) and
      argument = this.getArgument(index + 2)
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      boundArgs = this.getNumArgument() - 2 and
      callback = this.getArgument(0) and
      result = this
    }

    override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
      callback = this.getArgument(0) and
      result = this.getArgument(1)
    }
  }
}
