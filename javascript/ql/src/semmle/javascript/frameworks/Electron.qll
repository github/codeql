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
  abstract private class NewBrowserObject extends BrowserObject {
    DataFlow::NewNode self;

    NewBrowserObject() { this = self }

    /**
     * Gets the data flow node from which this instantiation takes its `webPreferences` object.
     */
    DataFlow::SourceNode getWebPreferences() {
      result = self.getOptionArgument(0, "webPreferences").getALocalSource()
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
        asExpr().getType().hasUnderlyingType("electron", tp)
      )
    }
  }

  private DataFlow::SourceNode browserObject(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof NewBrowserObject
    or
    exists(DataFlow::TypeTracker t2 | result = browserObject(t2).track(t2, t))
  }

  /**
   * A data flow node whose value may originate from a browser object instantiation.
   */
  private class BrowserObjectByFlow extends BrowserObject {
    BrowserObjectByFlow() { browserObject(DataFlow::TypeTracker::end()).flowsTo(this) }
  }

  /**
   * A reference to the `webContents` property of a browser object.
   */
  class WebContents extends DataFlow::SourceNode {
    WebContents() { this.(DataFlow::PropRead).accesses(any(BrowserObject bo), "webContents") }
  }

  /**
   * Provides classes and predicates for modelling Electron inter-process communication (IPC).
   */
  private module IPC {
    class Process extends string {
      Process() { this = "main" or this = "renderer" }

      DataFlow::SourceNode getAnImport() {
        this = Process::main() and result = DataFlow::moduleMember("electron", "ipcMain")
        or
        this = Process::renderer() and result = DataFlow::moduleMember("electron", "ipcRenderer")
      }
    }

    module Process {
      Process main() { result = "main" }

      Process renderer() { result = "renderer" }
    }

    /**
     * An IPC callback.
     */
    class Callback extends DataFlow::FunctionNode {
      DataFlow::Node channel;

      Process process;

      Callback() {
        exists(DataFlow::MethodCallNode mc |
          mc = process.getAnImport().getAMemberCall("on") and
          this = mc.getCallback(1) and
          channel = mc.getArgument(0)
        )
      }

      /** Gets the process on which this callback is executed. */
      Process getProcess() { result = process }

      /** Gets the name of the channel the callback is listening on. */
      string getChannelName() { result = channel.asExpr().getStringValue() }

      /** Gets the data flow node containing the message received by the callback. */
      DataFlow::Node getMessage() { result = getParameter(1) }
    }

    /**
     * An IPC message.
     */
    abstract class Message extends DataFlow::Node {
      /** Gets the process that sends this message. */
      abstract Process getProcess();

      /** Gets the name of the channel this message is sent on. */
      abstract string getChannelName();
    }

    /**
     * An IPC message sent directly from a process.
     */
    class DirectMessage extends Message {
      DataFlow::MethodCallNode mc;

      Process process;

      DataFlow::Node channel;

      boolean isSync;

      DirectMessage() {
        exists(string send |
          send = "send" and isSync = false
          or
          send = "sendSync" and isSync = true
        |
          mc = process.getAnImport().getAMemberCall(send) and
          this = mc.getArgument(1) and
          channel = mc.getArgument(0)
        )
      }

      override Process getProcess() { result = process }

      override string getChannelName() { result = channel.asExpr().getStringValue() }
    }

    /**
     * A synchronous IPC message sent directly from a process.
     */
    class SyncDirectMessage extends DirectMessage {
      SyncDirectMessage() { isSync = true }

      /** Gets the data flow node holding the reply to the message. */
      DataFlow::Node getReply() { result = mc }
    }

    /**
     * An asynchronous IPC reply sent from within an IPC callback.
     */
    class AsyncReplyMessage extends Message {
      Callback callback;

      DataFlow::Node channel;

      AsyncReplyMessage() {
        exists(DataFlow::MethodCallNode mc |
          mc = callback.getParameter(0).getAPropertyRead("sender").getAMemberCall("send") and
          this = mc.getArgument(1) and
          channel = mc.getArgument(0)
        )
      }

      override Process getProcess() { result = callback.getProcess() }

      override string getChannelName() { result = channel.asExpr().getStringValue() }
    }

    /**
     * A synchronous IPC reply sent from within an IPC callback.
     */
    class SyncReplyMessage extends Message {
      Callback callback;

      SyncReplyMessage() {
        this = callback.getParameter(0).getAPropertyWrite("returnValue").getRhs()
      }

      override Process getProcess() { result = callback.getProcess() }

      override string getChannelName() { result = callback.getChannelName() }
    }

    /**
     * An asynchronous Electron IPC message sent from the main process via a `webContents` object.
     */
    class WebContentsMessage extends Message {
      DataFlow::Node channel;

      WebContentsMessage() {
        exists(WebContents wc, DataFlow::MethodCallNode mc |
          wc.flowsTo(mc.getReceiver()) and
          this = mc.getArgument(1) and
          channel = mc.getArgument(0) and
          mc.getCalleeName() = "send"
        )
      }

      override Process getProcess() { result = Process::main() }

      override string getChannelName() { result = channel.asExpr().getStringValue() }
    }

    /**
     * Holds if `pred` flows to `succ` via Electron IPC.
     */
    private predicate ipcFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      // match a message sent from one process with a callback parameter in the other process
      exists(Callback callback, Message msg |
        callback.getChannelName() = msg.getChannelName() and
        callback.getProcess() != msg.getProcess() and
        pred = msg and
        succ = callback.getMessage()
      )
      or
      // match a synchronous reply sent from one process with a `sendSync` call in the other process
      exists(SyncDirectMessage sendSync, SyncReplyMessage msg |
        sendSync.getChannelName() = msg.getChannelName() and
        sendSync.getProcess() != msg.getProcess() and
        pred = msg and
        succ = sendSync.getReply()
      )
    }

    /**
     * An additional flow step  via an Electron IPC message.
     */
    private class IPCAdditionalFlowStep extends DataFlow::AdditionalFlowStep {
      IPCAdditionalFlowStep() { ipcFlowStep(this, _) }

      override predicate step(DataFlow::Node pred, DataFlow::Node succ) { ipcFlowStep(pred, succ) }
    }
  }

  /**
   * A Node.js-style HTTP or HTTPS request made using an Electron module.
   */
  class ElectronClientRequest extends NodeJSLib::NodeJSClientRequest {
    override ElectronClientRequest::Range self;
  }

  module ElectronClientRequest {
    /**
     * A Node.js-style HTTP or HTTPS request made using an Electron module.
     *
     * Extends this class to add support for new Electron client-request APIs.
     */
    abstract class Range extends NodeJSLib::NodeJSClientRequest::Range { }
  }

  deprecated class CustomElectronClientRequest = ElectronClientRequest::Range;

  /**
   * A Node.js-style HTTP or HTTPS request made using `electron.ClientRequest`.
   */
  private class NewClientRequest extends ElectronClientRequest::Range {
    NewClientRequest() {
      this = DataFlow::moduleMember("electron", "ClientRequest").getAnInstantiation() or
      this = DataFlow::moduleMember("electron", "net").getAMemberCall("request") // alias
    }

    override DataFlow::Node getUrl() {
      result = getArgument(0) or
      result = getOptionArgument(0, "url")
    }

    override DataFlow::Node getHost() {
      exists(string name |
        name = "host" or
        name = "hostname"
      |
        result = getOptionArgument(0, name)
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
