// Generated automatically from org.apache.sshd.common.io.IoServiceEventListener for testing purposes

package org.apache.sshd.common.io;

import java.net.SocketAddress;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.io.IoAcceptor;
import org.apache.sshd.common.io.IoConnector;
import org.apache.sshd.common.util.SshdEventListener;

public interface IoServiceEventListener extends SshdEventListener
{
    default void abortAcceptedConnection(IoAcceptor p0, SocketAddress p1, SocketAddress p2, SocketAddress p3, Throwable p4){}
    default void abortEstablishedConnection(IoConnector p0, SocketAddress p1, AttributeRepository p2, SocketAddress p3, Throwable p4){}
    default void connectionAccepted(IoAcceptor p0, SocketAddress p1, SocketAddress p2, SocketAddress p3){}
    default void connectionEstablished(IoConnector p0, SocketAddress p1, AttributeRepository p2, SocketAddress p3){}
}
