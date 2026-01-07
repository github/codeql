
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.PongMessage;
import org.springframework.web.socket.CloseStatus;


public class Test  {
    void sink(Object o) {}

    public class A extends TextWebSocketHandler {
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

        @Override 
        protected void handleTextMessage(WebSocketSession s, TextMessage m) {
            sink(s);  // $hasTaintFlow
            sink(m);  // $hasTaintFlow
            sink(m.asBytes()); // $hasTaintFlow
        }

        @Override 
        protected void handleBinaryMessage(WebSocketSession s, BinaryMessage m) {
            sink(s); // $hasTaintFlow
            sink(m); // $hasTaintFlow
        }

        @Override
        protected void handlePongMessage(WebSocketSession s, PongMessage m) {
            sink(s); // $hasTaintFlow
            sink(m); // $hasTaintFlow
        }

        @Override
        public void afterConnectionEstablished(WebSocketSession s) {
            sink(s); // $hasTaintFlow
        }

        @Override 
        public void afterConnectionClosed(WebSocketSession s, CloseStatus c) {
            sink(s); // $hasTaintFlow
        }

        @Override 
        public void handleTransportError(WebSocketSession s, Throwable exc) { 
            sink(s);  // $hasTaintFlow
        }

    }

}