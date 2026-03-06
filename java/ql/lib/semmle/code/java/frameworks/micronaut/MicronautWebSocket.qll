/** Provides classes for identifying Micronaut WebSocket endpoints. */
overlay[local?]
module;

import java

/**
 * The annotation type `@ServerWebSocket` from `io.micronaut.websocket.annotation`.
 */
class MicronautServerWebSocketAnnotation extends AnnotationType {
  MicronautServerWebSocketAnnotation() {
    this.hasQualifiedName("io.micronaut.websocket.annotation", "ServerWebSocket")
  }
}

/**
 * A class annotated with `@ServerWebSocket`, representing a Micronaut WebSocket endpoint.
 */
class MicronautServerWebSocketClass extends Class {
  MicronautServerWebSocketClass() {
    this.getAnAnnotation().getType() instanceof MicronautServerWebSocketAnnotation
  }
}

/** An annotation type for Micronaut WebSocket message handler methods. */
class MicronautWebSocketHandlerAnnotation extends AnnotationType {
  MicronautWebSocketHandlerAnnotation() {
    this.getPackage().hasName("io.micronaut.websocket.annotation") and
    this.hasName(["OnMessage", "OnOpen"])
  }
}

/**
 * A method on a Micronaut `@ServerWebSocket` class that handles WebSocket messages.
 */
class MicronautWebSocketMessageHandler extends Method {
  MicronautWebSocketMessageHandler() {
    this.getDeclaringType() instanceof MicronautServerWebSocketClass and
    this.getAnAnnotation().getType() instanceof MicronautWebSocketHandlerAnnotation
  }
}

/** A parameter of a Micronaut WebSocket message handler that receives user-controlled data. */
class MicronautWebSocketParameter extends Parameter {
  MicronautWebSocketParameter() {
    this.getCallable() instanceof MicronautWebSocketMessageHandler and
    // Exclude WebSocketSession parameters
    not this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("io.micronaut.websocket", "WebSocketSession")
  }
}
