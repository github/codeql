import io.micronaut.websocket.annotation.*;
import io.micronaut.websocket.WebSocketSession;

@ServerWebSocket("/chat/{room}")
class MicronautWebSocketTest {

    void sink(Object o) {}

    @OnMessage
    void onMessage(String message, WebSocketSession session) {
        sink(message); // $hasTaintFlow
    }

    @OnOpen
    void onOpen(String room, WebSocketSession session) {
        sink(room); // $hasTaintFlow
    }
}
