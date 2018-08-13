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
      this.asExpr().getType().hasUnderlyingType("electron", "BrowserWindow")
    }
  }
  
  /**
   * A data flow node with a TypeScript type indicating it is an Electron `BrowserView`
   */
  class TypedBrowserView extends BrowserObject {
    TypedBrowserView() {
      this.asExpr().getType().hasUnderlyingType("electron", "BrowserView")
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
  
  module IPC {
    /**
     * A data flow node that imports `electron.ipcMain`.
     */
    class Main extends DataFlow::SourceNode {
      Main() {
        this = DataFlow::moduleMember("electron", "ipcMain")
      }
    }
    
    /**
     * A data flow node that is registered as an Electron IPC callback in the main process.
     */
    class MainCallback extends DataFlow::FunctionNode {
      DataFlow::Node channel;
      
      MainCallback() {
        exists(Main ipcMain, DataFlow::MethodCallNode mc |
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
    abstract class MainMessage extends DataFlow::ValueNode {
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
    class MainSentMessage extends MainMessage {
      DataFlow::Node channel;
      
      MainSentMessage() {
        exists(Main ipcMain, DataFlow::MethodCallNode mc |
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
    class MainAsyncReplyMessage extends MainMessage {
      DataFlow::Node channel;
      
      MainAsyncReplyMessage() {
        exists(MainCallback callback, DataFlow::MethodCallNode mc |
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
    class MainSyncReplyMessage extends DataFlow::Node {
      DataFlow::Node channel;
      
      MainSyncReplyMessage() {
        exists(MainCallback callback |
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
    class MainSendSync extends DataFlow::MethodCallNode {
      DataFlow::Node channel;
      
      MainSendSync() {
        exists(Main ipcMain |
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
    class Renderer extends DataFlow::SourceNode {
      Renderer() {
        this = DataFlow::moduleMember("electron", "ipcRenderer")
      }
    }
    
    /**
     * A data flow node that is registered as an Electron IPC callback in the renderer process.
     */
    class RendererCallback extends DataFlow::FunctionNode {
      DataFlow::Node channel;
      
      RendererCallback() {
        exists(Renderer ipcRenderer, DataFlow::MethodCallNode mc |
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
    abstract class RendererMessage extends DataFlow::ValueNode {
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
    class RendererSentMessage extends RendererMessage {
      DataFlow::Node channel;
      
      RendererSentMessage() {
        exists(Renderer ipcRenderer, DataFlow::MethodCallNode mc |
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
    class RendererAsyncReplyMessage extends RendererMessage {
      DataFlow::Node channel;
      
      RendererAsyncReplyMessage() {
        exists(RendererCallback callback, DataFlow::MethodCallNode mc |
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
    class RendererSyncReplyMessage extends DataFlow::Node {
      DataFlow::Node channel;
      
      RendererSyncReplyMessage() {
        exists(RendererCallback callback |
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
    class RendererSendSync extends DataFlow::MethodCallNode {
      DataFlow::Node channel;
      
      RendererSendSync() {
        exists(Renderer ipcRenderer |
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
    class WebContentsSendMessage extends MainMessage {
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
    predicate simpleFlowStep(DataFlow::Node pred, DataFlow::Node succ, string channel) {
      // match a message sent from the main thread with a callback parameter in the renderer thread
      exists(RendererCallback callback |
        succ = callback.getParameter(1) and
        channel = callback.getChannelValue() and
        channel = pred.(MainMessage).getChannelValue()
      )
      or
      // match a message sent from the renderer thread with a callback parameter in the main thread
      exists(MainCallback callback |
        succ = callback.getParameter(1) and
        channel = callback.getChannelValue() and
        channel = pred.(RendererMessage).getChannelValue()
      )
      or
      // match a synchronous reply sent from the main thread with a `sendSync` call in the renderer thread
      exists(RendererSendSync sendSync |
        succ = sendSync and
        channel = sendSync.getChannelValue() and
        channel = pred.(MainSyncReplyMessage).getChannelValue()
      )
      or
      // match a synchronous reply sent from the renderer thread with a `sendSync` call in the main thread
      exists(MainSendSync sendSync |
        succ = sendSync and
        channel = sendSync.getChannelValue() and
        channel = pred.(RendererSyncReplyMessage).getChannelValue()
      )
    }
    
    /**
     * An additional flow step  via an Electron IPC message.
     */
    class IPCAdditionalFlowStep extends DataFlow::AdditionalFlowStep {
      IPCAdditionalFlowStep() {
        this instanceof MainMessage or
        this instanceof RendererMessage
      }
      
      override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
        this = pred and
        simpleFlowStep(pred, succ, _)
      }
    }
}
}

