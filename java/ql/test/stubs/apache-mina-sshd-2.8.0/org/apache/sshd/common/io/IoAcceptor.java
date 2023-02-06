// Generated automatically from org.apache.sshd.common.io.IoAcceptor for testing purposes

package org.apache.sshd.common.io;

import java.net.SocketAddress;
import java.util.Collection;
import java.util.Set;
import org.apache.sshd.common.io.IoService;

public interface IoAcceptor extends IoService
{
    Set<SocketAddress> getBoundAddresses();
    void bind(Collection<? extends SocketAddress> p0);
    void bind(SocketAddress p0);
    void unbind();
    void unbind(Collection<? extends SocketAddress> p0);
    void unbind(SocketAddress p0);
}
