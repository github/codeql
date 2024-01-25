/**
 * Provides modeling for the `ActionView` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.frameworks.internal.Rails
private import codeql.ruby.frameworks.Rails

/**
 * Holds if this AST node is in a context where `ActionView` methods are available.
 */
predicate inActionViewContext(AstNode n) {
  // Within a template
  n.getLocation().getFile() instanceof ErbFile
}

/**
 * A call to a Rails method that escapes HTML.
 */
class RailsHtmlEscaping extends Escaping::Range, DataFlow::CallNode {
  RailsHtmlEscaping() { this.asExpr().getExpr() instanceof Rails::HtmlEscapeCall }

  override DataFlow::Node getAnInput() { result = this.getArgument(0) }

  override DataFlow::Node getOutput() { result = this }

  override string getKind() { result = Escaping::getHtmlKind() }
}

/** A call to `html_escape` from within a template. */
private class ActionViewHtmlEscapeCall extends HtmlEscapeCallImpl {
  ActionViewHtmlEscapeCall() {
    // "h" is aliased to "html_escape" in ActiveSupport
    this.getMethodName() = ["html_escape", "html_escape_once", "h", "sanitize"] and
    inActionViewContext(this)
  }
}

/** A call in a context where some commonly used `ActionView` methods are available. */
private class ActionViewContextCall extends MethodCall {
  ActionViewContextCall() {
    this.getReceiver() instanceof SelfVariableAccess and
    inActionViewContext(this)
  }

  /**
   * Holds if this call is located inside an ERb template.
   */
  predicate isInErbFile() { this.getLocation().getFile() instanceof ErbFile }
}

/** A call to the `raw` method to output a value without HTML escaping. */
class RawCall extends ActionViewContextCall {
  RawCall() { this.getMethodName() = "raw" }
}

/** A call to the `params` method within the context of a template. */
private class ActionViewParamsCall extends ActionViewContextCall, ParamsCallImpl {
  ActionViewParamsCall() { this.getMethodName() = "params" }
}

// A call to the `cookies` method within the context of a template.
private class ActionViewCookiesCall extends ActionViewContextCall, CookiesCallImpl {
  ActionViewCookiesCall() { this.getMethodName() = "cookies" }
}

/**
 * A call to `render`, `render_to_body` or `render_to_string`, seen as an
 * `HttpResponse`.
 */
private class RenderCallAsHttpResponse extends DataFlow::CallNode, Http::Server::HttpResponse::Range
{
  RenderCallAsHttpResponse() {
    this.asExpr().getExpr() instanceof Rails::RenderCall or
    this.asExpr().getExpr() instanceof Rails::RenderToCall
  }

  // `render` is a very polymorphic method - all of these are valid calls:
  // render @user
  // render "path/to/template"
  // render html: "<html></html>"
  // render json: { "some" => "hash" }
  // render body: "some text"
  override DataFlow::Node getBody() {
    // A positional argument, e.g.
    // render @user
    // render "path/to/template"
    result = this.getArgument(_) and
    not result.asExpr() instanceof ExprNodes::PairCfgNode
    or
    result = this.getKeywordArgument(["html", "json", "body", "inline", "plain", "js", "file"])
  }

  override DataFlow::Node getMimetypeOrContentTypeArg() {
    result = this.getKeywordArgument("content_type")
  }

  override string getMimetype() {
    exists(this.getKeywordArgument("json")) and result = "application/json"
    or
    exists(this.getKeywordArgument("plain")) and result = "text/plain"
    or
    exists(this.getKeywordArgument("html")) and result = "text/html"
    or
    exists(this.getKeywordArgument("xml")) and result = "application/xml"
    or
    exists(this.getKeywordArgument("js")) and result = "text/javascript"
    or
    not exists(this.getKeywordArgument(["json", "plain", "html", "xml", "js"])) and
    result = super.getMimetype()
  }

  override string getMimetypeDefault() { result = "text/html" }
}

/** A call to the `render` method within the context of a template. */
private class ActionViewRenderCall extends ActionViewContextCall, RenderCallImpl {
  ActionViewRenderCall() { this.getMethodName() = "render" }
}

/** A call to `render_to` from within a template. */
private class ActionViewRenderToCall extends ActionViewContextCall, RenderToCallImpl {
  ActionViewRenderToCall() { this.getMethodName() = ["render_to_body", "render_to_string"] }
}

/**
 * A call to the ActionView `link_to` helper method.
 *
 * This generates an HTML anchor tag. The method is not designed to expect
 * user-input, so provided paths are not automatically HTML escaped.
 */
class LinkToCall extends ActionViewContextCall {
  LinkToCall() { this.getMethodName() = "link_to" }

  /**
   * Gets the path argument to the call.
   */
  Expr getPathArgument() {
    // When `link_to` is called with a block, it uses the first argument as the
    // path, and otherwise the second argument.
    exists(this.getBlock()) and result = this.getArgument(0)
    or
    not exists(this.getBlock()) and result = this.getArgument(1)
  }
}

/**
 * An instantiation of `ActionView::FileSystemResolver`, considered as a `FileSystemAccess`.
 */
class FileSystemResolverAccess extends DataFlow::CallNode, FileSystemAccess::Range {
  FileSystemResolverAccess() {
    this = API::getTopLevelMember("ActionView").getMember("FileSystemResolver").getAnInstantiation()
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
}

// TODO: model flow in/out of template files properly,
// TODO: Move the classes and predicates above inside this module.
/** Modeling for `ActionView`. */
module ActionView {
  /**
   * Action view helper methods which are XSS sinks.
   */
  module Helpers {
    abstract private class RawHelperCallImpl extends MethodCall {
      abstract Expr getRawArgument();
    }

    /**
     * A call to an ActionView helper which renders its argument without escaping.
     * The argument should be treated as an XSS sink. In the documentation for
     * classes in this module, the vulnerable argument is named `x`.
     */
    class RawHelperCall extends MethodCall instanceof RawHelperCallImpl {
      /** Gets an argument that is rendered without escaping. */
      Expr getRawArgument() { result = super.getRawArgument() }
    }

    /**
     * `ActionView::Helpers::TextHelper#simple_format`.
     *
     * `simple_format(x, y, sanitize: false)`.
     */
    private class SimpleFormat extends ActionViewContextCall, RawHelperCallImpl {
      SimpleFormat() {
        this.getMethodName() = "simple_format" and
        this.getKeywordArgument("sanitize").getConstantValue().isBoolean(false)
      }

      override Expr getRawArgument() { result = this.getArgument(0) }
    }

    /**
     * `ActionView::Helpers::TextHelper#truncate`.
     *
     * `truncate(x, escape: false)`.
     */
    private class Truncate extends ActionViewContextCall, RawHelperCallImpl {
      Truncate() {
        this.getMethodName() = "truncate" and
        this.getKeywordArgument("escape").getConstantValue().isBoolean(false)
      }

      override Expr getRawArgument() { result = this.getArgument(0) }
    }

    /**
     * `ActionView::Helpers::TextHelper#highlight`.
     *
     * `highlight(x, y, sanitize: false)`.
     */
    private class Highlight extends ActionViewContextCall, RawHelperCallImpl {
      Highlight() {
        this.getMethodName() = "highlight" and
        this.getKeywordArgument("sanitize").getConstantValue().isBoolean(false)
      }

      override Expr getRawArgument() { result = this.getArgument(0) }
    }

    /**
     * `ActionView::Helpers::JavascriptHelper#javascript_tag`.
     *
     * `javascript_tag(x)`.
     */
    private class JavascriptTag extends ActionViewContextCall, RawHelperCallImpl {
      JavascriptTag() { this.getMethodName() = "javascript_tag" }

      override Expr getRawArgument() { result = this.getArgument(0) }
    }

    /**
     * `ActionView::Helpers::TagHelper#content_tag`.
     *
     * `content_tag(x, x, y, false)`.
     */
    private class ContentTag extends ActionViewContextCall, RawHelperCallImpl {
      ContentTag() {
        this.getMethodName() = "content_tag" and
        this.getArgument(3).getConstantValue().isBoolean(false)
      }

      override Expr getRawArgument() { result = this.getArgument(1) }
    }

    /**
     * `ActionView::Helpers::TagHelper#tag`.
     *
     * `tag(x, x, y, false)`.
     */
    private class Tag extends ActionViewContextCall, RawHelperCallImpl {
      Tag() {
        this.getMethodName() = "tag" and
        this.getArgument(3).getConstantValue().isBoolean(false)
      }

      override Expr getRawArgument() { result = this.getArgument(0) }
    }

    /**
     * `ActionView::Helpers::TagHelper#tag.<tag name>`.
     *
     * `tag.h1(x, escape: false)`.
     */
    private class TagMethod extends MethodCall, RawHelperCallImpl {
      TagMethod() {
        inActionViewContext(this) and
        this.getReceiver().(MethodCall).getMethodName() = "tag" and
        this.getKeywordArgument("escape").getConstantValue().isBoolean(false)
      }

      override Expr getRawArgument() { result = this.getArgument(0) }
    }
  }

  /**
   * An argument to a method call which constructs a script tag, interpreting the
   * argument as a URL. Remote input flowing to this argument may allow loading of
   * arbitrary javascript.
   */
  class ArgumentInterpretedAsUrl extends DataFlow::Node {
    ArgumentInterpretedAsUrl() {
      exists(DataFlow::CallNode call |
        call.getMethodName() = ["javascript_include_tag", "javascript_path", "path_to_javascript"] and
        this = call.getArgument(0)
        or
        call.getMethodName() = "javascript_url" and
        this = call.getKeywordArgument("host")
      )
    }
  }
}
