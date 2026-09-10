package io.micronaut.websocket;

import java.util.Optional;
import java.util.Set;

public interface WebSocketSession {
    String getId();
    Set<? extends WebSocketSession> getOpenSessions();
    Optional<String> getCurrentRequest();
    boolean isOpen();
    boolean isSecure();
    void close();
}
