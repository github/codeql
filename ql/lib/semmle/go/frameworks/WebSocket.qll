/** Provides classes for working with WebSocket-related APIs. */

import go

/**
 * A function call that establishes a new WebSocket connection.
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
   * A function call that establishes a new WebSocket connection.
   *
   * Extend this class to model new APIs. If you want to refine existing
   * API models, extend `WebSocketRequestCall` instead.
   */
  abstract class Range extends DataFlow::CallNode {
    /** Gets the URL of the request. */
    abstract DataFlow::Node getRequestUrl();
  }

  /**
   * A call to the `Dial` function of the `golang.org/x/net/websocket` package.
   */
  private class GolangXNetDialFunc extends Range {
    GolangXNetDialFunc() {
      // func Dial(url_, protocol, origin string) (ws *Conn, err error)
      this.getTarget().hasQualifiedName(GolangOrgXNetWebsocket::packagePath(), "Dial")
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(0) }
  }

  /**
   * A call to the `DialConfig` function of the `golang.org/x/net/websocket` package.
   */
  private class GolangXNetDialConfigFunc extends Range {
    GolangXNetDialConfigFunc() {
      // func DialConfig(config *Config) (ws *Conn, err error)
      this.getTarget().hasQualifiedName(GolangOrgXNetWebsocket::packagePath(), "DialConfig")
    }

    override DataFlow::Node getRequestUrl() {
      exists(DataFlow::CallNode cn |
        // func NewConfig(server, origin string) (config *Config, err error)
        cn.getTarget().hasQualifiedName(GolangOrgXNetWebsocket::packagePath(), "NewConfig") and
        this.getArgument(0) = cn.getResult(0).getASuccessor*() and
        result = cn.getArgument(0)
      )
    }
  }

  /**
   * A call to the `Dialer` or `DialContext` function of the `github.com/gorilla/websocket` package.
   */
  private class GorillaWebSocketDialFunc extends Range {
    DataFlow::Node url;

    GorillaWebSocketDialFunc() {
      // func (d *Dialer) Dial(urlStr string, requestHeader http.Header) (*Conn, *http.Response, error)
      // func (d *Dialer) DialContext(ctx context.Context, urlStr string, requestHeader http.Header) (*Conn, *http.Response, error)
      exists(string name, Method f |
        f = this.getTarget() and
        f.hasQualifiedName(GorillaWebsocket::packagePath(), "Dialer", name)
      |
        name = "Dial" and this.getArgument(0) = url
        or
        name = "DialContext" and this.getArgument(1) = url
      )
    }

    override DataFlow::Node getRequestUrl() { result = url }
  }

  /**
   * A call to the `Dialer.Dial` method of the `github.com/gobwas/ws` package.
   */
  private class GobwasWsDialFunc extends Range {
    GobwasWsDialFunc() {
      //  func (d Dialer) Dial(ctx context.Context, urlstr string) (conn net.Conn, br *bufio.Reader, hs Handshake, err error)
      exists(Method m |
        m.hasQualifiedName(GobwasWs::packagePath(), "Dialer", "Dial") and
        m = this.getTarget()
      )
      or
      // func Dial(ctx context.Context, urlstr string) (net.Conn, *bufio.Reader, Handshake, error)
      this.getTarget().hasQualifiedName(GobwasWs::packagePath(), "Dial")
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(1) }
  }

  /**
   * A call to the `Dial` function of the `nhooyr.io/websocket` package.
   */
  private class NhooyrWebSocketDialFunc extends Range {
    NhooyrWebSocketDialFunc() {
      // func Dial(ctx context.Context, u string, opts *DialOptions) (*Conn, *http.Response, error)
      this.getTarget().hasQualifiedName(NhooyrWebSocket::packagePath(), "Dial")
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(1) }
  }

  /**
   * A call to the `BuildProxy` or `New` function of the `github.com/sacOO7/gowebsocket` package.
   */
  private class SacOO7DialFunc extends Range {
    SacOO7DialFunc() {
      // func BuildProxy(Url string) func(*http.Request) (*url.URL, error)
      // func New(url string) Socket
      this.getTarget()
          .hasQualifiedName(package("github.com/sacOO7/gowebsocket", ""), ["BuildProxy", "New"])
    }

    override DataFlow::Node getRequestUrl() { result = this.getArgument(0) }
  }
}

/**
 * A message written to a WebSocket, considered as a flow sink for reflected XSS.
 */
class WebSocketReaderAsSource extends UntrustedFlowSource::Range {
  WebSocketReaderAsSource() {
    exists(WebSocketReader r | this = r.getAnOutput().getNode(r.getACall()))
  }
}

/**
 * A function or a method which reads a message from a WebSocket connection.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `WebSocketReader::Range` instead.
 */
class WebSocketReader extends Function {
  WebSocketReader::Range self;

  WebSocketReader() { this = self }

  /** Gets an output of this function containing data that is read from a WebSocket connection. */
  FunctionOutput getAnOutput() { result = self.getAnOutput() }
}

/** Provides classes for working with messages read from a WebSocket. */
module WebSocketReader {
  /**
   * A function or a method which reads a message from a WebSocket connection
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `WebSocketReader` instead.
   */
  abstract class Range extends Function {
    /** Gets an output of this function containing data that is read from a WebSocket connection. */
    abstract FunctionOutput getAnOutput();
  }

  /**
   * The `Codec.Receive` method of the `golang.org/x/net/websocket` package.
   */
  private class GolangXNetCodecRecv extends Range, Method {
    GolangXNetCodecRecv() {
      // func (cd Codec) Receive(ws *Conn, v interface{}) (err error)
      this.hasQualifiedName(GolangOrgXNetWebsocket::packagePath(), "Codec", "Receive")
    }

    override FunctionOutput getAnOutput() { result.isParameter(1) }
  }

  /**
   * The `Conn.Read` method of the `golang.org/x/net/websocket` package.
   */
  private class GolangXNetConnRead extends Range, Method {
    GolangXNetConnRead() {
      // func (ws *Conn) Read(msg []byte) (n int, err error)
      this.hasQualifiedName(GolangOrgXNetWebsocket::packagePath(), "Conn", "Read")
    }

    override FunctionOutput getAnOutput() { result.isParameter(0) }
  }

  /**
   * The `Conn.Read` method of the `nhooyr.io/websocket` package.
   */
  private class NhooyrWebSocketRead extends Range, Method {
    NhooyrWebSocketRead() {
      // func (c *Conn) Read(ctx context.Context) (MessageType, []byte, error)
      this.hasQualifiedName(NhooyrWebSocket::packagePath(), "Conn", "Read")
    }

    override FunctionOutput getAnOutput() { result.isResult(1) }
  }

  /**
   * The `Conn.Reader` method of the `nhooyr.io/websocket` package.
   */
  private class NhooyrWebSocketReader extends Range, Method {
    NhooyrWebSocketReader() {
      // func (c *Conn) Reader(ctx context.Context) (MessageType, io.Reader, error)
      this.hasQualifiedName(NhooyrWebSocket::packagePath(), "Conn", "Reader")
    }

    override FunctionOutput getAnOutput() { result.isResult(1) }
  }

  /**
   * The `ReadFrame` function of the `github.com/gobwas/ws` package.
   */
  private class GobwasWsReadFrame extends Range {
    GobwasWsReadFrame() {
      // func ReadFrame(r io.Reader) (f Frame, err error)
      this.hasQualifiedName(GobwasWs::packagePath(), "ReadFrame")
    }

    override FunctionOutput getAnOutput() { result.isResult(0) }
  }

  /**
   * The `ReadHeader` function of the `github.com/gobwas/ws` package.
   */
  private class GobwasWsReadHeader extends Range {
    GobwasWsReadHeader() {
      // func ReadHeader(r io.Reader) (h Header, err error)
      this.hasQualifiedName(GobwasWs::packagePath(), "ReadHeader")
    }

    override FunctionOutput getAnOutput() { result.isResult(0) }
  }

  /**
   * The `ReadJson` function of the `github.com/gorilla/websocket` package.
   */
  private class GorillaWebSocketReadJson extends Range {
    GorillaWebSocketReadJson() {
      // func ReadJSON(c *Conn, v interface{}) error
      this.hasQualifiedName(GorillaWebsocket::packagePath(), "ReadJSON")
    }

    override FunctionOutput getAnOutput() { result.isParameter(1) }
  }

  /**
   * The `Conn.ReadJson` method of the `github.com/gorilla/websocket` package.
   */
  private class GorillaWebSocketConnReadJson extends Range, Method {
    GorillaWebSocketConnReadJson() {
      // func (c *Conn) ReadJSON(v interface{}) error
      this.hasQualifiedName(GorillaWebsocket::packagePath(), "Conn", "ReadJSON")
    }

    override FunctionOutput getAnOutput() { result.isParameter(0) }
  }

  /**
   * The `Conn.ReadMessage` method of the `github.com/gorilla/websocket` package.
   */
  private class GorillaWebSocketReadMessage extends Range, Method {
    GorillaWebSocketReadMessage() {
      // func (c *Conn) ReadMessage() (messageType int, p []byte, err error)
      this.hasQualifiedName(GorillaWebsocket::packagePath(), "Conn", "ReadMessage")
    }

    override FunctionOutput getAnOutput() { result.isResult(1) }
  }

  /**
   * The `ServerWebSocket.MessageReceive` method of the `github.com/revel/revel` package.
   */
  private class RevelServerWebSocketMessageReceive extends Range, Method {
    RevelServerWebSocketMessageReceive() {
      // func MessageReceive(v interface{}) error
      this.hasQualifiedName(Revel::packagePath(), "ServerWebSocket", "MessageReceive")
    }

    override FunctionOutput getAnOutput() { result.isParameter(0) }
  }

  /**
   * The `ServerWebSocket.MessageReceiveJSON` method of the `github.com/revel/revel` package.
   */
  private class RevelServerWebSocketMessageReceiveJSON extends Range, Method {
    RevelServerWebSocketMessageReceiveJSON() {
      // func MessageReceiveJSON(v interface{}) error
      this.hasQualifiedName(Revel::packagePath(), "ServerWebSocket", "MessageReceiveJSON")
    }

    override FunctionOutput getAnOutput() { result.isParameter(0) }
  }
}

/**
 * Provides classes for working with the [Gorilla WebSocket](https://github.com/gorilla/websocket)
 * package.
 */
module GorillaWebsocket {
  /** Gets the package name `github.com/gorilla/websocket`. */
  string packagePath() { result = package("github.com/gorilla", "websocket") }
}

/**
 * Provides classes for working with the
 * [golang.org/x/net/websocket](https://pkg.go.dev/golang.org/x/net/websocket) package.
 */
module GolangOrgXNetWebsocket {
  /** Gets the package name `golang.org/x/net/websocket`. */
  string packagePath() { result = package("golang.org/x/net", "websocket") }
}

/**
 * Provides classes for working with the [nhooyr.io/websocket](http://nhooyr.io/websocket)
 * package.
 */
module NhooyrWebSocket {
  /** Gets the package name `nhooyr.io/websocket/`. */
  string packagePath() { result = package("nhooyr.io/websocket", "") }
}

/**
 * Provides classes for working with the [ws](https://github.com/gobwas/ws) package.
 */
module GobwasWs {
  /** Gets the package name `github.com/gobwas/ws`. */
  string packagePath() { result = package("github.com/gobwas/ws", "") }
}
