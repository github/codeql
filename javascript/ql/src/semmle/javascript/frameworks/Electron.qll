import javascript

module Electron {
  /**
   * A data flow node that is an Electron `webPreferences` property.
   */
  class WebPreferences extends DataFlow::ObjectLiteralNode {
    WebPreferences() {
      exists(NewBrowserObject bo | this = bo.getOptionArgument(0, "webPreferences").getALocalSource())
    }
  }
  

  abstract class BrowserObject extends DataFlow::Node {
  }
  
  /**
   * A data flow node that creates a new `BrowserWindow` or `BrowserView`.
   */
  abstract class NewBrowserObject extends BrowserObject, DataFlow::NewNode {
  }
  
  /**
   * A data flow node that creates a new `BrowserWindow`.
   */
  class BrowserWindow extends NewBrowserObject {
    BrowserWindow() {
      this = DataFlow::moduleMember("electron", "BrowserWindow").getAnInstantiation()
    }
  }
  
  class TypedBrowserWindow extends BrowserObject {
    TypedBrowserWindow() {
      this.asExpr().getType().toString() = "BrowserWindow"
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
  
  class BrowserToWebContentsConfiguration extends Configuration2::Configuration {
    BrowserToWebContentsConfiguration() {
      this = "BrowserToWebContentsConfiguration"
    }
    
    override predicate isSource(DataFlow::Node node) {
      node instanceof BrowserObject
    }
    
    override predicate isSink(DataFlow::Node node) {
      exists(DataFlow::PropRead read |
       read.getPropertyName() = "webContents" and
       node = read.getBase()
     )
    }
  }
  
  /**
   * A data flow node that is the `webContents` property of an Electron browser object
   */
  cached class WebContents extends DataFlow::Node {
    cached WebContents() {
      exists(BrowserToWebContentsConfiguration cfg, DataFlow::Node base |
        cfg.hasFlow(_, base) and
        base = this.(DataFlow::PropRead).getBase()
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
        ipcMain.flowsTo(mc.getReceiver()) and
        this.flowsTo(mc.getArgument(1)) and
        channel = mc.getArgument(0) and
        mc.getCalleeName() = "on"
      )
    }
    
    /**
     * A data flow node that is the channel the callback is listening on.
     */
    DataFlow::Node getChannel() {
      result = channel
    }
    
    /**
     * The string value that is the channel the callback is listening on.
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
     * A data flow node that is the channel the message is sent on.
     */
    abstract DataFlow::Node getChannel();
    
    /**
     * The string value that is the channel the message is sent on.
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
        ipcMain.flowsTo(mc.getReceiver()) and
        this = mc.getArgument(1) and
        channel = mc.getArgument(0) and
        (
          mc.getCalleeName() = "send"
          or
          mc.getCalleeName() = "sendSync"
        )
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
   * A data flow node that is sent as an Electron IPC reply from the main process.
   */
  abstract class IPCMainReplyMessage extends IPCMainMessage {
  }
  
  /**
   * A data flow node that is sent as an asynchronous Electron IPC reply from the main process.
   */
  class IPCMainAsyncReplyMessage extends IPCMainReplyMessage {
    DataFlow::Node channel;
    
    IPCMainAsyncReplyMessage() {
      exists(IPCMainCallback callback, DataFlow::MethodCallNode mc |
        callback.getParameter(0).getAPropertyRead("sender").flowsTo(mc.getReceiver()) and
        this = mc.getArgument(1) and
        mc.getCalleeName() = "send" and
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
  class IPCMainSyncReplyMessage extends IPCMainReplyMessage {
    DataFlow::Node channel;
    
    IPCMainSyncReplyMessage() {
      exists(IPCMainCallback callback, DataFlow::PropWrite write |
        callback.getParameter(0).flowsTo(write.getBase()) and
        this = write.getRhs() and
        write.getPropertyName() = "returnValue" and
        channel = callback.getChannel()
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
   * A data flow node that is a call to a synchronous Electron IPC method in the main process.
   */
  class IPCMainSendSync extends DataFlow::MethodCallNode {
    DataFlow::Node channel;
    
    IPCMainSendSync() {
      exists(IPCMain ipcMain |
        ipcMain.flowsTo(this.getReceiver()) and
        this.getCalleeName() = "sendSync" and
        this.getArgument(0) = channel
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
   * A data flow node that is registered as an Electron IPC callback in a renderer process.
   */
  class IPCRendererCallback extends DataFlow::FunctionNode {
    DataFlow::Node channel;
    
    IPCRendererCallback() {
      exists(IPCRenderer ipcRenderer, DataFlow::MethodCallNode mc |
        ipcRenderer.flowsTo(mc.getReceiver()) and
        this.flowsTo(mc.getArgument(1)) and
        channel = mc.getArgument(0) and
        mc.getCalleeName() = "on"
      )
    }
    
    /**
     * A data flow node that is the channel the callback is listening on.
     */
    DataFlow::Node getChannel() {
      result = channel
    }
    
    /**
     * The string value that is the channel the callback is listening on.
     */
    string getChannelValue() {
      result = channel.asExpr().getStringValue()
    }
  }
  
  /**
   * A data flow node that is sent as an Electron IPC message from a renderer process.
   */
  abstract class IPCRendererMessage extends DataFlow::ValueNode {
    /**
     * A data flow node that is the channel the message is sent on.
     */
    abstract DataFlow::Node getChannel();
    
    /**
     * The string value that is the channel the message is sent on.
     */
    abstract string getChannelValue();
  }
  
  /**
   * A data flow node that is sent as an initial Electron IPC message from a renderer process.
   */
  class IPCRendererSentMessage extends IPCRendererMessage {
    DataFlow::Node channel;
    
    IPCRendererSentMessage() {
      exists(IPCRenderer ipcRenderer, DataFlow::MethodCallNode mc |
        ipcRenderer.flowsTo(mc.getReceiver()) and
        this = mc.getArgument(1) and
        channel = mc.getArgument(0) and
        (
          mc.getCalleeName() = "send"
          or
          mc.getCalleeName() = "sendSync"
        )
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
   * A data flow node that is sent as an Electron IPC reply from a renderer process.
   */
  abstract class IPCRendererReplyMessage extends IPCRendererMessage {
  }
  
  /**
   * A data flow node that is sent as an asynchronous Electron IPC reply from a renderer process.
   */
  class IPCRendererAsyncReplyMessage extends IPCRendererReplyMessage {
    DataFlow::Node channel;
    
    IPCRendererAsyncReplyMessage() {
      exists(IPCRendererCallback callback, DataFlow::MethodCallNode mc |
        callback.getParameter(0).getAPropertyRead("sender").flowsTo(mc.getReceiver()) and
        this = mc.getArgument(1) and
        mc.getCalleeName() = "send" and
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
   * A data flow node that is sent as a synchronous Electron IPC message from a renderer process.
   */
  class IPCRendererSyncReplyMessage extends IPCRendererReplyMessage {
    DataFlow::Node channel;
    
    IPCRendererSyncReplyMessage() {
      exists(IPCRendererCallback callback, DataFlow::PropWrite write |
        callback.getParameter(0).flowsTo(write.getBase()) and
        this = write.getRhs() and
        write.getPropertyName() = "returnValue" and
        channel = callback.getChannel()
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
   * A data flow node that is a call to a synchronous Electron IPC method in a renderer process.
   */
  class IPCRendererSendSync extends DataFlow::MethodCallNode {
    DataFlow::Node channel;
    
    IPCRendererSendSync() {
      exists(IPCRenderer ipcRenderer |
        ipcRenderer.flowsTo(this.getReceiver()) and
        this.getCalleeName() = "sendSync" and
        this.getArgument(0) = channel
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
        wc.(DataFlow::PropRead).flowsTo(mc.getReceiver()) and
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
   * Holds if `pred` flows to `succ` via the Electron IPC channel `channel`
   */
  predicate ipcSimpleFlowStep(DataFlow::Node pred, DataFlow::Node succ, string channel) {
    exists(IPCRendererCallback callback |
      succ = callback.getParameter(1) and
      channel = callback.getChannelValue() and
      channel = pred.(IPCMainMessage).getChannelValue()
    )
    or
    exists(IPCMainCallback callback |
      succ = callback.getParameter(1) and
      channel = callback.getChannelValue() and
      channel = pred.(IPCRendererMessage).getChannelValue()
    )
    or
    exists(IPCRendererSendSync sendSync |
      succ = sendSync and
      channel = sendSync.getChannelValue() and
      channel = pred.(IPCMainSyncReplyMessage).getChannelValue()
    )
    or
    exists(IPCMainSendSync sendSync |
      succ = sendSync and
      channel = sendSync.getChannelValue() and
      channel = pred.(IPCRendererSyncReplyMessage).getChannelValue()
    )
    or
    exists(IPCRendererCallback callback |
      succ = callback.getParameter(1) and
      channel = callback.getChannelValue() and
      channel = pred.(WebContentsSendMessage).asExpr().getStringValue()
    )
  }
  
  /**
   * An additional flow step  via an Electron IPC message.
   */
  cached class IPCAdditionalFlowStep extends DataFlow::AdditionalFlowStep {
    cached IPCAdditionalFlowStep() {
      this instanceof IPCMainMessage or
      this instanceof IPCRendererMessage
    }
    
    cached override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      this = pred and
      ipcSimpleFlowStep(pred, succ, _)
    }
  }
}
