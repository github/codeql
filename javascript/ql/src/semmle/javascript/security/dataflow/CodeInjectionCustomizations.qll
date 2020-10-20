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
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for code injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for code injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An access to a property that may hold (parts of) the document URL.
   */
  class LocationSource extends Source {
    LocationSource() { this = DOM::locationSource() }
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
   * An event handler attribute as a code injection sink.
   */
  class EventHandlerAttributeSink extends Sink {
    EventHandlerAttributeSink() {
      exists(DOM::AttributeDefinition def |
        def.getName().regexpMatch("(?i)on.+") and
        this = def.getValueNode() and
        // JSX event handlers are functions, not strings
        not def instanceof JSXAttribute
      )
    }
  }

  /**
   * A code operator of a NoSQL query as a code injection sink.
   */
  class NoSQLCodeInjectionSink extends Sink {
    NoSQLCodeInjectionSink() { any(NoSQL::Query q).getACodeOperator() = this }
  }

  /**
   * The first argument to `Module.prototype._compile` from the Node.js built-in module `module`,
   * considered as a code-injection sink.
   */
  class ModuleCompileSink extends Sink {
    ModuleCompileSink() {
      this =
        API::moduleImport("module").getInstance().getMember("_compile").getACall().getArgument(0)
    }
  }
}
