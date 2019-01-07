import javascript

module Electron {
  /**
   * A data flow node that is an Electron `webPreferences` property.
   */
  class WebPreferences extends DataFlow::ObjectLiteralNode {
    WebPreferences() {
      exists(BrowserObject bo | this = bo.getOptionArgument(0, "webPreferences").getALocalSource())
    }
  }
  
  /**
   * A data flow node that creates a new `BrowserWindow` or `BrowserView`.
   */
  private abstract class BrowserObject extends DataFlow::NewNode {
  }
  
  /**
   * A data flow node that creates a new `BrowserWindow`.
   */
  class BrowserWindow extends BrowserObject {
    BrowserWindow() {
      this = DataFlow::moduleMember("electron", "BrowserWindow").getAnInstantiation()
    }
  }
  
  /**
   * A data flow node that creates a new `BrowserView`.
   */
  class BrowserView extends BrowserObject {
    BrowserView() {
      this = DataFlow::moduleMember("electron", "BrowserView").getAnInstantiation()
    }
  }

  /**
   * A Node.js-style HTTP or HTTPS request made using an Electron module.
   */
  abstract class CustomElectronClientRequest extends NodeJSLib::CustomNodeJSClientRequest {}

  /**
   * A Node.js-style HTTP or HTTPS request made using an Electron module.
   */
  class ElectronClientRequest extends NodeJSLib::NodeJSClientRequest {

    ElectronClientRequest() {
      this instanceof CustomElectronClientRequest
    }

  }

  /**
   * A Node.js-style HTTP or HTTPS request made using `electron.ClientRequest`.
   */
  private class NewClientRequest extends CustomElectronClientRequest {
    NewClientRequest() {
      this = DataFlow::moduleMember("electron", "ClientRequest").getAnInstantiation() or
      this = DataFlow::moduleMember("electron", "net").getAMemberCall("request") // alias
    }

    override DataFlow::Node getUrl() {
      result = getArgument(0) or
      result = getOptionArgument(0, "url")
    }

    override DataFlow::Node getHost() {
      exists (string name |
        name = "host" or
        name = "hostname" |
        result = getOptionArgument(0, name)
      )
    }

    override DataFlow::Node getADataNode() {
      exists (string name |
        name = "write" or name = "end" |
        result =this.(DataFlow::SourceNode).getAMethodCall(name).getArgument(0)
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
    
    override string getSourceType() {
      result = "ElectronClientRequest redirect event"
    }
  }
}