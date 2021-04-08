/**
 * Provides classes for identifying methods called by the Java SE WebSocket package.
 */

import java

/** The `java.net.http.Websocket.Listener` interface. */
class WebsocketListener extends Interface {
  WebsocketListener() { this.hasQualifiedName("java.net.http", "WebSocket$Listener") }
}

/** The method `onText` on a type that implements the `java.net.http.Websocket.Listener` interface. */
class WebsocketOnText extends Method {
  WebsocketOnText() {
    exists(WebsocketListener l |
      this.getDeclaringType().extendsOrImplements(l) and
      // onText(WebSocket webSocket, CharSequence data, boolean last)
      this.hasName("onText")
    )
  }
}
