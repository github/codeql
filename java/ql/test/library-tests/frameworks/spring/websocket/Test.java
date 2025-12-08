
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.WebSocketMessage;


public class Test extends TextWebSocketHandler {
    void sink(Object o) {}

    @Override
    public void handleMessage(WebSocketSession s, WebSocketMessage<?> m) {
        sink(s); // $hasTaintFlow
        sink(s.getAcceptedProtocol()); // $hasTaintFlow
        sink(s.getHandshakeHeaders()); // $hasTaintFlow
        sink(s.getPrincipal()); // $hasTaintFlow
        sink(s.getUri()); // $hasTaintFlow

        sink(m); // $hasTaintFlow
        sink(m.getPayload()); // $hasTaintFlow

    }
}