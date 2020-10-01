/**
 * Provides predicates for reasoning about DOM types and methods.
 */

import javascript

/** Holds if `tp` is one of the roots of the DOM type hierarchy. */
predicate isDomRootType(ExternalType tp) {
  exists(string qn | qn = tp.getQualifiedName() | qn = "EventTarget" or qn = "StyleSheet")
}

/** A global variable whose declared type extends a DOM root type. */
class DOMGlobalVariable extends GlobalVariable {
  DOMGlobalVariable() {
    exists(ExternalVarDecl d | d.getQualifiedName() = this.getName() |
      isDomRootType(d.getTypeTag().getTypeDeclaration().getASupertype*())
    )
  }
}

/** Holds if `e` could hold a value that comes from the DOM. */
predicate isDomValue(Expr e) { DOM::domValueRef().flowsToExpr(e) }

/** Holds if `e` could refer to the `location` property of a DOM node. */
predicate isLocation(Expr e) {
  e = DOM::domValueRef().getAPropertyReference("location").asExpr()
  or
  e.accessesGlobal("location")
}

/**
 * Gets a reference to the 'document' object.
 */
DataFlow::SourceNode document() { result = DOM::documentRef() }

/** Holds if `e` could refer to the `document` object. */
predicate isDocument(Expr e) { DOM::documentRef().flowsToExpr(e) }

/** Holds if `e` could refer to the document URL. */
predicate isDocumentURL(Expr e) { e.flow() = DOM::locationSource() }

/**
 * Holds if `pacc` accesses a part of `document.location` that is
 * not considered user-controlled, that is, anything except
 * `href`, `hash` and `search`.
 */
predicate isSafeLocationProperty(PropAccess pacc) {
  exists(string prop | pacc = DOM::locationRef().getAPropertyRead(prop).asExpr() |
    prop != "href" and prop != "hash" and prop != "search"
  )
}

/**
 * A call to a DOM method.
 */
class DomMethodCallExpr extends MethodCallExpr {
  DomMethodCallExpr() { isDomValue(getReceiver()) }

  /**
   * Holds if `arg` is an argument that is interpreted as HTML.
   */
  predicate interpretsArgumentsAsHTML(Expr arg) {
    exists(int argPos, string name |
      arg = getArgument(argPos) and
      name = getMethodName()
    |
      // individual signatures:
      name = "write"
      or
      name = "writeln"
      or
      name = "insertAdjacentHTML" and argPos = 1
      or
      name = "insertAdjacentElement" and argPos = 1
      or
      name = "insertBefore" and argPos = 0
      or
      name = "createElement" and argPos = 0
      or
      name = "appendChild" and argPos = 0
      or
      (
        name = "setAttribute" and argPos = 1
        or
        name = "setAttributeNS" and argPos = 2
      ) and
      // restrict to potentially dangerous attributes
      exists(string attr |
        attr = "action" or
        attr = "formaction" or
        attr = "href" or
        attr = "src" or
        attr = "xlink:href" or
        attr = "data"
      |
        getArgument(argPos - 1).getStringValue().toLowerCase() = attr
      )
    )
  }
}

/**
 * An assignment to a property of a DOM object.
 */
class DomPropWriteNode extends Assignment {
  PropAccess lhs;

  DomPropWriteNode() {
    lhs = getLhs() and
    isDomValue(lhs.getBase())
  }

  /**
   * Holds if the assigned value is interpreted as HTML.
   */
  predicate interpretsValueAsHTML() {
    lhs.getPropertyName() = "innerHTML" or
    lhs.getPropertyName() = "outerHTML"
  }

  /**
   * Holds if the assigned value is interpreted as JavaScript via javascript: protocol.
   */
  predicate interpretsValueAsJavaScriptUrl() {
    lhs.getPropertyName() = "action" or
    lhs.getPropertyName() = "formaction" or
    lhs.getPropertyName() = "href" or
    lhs.getPropertyName() = "src" or
    lhs.getPropertyName() = "data"
  }
}

/**
 * A value written to web storage, like `localStorage` or `sessionStorage`.
 */
class WebStorageWrite extends Expr {
  WebStorageWrite() {
    exists(DataFlow::SourceNode webStorage |
      webStorage = DataFlow::globalVarRef("localStorage") or
      webStorage = DataFlow::globalVarRef("sessionStorage")
    |
      // an assignment to `window.localStorage[someProp]`
      this = webStorage.getAPropertyWrite().getRhs().asExpr()
      or
      // an invocation of `window.localStorage.setItem`
      this = webStorage.getAMethodCall("setItem").getArgument(1).asExpr()
    )
  }
}

/**
 * Persistent storage through web storage such as `localStorage` or `sessionStorage`.
 */
private module PersistentWebStorage {
  private DataFlow::SourceNode webStorage(string kind) {
    (kind = "localStorage" or kind = "sessionStorage") and
    result = DataFlow::globalVarRef(kind)
  }

  /**
   * A read access.
   */
  class ReadAccess extends PersistentReadAccess, DataFlow::CallNode {
    string kind;

    ReadAccess() { this = webStorage(kind).getAMethodCall("getItem") }

    override PersistentWriteAccess getAWrite() {
      getArgument(0).mayHaveStringValue(result.(WriteAccess).getKey()) and
      result.(WriteAccess).getKind() = kind
    }
  }

  /**
   * A write access.
   */
  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode {
    string kind;

    WriteAccess() { this = webStorage(kind).getAMethodCall("setItem") }

    string getKey() { getArgument(0).mayHaveStringValue(result) }

    string getKind() { result = kind }

    override DataFlow::Node getValue() { result = getArgument(1) }
  }
}

/**
 * An event handler that handles `postMessage` events.
 */
class PostMessageEventHandler extends Function {
  int paramIndex;

  PostMessageEventHandler() {
    exists(DataFlow::CallNode addEventListener |
      addEventListener = DataFlow::globalVarRef("addEventListener").getACall() and
      addEventListener.getArgument(0).mayHaveStringValue("message") and
      addEventListener.getArgument(1).getABoundFunctionValue(paramIndex).getFunction() = this
    )
    or
    exists(DataFlow::Node rhs |
      rhs = DataFlow::globalObjectRef().getAPropertyWrite("onmessage").getRhs() and
      rhs.getABoundFunctionValue(paramIndex).getFunction() = this
    )
  }

  /**
   * Gets the parameter that contains the event.
   */
  Parameter getEventParameter() { result = getParameter(paramIndex) }
}

/**
 * An event parameter for a `postMessage` event handler, considered as an untrusted
 * source of data.
 */
private class PostMessageEventParameter extends RemoteFlowSource {
  PostMessageEventParameter() {
    this = DataFlow::parameterNode(any(PostMessageEventHandler pmeh).getEventParameter())
  }

  override string getSourceType() { result = "postMessage event" }
}

/**
 * An access to `window.name`, which can be controlled by the opener of the window,
 * even if the window is opened from a foreign domain.
 */
private class WindowNameAccess extends RemoteFlowSource {
  WindowNameAccess() {
    this = DataFlow::globalObjectRef().getAPropertyRead("name")
    or
    // Reference to `name` on a container that does not assign to it.
    this.asExpr().(GlobalVarAccess).getName() = "name" and
    not exists(VarDef def |
      def.getAVariable().(GlobalVariable).getName() = "name" and
      def.getContainer() = this.asExpr().getContainer()
    )
  }

  override string getSourceType() { result = "Window name" }
}
