/**
 * Provides modeling for the `ActiveResource` library.
 * Version: 6.0.0.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

/**
 * Provides modeling for the `ActiveResource` library.
 * Version: 6.0.0.
 */
module ActiveResource {
  /**
   * An ActiveResource model class. This is any (transitive) subclass of ActiveResource.
   */
  pragma[nomagic]
  private API::Node activeResourceBaseClass() {
    result = API::getTopLevelMember("ActiveResource").getMember("Base")
  }

  private DataFlow::ClassNode activeResourceClass() {
    result = activeResourceBaseClass().getADescendentModule()
  }

  /**
   * An ActiveResource class.
   *
   * ```rb
   * class Person < ActiveResource::Base
   * end
   * ```
   */
  class ModelClassNode extends DataFlow::ClassNode {
    ModelClassNode() { this = activeResourceClass() }

    /** Gets a call to `site=`, which sets the base URL for this model. */
    SiteAssignCall getASiteAssignment() { result.getModelClass() = this }

    /** Holds if `c` sets a base URL which does not use HTTPS. */
    predicate disablesCertificateValidation(SiteAssignCall c) {
      c = this.getASiteAssignment() and
      c.disablesCertificateValidation()
    }

    /** Gets a method call on this class that returns an instance of the class. */
    private DataFlow::CallNode getAChainedCall() {
      result.(FindCall).getModelClass() = this
      or
      result.(CreateCall).getModelClass() = this
      or
      result.(CustomHttpCall).getModelClass() = this
      or
      result.(CollectionCall).getCollection().getModelClass() = this and
      result.getMethodName() = ["first", "last"]
    }

    /** Gets an API node referring to an instance of this class. */
    API::Node getAnInstanceReference() {
      result = this.trackInstance()
      or
      result = this.getAChainedCall().track()
    }
  }

  /**
   * A call to a class method on an ActiveResource model class.
   *
   * ```rb
   * class Person < ActiveResource::Base
   * end
   *
   * Person.find(1)
   * ```
   */
  class ModelClassMethodCall extends DataFlow::CallNode {
    private ModelClassNode cls;

    ModelClassMethodCall() { this = cls.trackModule().getAMethodCall(_) }

    /** Gets the model class for this call. */
    ModelClassNode getModelClass() { result = cls }
  }

  /**
   * A call to `site=` on an ActiveResource model class.
   * This sets the base URL for all HTTP requests made by this class.
   */
  private class SiteAssignCall extends ModelClassMethodCall {
    SiteAssignCall() { this.getMethodName() = "site=" }

    /**
     * Gets a node that contributes to the URLs used for HTTP requests by the parent
     * class.
     */
    DataFlow::Node getAUrlPart() { result = this.getArgument(0) }

    /** Holds if this site value specifies HTTP rather than HTTPS. */
    predicate disablesCertificateValidation() {
      this.getAUrlPart()
          // TODO: We should not need all this just to get the string value
          .asExpr()
          .(ExprNodes::AssignExprCfgNode)
          .getRhs()
          .getConstantValue()
          .getString()
          .regexpMatch("^http[^s].+")
    }
  }

  /**
   * A call to the `find` class method, which returns an ActiveResource model
   * object.
   *
   * ```rb
   * alice = Person.find(1)
   * ```
   */
  class FindCall extends ModelClassMethodCall {
    FindCall() { this.getMethodName() = "find" }
  }

  /**
   * A call to the `create(!)` class method, which returns an ActiveResource model
   * object.
   *
   * ```rb
   * alice = Person.create(name: "alice")
   * ```
   */
  class CreateCall extends ModelClassMethodCall {
    CreateCall() { this.getMethodName() = ["create", "create!"] }
  }

  /**
   * A call to a method that sends a custom HTTP request outside of the
   * ActiveResource conventions. This typically returns an ActiveResource model
   * object. It may return a collection, but we don't currently model that.
   *
   * ```rb
   * alice = Person.get(:active)
   * ```
   */
  class CustomHttpCall extends ModelClassMethodCall {
    CustomHttpCall() { this.getMethodName() = ["get", "post", "put", "patch", "delete"] }
  }

  /**
   * A call to a method on an ActiveResource model object.
   */
  class ModelInstanceMethodCall extends DataFlow::CallNode {
    private ModelClassNode cls;

    ModelInstanceMethodCall() { this = cls.getAnInstanceReference().getAMethodCall(_) }

    /** Gets the model class for this call. */
    ModelClassNode getModelClass() { result = cls }
  }

  /**
   * A call that returns a collection of ActiveResource model objects.
   */
  class CollectionSource extends ModelClassMethodCall {
    CollectionSource() {
      this.getMethodName() = "all"
      or
      this.getArgument(0).asExpr().getConstantValue().isStringlikeValue("all")
    }
  }

  /**
   * A method call on a collection.
   */
  class CollectionCall extends DataFlow::CallNode {
    private CollectionSource collection;

    CollectionCall() { this = collection.track().getAMethodCall(_) }

    /** Gets the collection for this call. */
    CollectionSource getCollection() { result = collection }
  }

  private class ModelClassMethodCallAsHttpRequest extends Http::Client::Request::Range,
    ModelClassMethodCall
  {
    ModelClassMethodCallAsHttpRequest() {
      this.getMethodName() = ["all", "build", "create", "create!", "find", "first", "last"]
    }

    override string getFramework() { result = "ActiveResource" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      this.getModelClass().disablesCertificateValidation(disablingNode) and
      // TODO: highlight real argument origin
      argumentOrigin = disablingNode
    }

    override DataFlow::Node getAUrlPart() {
      result = this.getModelClass().getASiteAssignment().getAUrlPart()
    }

    override DataFlow::Node getResponseBody() { result = this }
  }

  private class ModelInstanceMethodCallAsHttpRequest extends Http::Client::Request::Range,
    ModelInstanceMethodCall
  {
    ModelInstanceMethodCallAsHttpRequest() {
      this.getMethodName() =
        [
          "exists?", "reload", "save", "save!", "destroy", "delete", "get", "patch", "post", "put",
          "update_attribute", "update_attributes"
        ]
    }

    override string getFramework() { result = "ActiveResource" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      this.getModelClass().disablesCertificateValidation(disablingNode) and
      // TODO: highlight real argument origin
      argumentOrigin = disablingNode
    }

    override DataFlow::Node getAUrlPart() {
      result = this.getModelClass().getASiteAssignment().getAUrlPart()
    }

    override DataFlow::Node getResponseBody() { result = this }
  }
}
