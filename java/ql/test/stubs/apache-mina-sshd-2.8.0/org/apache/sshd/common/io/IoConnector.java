// Generated automatically from org.apache.sshd.common.io.IoConnector for testing purposes

package org.apache.sshd.common.io;

import java.net.SocketAddress;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.io.IoConnectFuture;
import org.apache.sshd.common.io.IoService;

public interface IoConnector extends IoService
{
    IoConnectFuture connect(SocketAddress p0, AttributeRepository p1, SocketAddress p2);
}
