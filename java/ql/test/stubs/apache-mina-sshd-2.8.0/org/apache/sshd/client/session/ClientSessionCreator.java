// Generated automatically from org.apache.sshd.client.session.ClientSessionCreator for testing purposes

package org.apache.sshd.client.session;

import java.net.SocketAddress;
import org.apache.sshd.client.config.hosts.HostConfigEntry;
import org.apache.sshd.client.future.ConnectFuture;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public interface ClientSessionCreator
{
    ConnectFuture connect(HostConfigEntry p0, AttributeRepository p1, SocketAddress p2);
    ConnectFuture connect(String p0);
    ConnectFuture connect(String p0, SocketAddress p1, AttributeRepository p2, SocketAddress p3);
    ConnectFuture connect(String p0, String p1, int p2, AttributeRepository p3, SocketAddress p4);
    default ConnectFuture connect(HostConfigEntry p0){ return null; }
    default ConnectFuture connect(HostConfigEntry p0, AttributeRepository p1){ return null; }
    default ConnectFuture connect(HostConfigEntry p0, SocketAddress p1){ return null; }
    default ConnectFuture connect(String p0, SocketAddress p1){ return null; }
    default ConnectFuture connect(String p0, SocketAddress p1, AttributeRepository p2){ return null; }
    default ConnectFuture connect(String p0, SocketAddress p1, SocketAddress p2){ return null; }
    default ConnectFuture connect(String p0, String p1, int p2){ return null; }
    default ConnectFuture connect(String p0, String p1, int p2, AttributeRepository p3){ return null; }
    default ConnectFuture connect(String p0, String p1, int p2, SocketAddress p3){ return null; }
    static AttributeRepository.AttributeKey<SshdSocketAddress> TARGET_SERVER = null;
}
