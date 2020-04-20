/** Provides classes for working with WebSocket-related APIs. */

import go

/**
 * A data-flow node that establishes a new WebSocket connection.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `WebSocketRequestCall::Range` instead.
 */
class WebSocketRequestCall extends DataFlow::CallNode {
  WebSocketRequestCall::Range self;

  WebSocketRequestCall() { this = self }

  /** Gets the URL of the request. */
  DataFlow::Node getRequestUrl() { result = self.getRequestUrl() }
}

/** Provides classes for working with WebSocket request functions. */
module WebSocketRequestCall {
  /**
   * A data-flow node that establishes a new WebSocket connection.
   *
   * Extend this class to model new APIs. If you want to refine existing
   * API models, extend `WebSocketRequestCall` instead.
   */
  abstract class Range extends DataFlow::CallNode {
    /** Gets the URL of the request. */
    abstract DataFlow::Node getRequestUrl();
  }

  /**
   * A WebSocket request expression string used in an API function of the
   * `golang.org/x/net/websocket` package.
   */
  private class GolangXNetDialFunc extends Range {
    GolangXNetDialFunc() {
      // func Dial(url_, protocol, origin string) (ws *Conn, err error)
      this.getTarget().hasQualifiedName(package("golang.org/x/net", "websocket"), "Dial")
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(0) }
  }

  /**
   * A WebSocket DialConfig expression string used in an API function
   * of the `golang.org/x/net/websocket` package.
   */
  private class GolangXNetDialConfigFunc extends Range {
    GolangXNetDialConfigFunc() {
      // func DialConfig(config *Config) (ws *Conn, err error)
      this.getTarget().hasQualifiedName(package("golang.org/x/net", "websocket"), "DialConfig")
    }

    override DataFlow::Node getRequestUrl() {
      exists(DataFlow::CallNode cn |
        // func NewConfig(server, origin string) (config *Config, err error)
        cn.getTarget().hasQualifiedName(package("golang.org/x/net", "websocket"), "NewConfig") and
        this.getArgument(0) = cn.getResult(0).getASuccessor*() and
        result = cn.getArgument(0)
      )
    }
  }

  /**
   * A WebSocket request expression string used in an API function
   * of the `github.com/gorilla/websocket` package.
   */
  private class GorillaWebsocketDialFunc extends Range {
    DataFlow::Node url;

    GorillaWebsocketDialFunc() {
      // func (d *Dialer) Dial(urlStr string, requestHeader http.Header) (*Conn, *http.Response, error)
      // func (d *Dialer) DialContext(ctx context.Context, urlStr string, requestHeader http.Header) (*Conn, *http.Response, error)
      exists(string name, Method f |
        f = this.getTarget() and
        f.hasQualifiedName(package("github.com/gorilla", "websocket"), "Dialer", name)
      |
        name = "Dial" and this.getArgument(0) = url
        or
        name = "DialContext" and this.getArgument(1) = url
      )
    }

    override DataFlow::Node getRequestUrl() { result = url }
  }

  /**
   * A WebSocket request expression string used in an API function
   * of the `github.com/gobwas/ws` package.
   */
  private class GobwasWsDialFunc extends Range {
    GobwasWsDialFunc() {
      //  func (d Dialer) Dial(ctx context.Context, urlstr string) (conn net.Conn, br *bufio.Reader, hs Handshake, err error)
      exists(Method m |
        m.hasQualifiedName(package("github.com/gobwas", "ws"), "Dialer", "Dial") and
        m = this.getTarget()
      )
      or
      // func Dial(ctx context.Context, urlstr string) (net.Conn, *bufio.Reader, Handshake, error)
      this.getTarget().hasQualifiedName(package("github.com/gobwas", "ws"), "Dial")
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(1) }
  }

  /**
   * A WebSocket request expression string used in an API function
   * of the `nhooyr.io/websocket` package.
   */
  private class NhooyrWebsocketDialFunc extends Range {
    NhooyrWebsocketDialFunc() {
      // func Dial(ctx context.Context, u string, opts *DialOptions) (*Conn, *http.Response, error)
      this.getTarget().hasQualifiedName(package("nhooyr.io", "websocket"), "Dial")
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(1) }
  }

  /**
   * A WebSocket request expression string used in an API function
   * of the `github.com/sacOO7/gowebsocket` package.
   */
  private class SacOO7DialFunc extends Range {
    SacOO7DialFunc() {
      // func BuildProxy(Url string) func(*http.Request) (*url.URL, error)
      // func New(url string) Socket
      this.getTarget().hasQualifiedName("github.com/sacOO7/gowebsocket", ["New", "BuildProxy"])
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(0) }
  }
}
