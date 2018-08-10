import javascript

module Electron {
  /**
   * A data flow node that is an Electron `webPreferences` property.
   */
  class WebPreferences extends DataFlow::ObjectLiteralNode {
    WebPreferences() {
      exists(NewBrowserObject bo | this = bo.getWebPreferences().getALocalSource())
    }
  }
  
  /**
   * A data flow node that is an Electron `BrowserView` or `BrowserWindow`.
   */
  abstract class BrowserObject extends DataFlow::Node {
  }
  
  /**
   * A data flow node that creates a new `BrowserWindow` or `BrowserView`.
   */
  abstract class NewBrowserObject extends BrowserObject, DataFlow::TrackedNode {
    NewBrowserObject() {
      this instanceof DataFlow::NewNode
    }
    
    DataFlow::Node getWebPreferences() {
      result = this.(DataFlow::NewNode).getOptionArgument(0, "webPreferences")
    }
  }
  
  /**
   * A data flow node that creates a new `BrowserWindow`.
   */
  class BrowserWindow extends NewBrowserObject {
    BrowserWindow() {
      this = DataFlow::moduleMember("electron", "BrowserWindow").getAnInstantiation()
    }
  }
  
  /**
   * A data flow node with a TypeScript type indicating it is an Electron `BrowserWindow`
   */
  class TypedBrowserWindow extends BrowserObject {
    TypedBrowserWindow() {
      this.asExpr().getType().toString() = "BrowserWindow"
    }
  }
  
  /**
   * A data flow node with a TypeScript type indicating it is an Electron `BrowserView`
   */
  class TypedBrowserView extends BrowserObject {
    TypedBrowserView() {
      this.asExpr().getType().toString() = "BrowserView"
    }
  }
  /**
   * A data flow node that creates a new `BrowserView`.
   */
  class BrowserView extends NewBrowserObject {
    BrowserView() {
      this = DataFlow::moduleMember("electron", "BrowserView").getAnInstantiation()
    }
  }
  
  /**
   * A data flow node that is the `webContents` property of an Electron browser object
   */
  class WebContents extends DataFlow::TrackedNode {
    WebContents() {
      exists(BrowserObject bo |
        bo = (this.(DataFlow::PropRead).getBase())
      )
      or
      exists(NewBrowserObject nbo |
        nbo.flowsTo(this.(DataFlow::PropRead).getBase())
      )
    }
  }
  
  /**
   * A data flow node that imports `electron.ipcMain`.
   */
  class IPCMain extends DataFlow::SourceNode {
    IPCMain() {
      this = DataFlow::moduleMember("electron", "ipcMain")
    }
  }
  
  /**
   * A data flow node that is registered as an Electron IPC callback in the main process.
   */
  class IPCMainCallback extends DataFlow::FunctionNode {
    DataFlow::Node channel;
    
    IPCMainCallback() {
      exists(IPCMain ipcMain, DataFlow::MethodCallNode mc |
        mc = ipcMain.getAMemberCall("on") and
        this.flowsTo(mc.getArgument(1)) and
        channel = mc.getArgument(0)
      )
    }
    
    /**
     * Gets the data flow node that is the channel the callback is listening on.
     */
    DataFlow::Node getChannel() {
      result = channel
    }
    
    /**
     * Gets the string value that is the channel the callback is listening on.
     */
    string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  
  /**
   * A data flow node that is sent as an Electron IPC message from the main process.
   */
  abstract class IPCMainMessage extends DataFlow::ValueNode {
    /**
     * Gets the data flow node that is the channel the message is sent on.
     */
    abstract DataFlow::Node getChannel();
    
    /**
     * Gets the string value that is the channel the message is sent on.
     */
    abstract string getChannelValue();
  }
  
  /**
   * A data flow node that is sent as an initial Electron IPC message from the main process.
   */
  class IPCMainSentMessage extends IPCMainMessage {
    DataFlow::Node channel;
    
    IPCMainSentMessage() {
      exists(IPCMain ipcMain, DataFlow::MethodCallNode mc |
        (
          ipcMain.getAMemberCall("send") = mc
          or
          ipcMain.getAMemberCall("sendSync") = mc
        ) and
        this = mc.getArgument(1) and
        channel = mc.getArgument(0)
      )
    }
    
    override DataFlow::Node getChannel() {
      result = channel
    }
    
    override string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  
  /**
   * A data flow node that is sent as an asynchronous Electron IPC reply from the main process.
   */
  class IPCMainAsyncReplyMessage extends IPCMainMessage {
    DataFlow::Node channel;
    
    IPCMainAsyncReplyMessage() {
      exists(IPCMainCallback callback, DataFlow::MethodCallNode mc |
        mc = callback.getParameter(0).getAPropertyRead("sender").getAMemberCall("send") and
        this = mc.getArgument(1) and
        channel = mc.getArgument(0)
      )
    }
    
    override DataFlow::Node getChannel() {
      result = channel
    }
    
    override string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }

  /**
   * A data flow node that is sent as a synchronous Electron IPC message from the main process.
   */
  class IPCMainSyncReplyMessage extends DataFlow::Node {
    DataFlow::Node channel;
    
    IPCMainSyncReplyMessage() {
      exists(IPCMainCallback callback |
        this = callback.getParameter(0).getAPropertyWrite("returnValue").getRhs() and
        channel = callback.getChannel()
      )
    }
    
    DataFlow::Node getChannel() {
      result = channel
    }
    
    string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  
  /**
   * A data flow node that is a call to a synchronous Electron IPC method in the main process.
   */
  class IPCMainSendSync extends DataFlow::MethodCallNode {
    DataFlow::Node channel;
    
    IPCMainSendSync() {
      exists(IPCMain ipcMain |
        this = ipcMain.getAMemberCall("sendSync") and
        channel = this.getArgument(0)
      )
    }
    
    DataFlow::Node getChannel() {
      result = channel
    }
    
    string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
    /**
   * A data flow node that imports `electron.ipcRenderer`.
   */
  class IPCRenderer extends DataFlow::SourceNode {
    IPCRenderer() {
      this = DataFlow::moduleMember("electron", "ipcRenderer")
    }
  }
  
  /**
   * A data flow node that is registered as an Electron IPC callback in the renderer process.
   */
  class IPCRendererCallback extends DataFlow::FunctionNode {
    DataFlow::Node channel;
    
    IPCRendererCallback() {
      exists(IPCRenderer ipcRenderer, DataFlow::MethodCallNode mc |
        mc = ipcRenderer.getAMemberCall("on") and
        this.flowsTo(mc.getArgument(1)) and
        channel = mc.getArgument(0)
      )
    }
    
    /**
     * Gets the data flow node that is the channel the callback is listening on.
     */
    DataFlow::Node getChannel() {
      result = channel
    }
    
    /**
     * Gets the string value that is the channel the callback is listening on.
     */
    string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  
  /**
   * A data flow node that is sent as an Electron IPC message from the renderer process.
   */
  abstract class IPCRendererMessage extends DataFlow::ValueNode {
    /**
     * Gets the data flow node that is the channel the message is sent on.
     */
    abstract DataFlow::Node getChannel();
    
    /**
     * Gets the string value that is the channel the message is sent on.
     */
    abstract string getChannelValue();
  }
  
  /**
   * A data flow node that is sent as an initial Electron IPC message from the renderer process.
   */
  class IPCRendererSentMessage extends IPCRendererMessage {
    DataFlow::Node channel;
    
    IPCRendererSentMessage() {
      exists(IPCRenderer ipcRenderer, DataFlow::MethodCallNode mc |
        (
          ipcRenderer.getAMemberCall("send") = mc
          or
          ipcRenderer.getAMemberCall("sendSync") = mc
        ) and
        this = mc.getArgument(1) and
        channel = mc.getArgument(0)
      )
    }
    
    override DataFlow::Node getChannel() {
      result = channel
    }
    
    override string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  
  /**
   * A data flow node that is sent as an asynchronous Electron IPC reply from the renderer process.
   */
  class IPCRendererAsyncReplyMessage extends IPCRendererMessage {
    DataFlow::Node channel;
    
    IPCRendererAsyncReplyMessage() {
      exists(IPCRendererCallback callback, DataFlow::MethodCallNode mc |
        mc = callback.getParameter(0).getAPropertyRead("sender").getAMemberCall("send") and
        this = mc.getArgument(1) and
        channel = mc.getArgument(0)
      )
    }
    
    override DataFlow::Node getChannel() {
      result = channel
    }
    
    override string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }

  /**
   * A data flow node that is sent as a synchronous Electron IPC message from the renderer process.
   */
  class IPCRendererSyncReplyMessage extends DataFlow::Node {
    DataFlow::Node channel;
    
    IPCRendererSyncReplyMessage() {
      exists(IPCRendererCallback callback |
        this = callback.getParameter(0).getAPropertyWrite("returnValue").getRhs() and
        channel = callback.getChannel()
      )
    }
    
    DataFlow::Node getChannel() {
      result = channel
    }
    
    string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  
  /**
   * A data flow node that is a call to a synchronous Electron IPC method in the renderer process.
   */
  class IPCRendererSendSync extends DataFlow::MethodCallNode {
    DataFlow::Node channel;
    
    IPCRendererSendSync() {
      exists(IPCRenderer ipcRenderer |
        this = ipcRenderer.getAMemberCall("sendSync") and
        channel = this.getArgument(0)
      )
    }
    
    DataFlow::Node getChannel() {
      result = channel
    }
    
    string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }

  
  /**
   * A data flow node that is sent as an asynchronous Electron IPC message from the main process via a `webContents` object.
   */
  class WebContentsSendMessage extends IPCMainMessage {
    DataFlow::Node channel;
    
    WebContentsSendMessage() {
      exists(WebContents wc, DataFlow::MethodCallNode mc |
        wc.flowsTo(mc.getReceiver()) and
        this = mc.getArgument(1) and
        channel = mc.getArgument(0) and
        mc.getCalleeName() = "send"
      )
    }
    
    override DataFlow::Node getChannel() {
      result = channel
    }
    
    override string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  /**
   * Holds if `pred` flows to `succ` via the Electron IPC channel `channel`, as determined from local string values.
   */
  predicate ipcSimpleFlowStep(DataFlow::Node pred, DataFlow::Node succ, string channel) {
    // match a message sent from the main thread with a callback parameter in the renderer thread
    exists(IPCRendererCallback callback |
      succ = callback.getParameter(1) and
      channel = callback.getChannelValue() and
      channel = pred.(IPCMainMessage).getChannelValue()
    )
    or
    // match a message sent from the renderer thread with a callback parameter in the main thread
    exists(IPCMainCallback callback |
      succ = callback.getParameter(1) and
      channel = callback.getChannelValue() and
      channel = pred.(IPCRendererMessage).getChannelValue()
    )
    or
    // match a synchronous reply sent from the main thread with a `sendSync` call in the renderer thread
    exists(IPCRendererSendSync sendSync |
      succ = sendSync and
      channel = sendSync.getChannelValue() and
      channel = pred.(IPCMainSyncReplyMessage).getChannelValue()
    )
    or
    // match a synchronous reply sent from the renderer thread with a `sendSync` call in the main thread
    exists(IPCMainSendSync sendSync |
      succ = sendSync and
      channel = sendSync.getChannelValue() and
      channel = pred.(IPCRendererSyncReplyMessage).getChannelValue()
    )
  }
  
  /**
   * An additional flow step  via an Electron IPC message.
   */
  class IPCAdditionalFlowStep extends DataFlow::AdditionalFlowStep {
    IPCAdditionalFlowStep() {
      this instanceof IPCMainMessage or
      this instanceof IPCRendererMessage
    }
    
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      this = pred and
      ipcSimpleFlowStep(pred, succ, _)
    }
  }
}

