/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * code injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

module CodeInjection {
  /**
   * A data flow source for code injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for code injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the substitute for `X` in the message `User-provided value flows to X`.
     */
    string getMessageSuffix() { result = "here and is interpreted as code" }
  }

  /**
   * A sanitizer for code injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for code injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An expression which may be interpreted as an AngularJS expression.
   */
  class AngularJSExpressionSink extends Sink, DataFlow::ValueNode {
    AngularJSExpressionSink() {
      any(AngularJS::AngularJSCall call).interpretsArgumentAsCode(this.asExpr())
    }
  }

  /**
   * An expression which may be evaluated as JavaScript in NodeJS using the
   * `vm` module.
   */
  class NodeJSVmSink extends Sink, DataFlow::ValueNode {
    NodeJSVmSink() {
      exists(NodeJSLib::VmModuleMemberInvocation inv | this = inv.getACodeArgument())
    }
  }

  /**
   * A template tag occuring in JS code, viewed as a code injection sink.
   */
  class TemplateTagInScriptSink extends Sink {
    TemplateTagInScriptSink() {
      exists(Templating::TemplatePlaceholderTag tag |
        this = tag.asDataFlowNode() and
        tag.isEscapingInterpolation() // to avoid double reporting, raw interpolation is only flagged by the XSS query
      |
        // In an attribute, HTML entities are expanded prior to JS parsing, so the escaping performed by the
        // templating engine has no effect against code injection.
        tag.isInCodeAttribute()
        or
        // In a script tag, HTML entities are not expanded.
        // To reduce noise, we filter out a common pattern where a template tag occurs in a string literal,
        // since HTML escaping prevents breaking out of the string literal.
        //
        //    var foo = "<%= foo %>";
        //
        // However, we still flag the special case where multiple such strings occur on the same line, as injection can sometimes
        // we obtained by injecting a backslash character at the end of the first one:
        //
        //    init("<%= foo %">, "<%= bar %>");
        //
        // For example, setting foo to `\` and bar to `, alert(1));//`, code injection is obtained.
        tag.isInScriptTag() and
        not tag.getEnclosingExpr() =
          getLastStringWithPlaceholderOnLine(tag.getLocation().getFile(),
            tag.getLocation().getStartLine())
      )
    }
  }

  /** Gets the last string literal containing a template placeholder on the given line. */
  pragma[nomagic]
  private StringLiteral getLastStringWithPlaceholderOnLine(File file, int line) {
    result =
      max(StringLiteral lit, Location loc |
        loc = lit.getLocation() and
        loc.getFile() = file and
        loc.getStartLine() = line and
        lit =
          any(Templating::TemplatePlaceholderTag tag | tag.isEscapingInterpolation())
              .getEnclosingExpr()
      |
        lit order by loc.getStartColumn()
      )
  }

  /**
   * A server-side template tag occurring in the context of another template language.
   */
  class TemplateTagInNestedTemplateContext extends Sink {
    string templateType;

    TemplateTagInNestedTemplateContext() {
      exists(Templating::TemplatePlaceholderTag tag |
        tag.isInNestedTemplateContext(templateType) and
        this = tag.asDataFlowNode()
      )
    }

    override string getMessageSuffix() {
      result = "here and is interpreted by " + templateType + ", which may evaluate it as code"
    }
  }

  /**
   * Gets a reference to a `<script />` tag created using `document.createElement`.
   */
  private DataFlow::SourceNode scriptTag(DataFlow::TypeTracker t) {
    t.start() and
    exists(DataFlow::CallNode call | call = result |
      call = DOM::documentRef().getAMethodCall("createElement") and
      call.getArgument(0).mayHaveStringValue("script")
    )
    or
    exists(DataFlow::TypeTracker t2 | result = scriptTag(t2).track(t2, t))
  }

  /**
   * Gets a reference to a `<script />` tag created using `document.createElement`,
   * or an element of type `HTMLScriptElement`.
   */
  private DataFlow::SourceNode scriptTag() {
    result = scriptTag(DataFlow::TypeTracker::end())
    or
    result.hasUnderlyingType("HTMLScriptElement")
  }

  /**
   * A write to the `textContent` property of a `<script />` tag,
   * seen as a sink for code injection vulnerabilities.
   */
  class ScriptContentSink extends Sink {
    ScriptContentSink() { this = scriptTag().getAPropertyWrite("textContent").getRhs() }
  }

  /**
   * An expression which may be evaluated as JavaScript.
   */
  class EvalJavaScriptSink extends Sink, DataFlow::ValueNode {
    EvalJavaScriptSink() {
      exists(DataFlow::InvokeNode c, int index |
        exists(string callName | c = DataFlow::globalVarRef(callName).getAnInvocation() |
          callName = "eval" and index = 0
          or
          callName = "Function"
          or
          callName = "execScript" and index = 0
          or
          callName = "executeJavaScript" and index = 0
          or
          callName = "execCommand" and index = 0
          or
          callName = "setTimeout" and index = 0
          or
          callName = "setInterval" and index = 0
          or
          callName = "setImmediate" and index = 0
        )
        or
        exists(DataFlow::GlobalVarRefNode wasm, string methodName |
          wasm.getName() = "WebAssembly" and c = wasm.getAMemberCall(methodName)
        |
          methodName = "compile" or
          methodName = "compileStreaming"
        )
      |
        this = c.getArgument(index)
      )
      or
      // node-serialize is not intended to be safe for untrusted inputs
      this = DataFlow::moduleMember("node-serialize", "unserialize").getACall().getArgument(0)
    }
  }

  /**
   * An expression which is injected as JavaScript into a React Native `WebView`.
   */
  class WebViewInjectedJavaScriptSink extends Sink {
    WebViewInjectedJavaScriptSink() {
      exists(ReactNative::WebViewElement webView |
        // `injectedJavaScript` property of React Native `WebView`
        this = webView.getAPropertyWrite("injectedJavaScript").getRhs()
        or
        // argument to `injectJavascript` method of React Native `WebView`
        this = webView.getAMethodCall("injectJavaScript").getArgument(0)
      )
    }
  }

  /**
   * A body element from a script tag inside React code.
   */
  class ReactScriptTag extends Sink {
    ReactScriptTag() {
      exists(JsxElement element | element.getName() = "script" |
        this = element.getBodyElement(_).flow()
      )
    }
  }

  /**
   * An event handler attribute as a code injection sink.
   */
  class EventHandlerAttributeSink extends Sink {
    EventHandlerAttributeSink() {
      exists(DOM::AttributeDefinition def |
        def.getName().regexpMatch("(?i)on.+") and
        this = def.getValueNode() and
        // JSX event handlers are functions, not strings
        not def instanceof JsxAttribute
      )
    }
  }

  /**
   * A code operator of a NoSQL query as a code injection sink.
   */
  class NoSqlCodeInjectionSink extends Sink {
    NoSqlCodeInjectionSink() { any(NoSql::Query q).getACodeOperator() = this }
  }

  /** DEPRECATED: Alias for NoSqlCodeInjectionSink */
  deprecated class NoSQLCodeInjectionSink = NoSqlCodeInjectionSink;

  /**
   * The first argument to `Module.prototype._compile`, considered as a code-injection sink.
   */
  class ModuleCompileSink extends Sink {
    ModuleCompileSink() {
      // `require('module').prototype._compile`
      this =
        API::moduleImport("module").getInstance().getMember("_compile").getACall().getArgument(0)
      or
      // `module.constructor.prototype._compile`
      exists(DataFlow::SourceNode moduleConstructor |
        moduleConstructor = DataFlow::moduleVarNode(_).getAPropertyRead("constructor") and
        this = moduleConstructor.getAnInstantiation().getAMethodCall("_compile").getArgument(0)
      )
    }
  }

  /**
   * A system command execution of "node", where the executed code is seen as a code injection sink.
   */
  class NodeCallSink extends Sink {
    NodeCallSink() {
      exists(SystemCommandExecution s |
        s.getACommandArgument().mayHaveStringValue("node")
        or
        s.getACommandArgument() =
          DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead("0")
      |
        exists(DataFlow::SourceNode arr | arr = s.getArgumentList().getALocalSource() |
          arr.getAPropertyWrite().getRhs().mayHaveStringValue("-e") and
          this = arr.getAPropertyWrite().getRhs()
        )
      )
    }
  }

  /** A sink for code injection via template injection. */
  abstract private class TemplateSink extends Sink {
    override string getMessageSuffix() {
      result = "here and is interpreted as a template, which may contain code"
    }
  }

  /**
   * A value interpreted as as template by the `pug` library.
   */
  class PugTemplateSink extends TemplateSink {
    PugTemplateSink() {
      this =
        DataFlow::moduleImport(["pug", "jade"]).getAMemberCall(["compile", "render"]).getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `handlebars` library.
   */
  class HandlebarsTemplateSink extends TemplateSink {
    HandlebarsTemplateSink() {
      this = any(Handlebars::Handlebars h).getAMemberCall("compile").getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `mustache` library.
   */
  class MustacheTemplateSink extends TemplateSink {
    MustacheTemplateSink() {
      this = DataFlow::moduleMember("mustache", "render").getACall().getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `hogan.js` library.
   */
  class HoganTemplateSink extends TemplateSink {
    HoganTemplateSink() {
      this = DataFlow::moduleMember("hogan.js", "compile").getACall().getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `eta` library.
   */
  class EtaTemplateSink extends TemplateSink {
    EtaTemplateSink() { this = DataFlow::moduleMember("eta", "render").getACall().getArgument(0) }
  }

  /**
   * A value interpreted as a template by the `squirrelly` library.
   */
  class SquirrelTemplateSink extends TemplateSink {
    SquirrelTemplateSink() {
      this = DataFlow::moduleMember("squirrelly", "render").getACall().getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `whiskers` library.
   */
  class WhiskersTemplateSink extends TemplateSink {
    WhiskersTemplateSink() {
      this = DataFlow::moduleMember("whiskers", "render").getACall().getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `dot` library.
   */
  class DotTemplateSink extends TemplateSink {
    DotTemplateSink() {
      this = DataFlow::moduleImport("dot").getAMemberCall(["template", "compile"]).getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `ejs` library.
   */
  class EjsTemplateSink extends TemplateSink {
    EjsTemplateSink() {
      this = DataFlow::moduleImport("ejs").getAMemberCall("render").getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by the `nunjucks` library.
   */
  class NunjucksTemplateSink extends TemplateSink {
    NunjucksTemplateSink() {
      this = DataFlow::moduleImport("nunjucks").getAMemberCall("renderString").getArgument(0)
    }
  }

  /**
   * A value interpreted as a template by `lodash` or `underscore`.
   */
  class LodashUnderscoreTemplateSink extends TemplateSink {
    LodashUnderscoreTemplateSink() {
      this = LodashUnderscore::member("template").getACall().getArgument(0)
    }
  }

  /**
   * A call to JSON.stringify() seen as a sanitizer.
   */
  class JsonStringifySanitizer extends Sanitizer, JsonStringifyCall { }

  /** DEPRECATED: Alias for JsonStringifySanitizer */
  deprecated class JSONStringifySanitizer = JsonStringifySanitizer;
}
