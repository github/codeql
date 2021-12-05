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
private import codeql.ruby.security.CryptoAlgorithms

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
 * Classes representing accesses to the Rails config object.
 */
private module Config {
  /**
   * An access to a Rails config object.
   */
  private class SourceNode extends DataFlow::LocalSourceNode {
    SourceNode() {
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

  /**
   * A reference to the Rails config object.
   */
  class Node extends DataFlow::Node {
    Node() { exists(SourceNode src | src.flowsTo(this)) }
  }

  /**
   * A reference to the ActionController config object.
   */
  class ActionControllerNode extends DataFlow::Node {
    ActionControllerNode() {
      exists(DataFlow::CallNode source |
        source.getReceiver() instanceof Node and
        source.getMethodName() = "action_controller"
      |
        source.flowsTo(this)
      )
    }
  }

  /**
   * A reference to the ActionDispatch config object.
   */
  class ActionDispatchNode extends DataFlow::Node {
    ActionDispatchNode() {
      exists(DataFlow::CallNode source |
        source.getReceiver() instanceof Node and
        source.getMethodName() = "action_dispatch"
      |
        source.flowsTo(this)
      )
    }
  }
}

/**
 * Classes representing nodes that set a Rails configuration value.
 */
private module Settings {
  private predicate isInTestConfiguration(Location loc) {
    loc.getFile().getRelativePath().matches("%test/%") or
    loc.getFile().getStem() = "test"
  }

  private DataFlow::Node getTransitiveReceiver(DataFlow::CallNode c) {
    exists(DataFlow::Node recv |
      recv = c.getReceiver() and
      (
        result = recv
        or
        recv instanceof DataFlow::CallNode and
        result = getTransitiveReceiver(recv)
      )
    )
  }

  private class Setting extends DataFlow::CallNode {
    Setting() {
      // exclude some test configuration
      not isInTestConfiguration(this.getLocation()) and
      getTransitiveReceiver(this) instanceof Config::Node
    }
  }

  private class LiteralSetting extends Setting {
    Literal valueLiteral;

    LiteralSetting() {
      exists(DataFlow::LocalSourceNode lsn |
        lsn.asExpr().getExpr() = valueLiteral and
        lsn.flowsTo(this.getArgument(0))
      )
    }

    string getValueText() { result = valueLiteral.getValueText() }

    string getSettingString() { result = this.getMethodName() + this.getValueText() }
  }

  /**
   * A node that sets a boolean value.
   */
  class BooleanSetting extends LiteralSetting {
    override BooleanLiteral valueLiteral;

    boolean getValue() { result = valueLiteral.getValue() }
  }
}

/**
 * A `DataFlow::Node` that may enable or disable Rails CSRF protection in
 * production code.
 */
private class AllowForgeryProtectionSetting extends Settings::BooleanSetting,
  CSRFProtectionSetting::Range {
  AllowForgeryProtectionSetting() {
    this.getReceiver() instanceof Config::ActionControllerNode and
    this.getMethodName() = "allow_forgery_protection="
  }

  override boolean getVerificationSetting() { result = this.getValue() }
}

// TODO: initialization hooks, e.g. before_configuration, after_initialize...
// TODO: initializers
