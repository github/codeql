/**
 * Provides predicates for reasoning about DOM types and methods.
 */

import javascript

/** Holds if `tp` is one of the roots of the DOM type hierarchy. */
predicate isDomRootType(ExternalType tp) {
  exists(string qn | qn = tp.getQualifiedName() | qn = "EventTarget" or qn = "StyleSheet")
}

/** A global variable whose declared type extends a DOM root type. */
class DomGlobalVariable extends GlobalVariable {
  DomGlobalVariable() {
    exists(ExternalVarDecl d | d.getQualifiedName() = this.getName() |
      isDomRootType(d.getTypeTag().getTypeDeclaration().getASupertype*())
    )
  }
}

/**
 * Holds if `e` could hold a value that comes from the DOM.
 */
predicate isDomNode(DataFlow::Node e) { DOM::domValueRef().flowsTo(e) }

/** Holds if `e` could refer to the `location` property of a DOM node. */
predicate isLocationNode(DataFlow::Node e) {
  e = DOM::domValueRef().getAPropertyReference("location")
  or
  e = DataFlow::globalVarRef("location")
}

/**
 * A call to a DOM method.
 */
class DomMethodCallNode extends DataFlow::MethodCallNode {
  DomMethodCallNode() { isDomNode(this.getReceiver()) }

  /**
   * Holds if `arg` is an argument that is interpreted as HTML.
   */
  predicate interpretsArgumentsAsHtml(DataFlow::Node arg) {
    exists(int argPos, string name |
      arg = this.getArgument(argPos) and
      name = this.getMethodName()
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
    )
  }

  /**
   * Holds if `arg` is an argument that is used as an URL.
   */
  predicate interpretsArgumentsAsUrl(DataFlow::Node arg) {
    exists(int argPos, string name |
      arg = this.getArgument(argPos) and
      name = this.getMethodName()
    |
      (
        name = "setAttribute" and argPos = 1
        or
        name = "setAttributeNS" and argPos = 2
      ) and
      // restrict to potentially dangerous attributes
      exists(string attr | attr = ["action", "formaction", "href", "src", "xlink:href", "data"] |
        this.getArgument(argPos - 1).getStringValue().toLowerCase() = attr
      )
    )
  }
}

/**
 * An assignment to a property of a DOM object.
 */
class DomPropertyWrite extends DataFlow::Node instanceof DataFlow::PropWrite {
  DomPropertyWrite() { isDomNode(super.getBase()) }

  /**
   * Holds if the assigned value is interpreted as HTML.
   */
  predicate interpretsValueAsHtml() {
    super.getPropertyName() = "innerHTML" or
    super.getPropertyName() = "outerHTML"
  }

  /**
   * Holds if the assigned value is interpreted as JavaScript via javascript: protocol.
   */
  predicate interpretsValueAsJavaScriptUrl() {
    super.getPropertyName() = DOM::getAPropertyNameInterpretedAsJavaScriptUrl()
  }

  /**
   * Gets the data flow node corresponding to the value being written.
   */
  DataFlow::Node getRhs() {
    result = super.getRhs()
    or
    result = super.getWriteNode().(AssignAddExpr).getRhs().flow()
  }
}

/**
 * A value written to web storage, like `localStorage` or `sessionStorage`.
 */
class WebStorageWrite extends DataFlow::Node {
  WebStorageWrite() {
    exists(DataFlow::SourceNode webStorage |
      webStorage = DataFlow::globalVarRef("localStorage") or
      webStorage = DataFlow::globalVarRef("sessionStorage")
    |
      // an assignment to `window.localStorage[someProp]`
      this = webStorage.getAPropertyWrite().getRhs()
      or
      // an invocation of `window.localStorage.setItem`
      this = webStorage.getAMethodCall("setItem").getArgument(1)
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

  pragma[noinline]
  WriteAccess getAWriteByName(string name, string kind) {
    result.getKey() = name and
    result.getKind() = kind
  }

  /**
   * A read access.
   */
  class ReadAccess extends PersistentReadAccess, DataFlow::CallNode {
    string kind;

    ReadAccess() { this = webStorage(kind).getAMethodCall("getItem") }

    override PersistentWriteAccess getAWrite() {
      exists(string name |
        this.getArgument(0).mayHaveStringValue(name) and
        result = getAWriteByName(name, kind)
      )
    }
  }

  /**
   * A write access.
   */
  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode {
    string kind;

    WriteAccess() { this = webStorage(kind).getAMethodCall("setItem") }

    string getKey() { this.getArgument(0).mayHaveStringValue(result) }

    string getKind() { result = kind }

    override DataFlow::Node getValue() { result = this.getArgument(1) }
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
  Parameter getEventParameter() { result = this.getParameter(paramIndex) }
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
private class WindowNameAccess extends ClientSideRemoteFlowSource {
  pragma[nomagic, noinline]
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

  override ClientSideRemoteFlowKind getKind() { result.isWindowName() }
}

private class WindowLocationFlowSource extends ClientSideRemoteFlowSource {
  ClientSideRemoteFlowKind kind;

  WindowLocationFlowSource() {
    this = DOM::locationSource() and kind.isUrl()
    or
    // Add separate sources for the properties of window.location as they are excluded
    // from the default taint steps.
    this = DOM::locationRef().getAPropertyRead("hash") and kind.isFragment()
    or
    this = DOM::locationRef().getAPropertyRead("search") and kind.isQuery()
    or
    this = DOM::locationRef().getAPropertyRead("href") and kind.isUrl()
  }

  override string getSourceType() { result = "Window location" }

  override ClientSideRemoteFlowKind getKind() { result = kind }
}
