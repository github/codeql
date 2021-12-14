/**
 * Provides classes for working with Rails.
 */

private import codeql.files.FileSystem
private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.ActionView
private import codeql.ruby.frameworks.ActiveRecord
private import codeql.ruby.frameworks.ActiveStorage
private import codeql.ruby.ast.internal.Module
private import codeql.ruby.ApiGraphs

/**
 * A reference to either `Rails::Railtie`, `Rails::Engine`, or `Rails::Application`.
 * `Engine` and `Application` extend `Railtie`, but may not have definitions present in the database.
 */
private class RailtieClassAccess extends ConstantReadAccess {
  RailtieClassAccess() {
    this.getScopeExpr().(ConstantAccess).getName() = "Rails" and
    this.getName() = ["Railtie", "Engine", "Application"]
  }
}

// A `ClassDeclaration` that (transitively) extends `Rails::Railtie`
private class RailtieClass extends ClassDeclaration {
  RailtieClass() {
    this.getSuperclassExpr() instanceof RailtieClassAccess or
    exists(RailtieClass other | other.getModule() = resolveScopeExpr(this.getSuperclassExpr()))
  }
}

private DataFlow::CallNode getAConfigureCallNode() {
  // `Rails.application.configure`
  result = API::getTopLevelMember("Rails").getReturn("application").getAMethodCall("configure")
  or
  // `Rails::Application.configure`
  exists(ConstantReadAccess read, RailtieClass cls |
    read = result.getReceiver().asExpr().getExpr() and
    resolveScopeExpr(read) = cls.getModule() and
    result.asExpr().getExpr().(MethodCall).getMethodName() = "configure"
  )
}

/**
 * An access to a Rails config object.
 */
private class ConfigSourceNode extends DataFlow::LocalSourceNode {
  ConfigSourceNode() {
    // `Foo < Rails::Application ... config ...`
    exists(MethodCall configCall | this.asExpr().getExpr() = configCall |
      configCall.getMethodName() = "config" and
      configCall.getEnclosingModule() instanceof RailtieClass
    )
    or
    // `Rails.application.config`
    this =
      API::getTopLevelMember("Rails")
          .getReturn("application")
          .getReturn("config")
          .getAnImmediateUse()
    or
    // `Rails.application.configure { ... config ... }`
    // `Rails::Application.configure { ... config ... }`
    exists(DataFlow::CallNode configureCallNode, Block block, MethodCall configCall |
      configCall = this.asExpr().getExpr()
    |
      configureCallNode = getAConfigureCallNode() and
      block = configureCallNode.asExpr().getExpr().(MethodCall).getBlock() and
      configCall.getParent+() = block and
      configCall.getMethodName() = "config"
    )
  }
}

private class ConfigNode extends DataFlow::Node {
  ConfigNode() { exists(ConfigSourceNode src | src.flowsTo(this)) }
}

// A call where the Rails application config is the receiver
private class CallAgainstConfig extends DataFlow::CallNode {
  CallAgainstConfig() { this.getReceiver() instanceof ConfigNode }

  MethodCall getCall() { result = this.asExpr().getExpr() }

  Block getBlock() { result = this.getCall().getBlock() }
}

private class ActionControllerConfigNode extends DataFlow::Node {
  ActionControllerConfigNode() {
    exists(CallAgainstConfig source | source.getCall().getMethodName() = "action_controller" |
      source.flowsTo(this)
    )
  }
}

/** Holds if `node` can contain `value`. */
private predicate hasBooleanValue(DataFlow::Node node, boolean value) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().(BooleanLiteral).getValue() = value and
    literal.flowsTo(node)
  )
}

// `<actionControllerConfig>.allow_forgery_protection = <verificationSetting>`
private DataFlow::CallNode getAnAllowForgeryProtectionCall(boolean verificationSetting) {
  // exclude some test configuration
  not (
    result.getLocation().getFile().getRelativePath().matches("%test/%") or
    result.getLocation().getFile().getStem() = "test"
  ) and
  result.getReceiver() instanceof ActionControllerConfigNode and
  result.asExpr().getExpr().(MethodCall).getMethodName() = "allow_forgery_protection=" and
  hasBooleanValue(result.getArgument(0), verificationSetting)
}

/**
 * A `DataFlow::Node` that may enable or disable Rails CSRF protection in
 * production code.
 */
private class AllowForgeryProtectionSetting extends CSRFProtectionSetting::Range {
  private boolean verificationSetting;

  AllowForgeryProtectionSetting() { this = getAnAllowForgeryProtectionCall(verificationSetting) }

  override boolean getVerificationSetting() { result = verificationSetting }
}
// TODO: initialization hooks, e.g. before_configuration, after_initialize...
// TODO: initializers
