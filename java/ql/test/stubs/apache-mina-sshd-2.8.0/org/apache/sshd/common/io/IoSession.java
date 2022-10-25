// Generated automatically from org.apache.sshd.common.io.IoSession for testing purposes

package org.apache.sshd.common.io;

import java.net.SocketAddress;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.future.CloseFuture;
import org.apache.sshd.common.io.IoService;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.net.ConnectionEndpointsIndicator;

public interface IoSession extends Closeable, ConnectionEndpointsIndicator
{
    CloseFuture close(boolean p0);
    IoService getService();
    IoWriteFuture writeBuffer(Buffer p0);
    Object getAttribute(Object p0);
    Object removeAttribute(Object p0);
    Object setAttribute(Object p0, Object p1);
    Object setAttributeIfAbsent(Object p0, Object p1);
    SocketAddress getAcceptanceAddress();
    default void resumeRead(){}
    default void suspendRead(){}
    long getId();
    void shutdownOutputStream();
}
