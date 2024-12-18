import javascript

module Electron {
  /**
   * A `webPreferences` object.
   */
  class WebPreferences extends DataFlow::ObjectLiteralNode {
    WebPreferences() { this = any(NewBrowserObject nbo).getWebPreferences() }
  }

  /**
   * A data flow node that may contain a `BrowserWindow` or `BrowserView` object.
   */
  abstract class BrowserObject extends DataFlow::Node { }

  /**
   * An instantiation of `BrowserWindow` or `BrowserView`.
   */
  abstract private class NewBrowserObject extends BrowserObject instanceof DataFlow::NewNode {
    /**
     * Gets the data flow node from which this instantiation takes its `webPreferences` object.
     */
    DataFlow::SourceNode getWebPreferences() {
      result = super.getOptionArgument(0, "webPreferences").getALocalSource()
    }
  }

  /**
   * An instantiation of `BrowserWindow`.
   */
  class BrowserWindow extends NewBrowserObject {
    BrowserWindow() {
      this = DataFlow::moduleMember("electron", "BrowserWindow").getAnInstantiation()
    }
  }

  /**
   * An instantiation of `BrowserView`.
   */
  class BrowserView extends NewBrowserObject {
    BrowserView() { this = DataFlow::moduleMember("electron", "BrowserView").getAnInstantiation() }
  }

  /**
   * An expression of type `BrowserWindow` or `BrowserView`.
   */
  private class BrowserObjectByType extends BrowserObject {
    BrowserObjectByType() {
      exists(string tp | tp = "BrowserWindow" or tp = "BrowserView" |
        this.asExpr().getType().hasUnderlyingType("electron", tp)
      )
    }
  }

  private API::Node browserObject() { result.asSource() instanceof NewBrowserObject }

  /**
   * A data flow node whose value may originate from a browser object instantiation.
   */
  private class BrowserObjectByFlow extends BrowserObject {
    BrowserObjectByFlow() { browserObject().getAValueReachableFromSource() = this }
  }

  /**
   * A reference to the `webContents` property of a browser object.
   */
  class WebContents extends DataFlow::SourceNode, NodeJSLib::NodeJSEventEmitter {
    WebContents() { this.(DataFlow::PropRead).accesses(any(BrowserObject bo), "webContents") }
  }

  /**
   * Provides classes and predicates for modeling Electron inter-process communication (IPC).
   * The Electron IPC are EventEmitters, but they also expose a number of methods on top of the standard EventEmitter.
   */
  private module IPC {
    DataFlow::SourceNode main() { result = DataFlow::moduleMember("electron", "ipcMain") }

    DataFlow::SourceNode renderer() { result = DataFlow::moduleMember("electron", "ipcRenderer") }

    /**
     * A model for the Main and Renderer process in an Electron app.
     */
    abstract class Process extends EventEmitter::Range {
      /**
       * Gets a node that refers to a Process object.
       */
      DataFlow::SourceNode ref() { result = EventEmitter::trackEventEmitter(this) }
    }

    /**
     * An instance of the Main process of an Electron app.
     * Communication in an Electron app generally happens from the renderer process to the main process.
     */
    class MainProcess extends Process {
      MainProcess() { this = main() }
    }

    /**
     * An instance of the renderer process of an Electron app.
     */
    class RendererProcess extends Process {
      RendererProcess() { this = renderer() }
    }

    /**
     * The `sender` property of the event in an IPC event handler.
     * This sender is used to send a response back from the main process to the renderer.
     */
    class ProcessSender extends Process {
      ProcessSender() {
        exists(IpcSendRegistration reg | reg.getEmitter() instanceof MainProcess |
          this = reg.getABoundCallbackParameter(1, 0).getAPropertyRead("sender")
        )
      }
    }

    /**
     * A registration of an Electron IPC event handler.
     * Does mostly the same as an EventEmitter event handler,
     * except that values can be returned through the `event.returnValue` property.
     */
    class IpcSendRegistration extends EventRegistration::DefaultEventRegistration,
      DataFlow::MethodCallNode
    {
      override Process emitter;

      IpcSendRegistration() { this = emitter.ref().getAMethodCall(EventEmitter::on()) }

      override DataFlow::Node getAReturnedValue() {
        result = this.getABoundCallbackParameter(1, 0).getAPropertyWrite("returnValue").getRhs()
      }

      override IpcDispatch getAReturnDispatch() { result.getCalleeName() = "sendSync" }
    }

    /**
     * A dispatch of an IPC event.
     * An IPC event is sent from the renderer to the main process.
     * And a value can be returned through the `returnValue` property of the event (first parameter in the callback).
     */
    class IpcDispatch extends EventDispatch::DefaultEventDispatch, DataFlow::InvokeNode {
      override Process emitter;

      IpcDispatch() {
        exists(string methodName | methodName = "sendSync" or methodName = "send" |
          this = emitter.ref().getAMemberCall(methodName)
        )
      }

      /**
       * Gets the `i`th dispatched argument to the event handler.
       * The 0th parameter in the callback is a event generated by the IPC system,
       * therefore these arguments start at 1.
       */
      override DataFlow::Node getSentItem(int i) {
        i >= 1 and
        result = this.getArgument(i)
      }

      /**
       * Gets a registration that this dispatch can send an event to.
       */
      override IpcSendRegistration getAReceiver() {
        this.getEmitter() instanceof RendererProcess and
        result.getEmitter() instanceof MainProcess
        or
        this.getEmitter() instanceof ProcessSender and
        result.getEmitter() instanceof RendererProcess
      }
    }
  }

  /**
   * A Node.js-style HTTP or HTTPS request made using an Electron module.
   */
  class ElectronClientRequest extends NodeJSLib::NodeJSClientRequest instanceof ElectronClientRequest::Range
  { }

  module ElectronClientRequest {
    /**
     * A Node.js-style HTTP or HTTPS request made using an Electron module.
     *
     * Extends this class to add support for new Electron client-request APIs.
     */
    abstract class Range extends NodeJSLib::NodeJSClientRequest::Range { }
  }

  /**
   * A Node.js-style HTTP or HTTPS request made using `electron.ClientRequest`.
   */
  private class NewClientRequest extends ElectronClientRequest::Range {
    NewClientRequest() {
      this = DataFlow::moduleMember("electron", "ClientRequest").getAnInstantiation() or
      this = DataFlow::moduleMember("electron", "net").getAMemberCall("request") // alias
    }

    override DataFlow::Node getUrl() {
      result = this.getArgument(0) or
      result = this.getOptionArgument(0, "url")
    }

    override DataFlow::Node getHost() {
      exists(string name |
        name = "host" or
        name = "hostname"
      |
        result = this.getOptionArgument(0, name)
      )
    }

    override DataFlow::Node getADataNode() {
      exists(string name | name = "write" or name = "end" |
        result = this.getAMethodCall(name).getArgument(0)
      )
    }
  }

  /**
   * A data flow node that is the parameter of a redirect callback for an HTTP or HTTPS request made by a Node.js process, for example `res` in `net.request(url).on('redirect', (res) => {})`.
   */
  private class ClientRequestRedirectEvent extends RemoteFlowSource {
    ClientRequestRedirectEvent() {
      exists(NodeJSLib::ClientRequestHandler handler |
        this = handler.getParameter(0) and
        handler.getAHandledEvent() = "redirect" and
        handler.getClientRequest() instanceof ElectronClientRequest
      )
    }

    override string getSourceType() { result = "ElectronClientRequest redirect event" }
  }
}
