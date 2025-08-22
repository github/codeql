// Generated automatically from org.apache.hc.core5.reactor.IOSession for testing purposes

package org.apache.hc.core5.reactor;

import java.net.SocketAddress;
import java.nio.channels.ByteChannel;
import java.util.concurrent.locks.Lock;
import org.apache.hc.core5.http.SocketModalCloseable;
import org.apache.hc.core5.reactor.Command;
import org.apache.hc.core5.reactor.IOEventHandler;
import org.apache.hc.core5.util.Identifiable;
import org.apache.hc.core5.util.Timeout;

public interface IOSession extends ByteChannel, Identifiable, SocketModalCloseable
{
    ByteChannel channel();
    Command poll();
    IOEventHandler getHandler();
    IOSession.Status getStatus();
    Lock getLock();
    SocketAddress getLocalAddress();
    SocketAddress getRemoteAddress();
    Timeout getSocketTimeout();
    boolean hasCommands();
    int getEventMask();
    long getLastEventTime();
    long getLastReadTime();
    long getLastWriteTime();
    static public enum Status
    {
        ACTIVE, CLOSED, CLOSING;
        private Status() {}
    }
    void clearEvent(int p0);
    void close();
    void enqueue(Command p0, Command.Priority p1);
    void setEvent(int p0);
    void setEventMask(int p0);
    void setSocketTimeout(Timeout p0);
    void updateReadTime();
    void updateWriteTime();
    void upgrade(IOEventHandler p0);
}
