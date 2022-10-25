/**
 * Provides classes for working with Rails.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.ActiveRecord
private import codeql.ruby.frameworks.ActiveStorage
private import codeql.ruby.frameworks.internal.Rails
private import codeql.ruby.ApiGraphs
private import codeql.ruby.security.OpenSSL

/**
 * Provides classes for working with Rails.
 */
module Rails {
  /**
   * DEPRECATED: Any call to `html_safe` is considered an XSS sink.
   * A method call on a string to mark it as HTML safe for Rails. Strings marked
   * as such will not be automatically escaped when inserted into HTML.
   */
  deprecated class HtmlSafeCall extends MethodCall {
    HtmlSafeCall() { this.getMethodName() = "html_safe" }
  }

  /** A call to a Rails method to escape HTML. */
  class HtmlEscapeCall extends MethodCall instanceof HtmlEscapeCallImpl { }

  /** A call to fetch the request parameters in a Rails app. */
  class ParamsCall extends MethodCall instanceof ParamsCallImpl { }

  /** A call to fetch the request cookies in a Rails app. */
  class CookiesCall extends MethodCall instanceof CookiesCallImpl { }

  /**
   * A call to a render method that will populate the response body with the
   * rendered content.
   */
  class RenderCall extends MethodCall instanceof RenderCallImpl {
    private Expr getTemplatePathArgument() {
      // TODO: support other ways of specifying paths (e.g. `file`)
      result = [this.getKeywordArgument(["partial", "template", "action"]), this.getArgument(0)]
    }

    private string getTemplatePathValue() {
      result = this.getTemplatePathArgument().getConstantValue().getStringlikeValue()
    }

    // everything up to and including the final slash, but ignoring any leading slash
    private string getSubPath() {
      result = this.getTemplatePathValue().regexpCapture("^/?(.*/)?(?:[^/]*?)$", 1)
    }

    // everything after the final slash, or the whole string if there is no slash
    private string getBaseName() {
      result = this.getTemplatePathValue().regexpCapture("^/?(?:.*/)?([^/]*?)$", 1)
    }

    /**
     * Gets the template file to be rendered by this call, if any.
     */
    ErbFile getTemplateFile() {
      result.getTemplateName() = this.getBaseName() and
      result.getRelativePath().matches("%app/views/" + this.getSubPath() + "%")
    }

    /**
     * Get the local variables passed as context to the renderer
     */
    HashLiteral getLocals() { result = this.getKeywordArgument("locals") }
    // TODO: implicit renders in controller actions
  }

  /** A render call that does not automatically set the HTTP response body. */
  class RenderToCall extends MethodCall instanceof RenderToCallImpl { }

  /**
   * A `render` call seen as a file system access.
   */
  private class RenderAsFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    RenderAsFileSystemAccess() {
      exists(MethodCall call | this.asExpr().getExpr() = call |
        call instanceof RenderCall
        or
        call instanceof RenderToCall
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getKeywordArgument("file") }
  }
}

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
    exists(RailtieClass other |
      other.getModule() = this.getSuperclassExpr().(ConstantReadAccess).getModule()
    )
  }
}

private DataFlow::CallNode getAConfigureCallNode() {
  // `Rails.application.configure`
  result = API::getTopLevelMember("Rails").getReturn("application").getAMethodCall("configure")
  or
  // `Rails::Application.configure`
  exists(ConstantReadAccess read, RailtieClass cls |
    read = result.getReceiver().asExpr().getExpr() and
    read.getModule() = cls.getModule() and
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
      this = API::getTopLevelMember("Rails").getReturn("application").getReturn("config").asSource()
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

  private class Setting extends DataFlow::CallNode {
    Setting() {
      // exclude some test configuration
      not isInTestConfiguration(this.getLocation()) and
      this.getReceiver+() instanceof Config::Node and
      this.asExpr().getExpr() instanceof SetterMethodCall
    }
  }

  private class LiteralSetting extends Setting {
    ConstantValue value;

    LiteralSetting() {
      exists(DataFlow::LocalSourceNode lsn |
        lsn.asExpr().getConstantValue() = value and
        lsn.flowsTo(this.getArgument(0))
      )
    }

    string getValueText() { result = value.toString() }

    string getSettingString() { result = this.getMethodName() + this.getValueText() }
  }

  /**
   * A node that sets a boolean value.
   */
  class BooleanSetting extends LiteralSetting {
    override ConstantValue::ConstantBooleanValue value;

    boolean getValue() { result = value.getBoolean() }
  }

  /**
   * A node that sets a Stringlike value.
   */
  class StringlikeSetting extends LiteralSetting {
    override ConstantValue::ConstantStringlikeValue value;
  }

  /**
   * A node that sets a Stringlike value, or `nil`.
   */
  class NillableStringlikeSetting extends LiteralSetting {
    NillableStringlikeSetting() {
      value instanceof ConstantValue::ConstantStringlikeValue or
      value instanceof ConstantValue::ConstantNilValue
    }

    string getStringValue() { result = value.getStringlikeValue() }

    predicate isNilValue() { value.isNil() }
  }
}

/**
 * A `DataFlow::Node` that may enable or disable Rails CSRF protection in
 * production code.
 */
private class AllowForgeryProtectionSetting extends Settings::BooleanSetting,
  CsrfProtectionSetting::Range {
  AllowForgeryProtectionSetting() {
    this.getReceiver() instanceof Config::ActionControllerNode and
    this.getMethodName() = "allow_forgery_protection="
  }

  override boolean getVerificationSetting() { result = this.getValue() }
}

/**
 * Sets the cipher to be used for encrypted cookies. Defaults to "aes-256-gcm".
 * This can be set to any cipher supported by
 * https://ruby-doc.org/stdlib-2.7.1/libdoc/openssl/rdoc/OpenSSL/Cipher.html
 */
private class EncryptedCookieCipherSetting extends Settings::StringlikeSetting,
  CookieSecurityConfigurationSetting::Range {
  EncryptedCookieCipherSetting() {
    this.getReceiver() instanceof Config::ActionDispatchNode and
    this.getMethodName() = "encrypted_cookie_cipher="
  }

  OpenSslCipher getCipher() { this.getValueText() = result.getName() }

  OpenSslCipher getDefaultCipher() { result.getName() = "aes-256-gcm" }

  override string getSecurityWarningMessage() {
    this.getCipher().isWeak() and
    result = this.getValueText() + " is a weak cipher."
  }
}

/**
 * If true, signed and encrypted cookies will use the AES-256-GCM cipher rather
 * than the older AES-256-CBC cipher. Defaults to true.
 */
private class UseAuthenticatedCookieEncryptionSetting extends Settings::BooleanSetting,
  CookieSecurityConfigurationSetting::Range {
  UseAuthenticatedCookieEncryptionSetting() {
    this.getReceiver() instanceof Config::ActionDispatchNode and
    this.getMethodName() = "use_authenticated_cookie_encryption="
  }

  boolean getDefaultValue() { result = true }

  override string getSecurityWarningMessage() {
    this.getValue() = false and
    result = this.getSettingString() + " selects a weaker block mode for authenticated cookies."
  }
}

// TODO: this may also take a proc that specifies how to handle specific requests
/**
 * Configures the default value of the `SameSite` attribute when setting cookies.
 * Valid string values are `strict`, `lax`, and `none`.
 * The attribute can be omitted by setting this to `nil`.
 * The default if unset is `:lax`.
 * https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite#strict
 */
private class CookiesSameSiteProtectionSetting extends Settings::NillableStringlikeSetting,
  CookieSecurityConfigurationSetting::Range {
  CookiesSameSiteProtectionSetting() {
    this.getReceiver() instanceof Config::ActionDispatchNode and
    this.getMethodName() = "cookies_same_site_protection="
  }

  string getDefaultValue() { result = "lax" }

  override string getSecurityWarningMessage() {
    // Mark unset as being potentially dangerous, as not all browsers default to "lax"
    this.getStringValue().toLowerCase() = "none" and
    result = "Setting 'SameSite' to 'None' may make an application more vulnerable to CSRF attacks."
    or
    this.isNilValue() and
    result = "Unsetting 'SameSite' can disable same-site cookie restrictions in some browsers."
  }
}
// TODO: initialization hooks, e.g. before_configuration, after_initialize...
// TODO: initializers
