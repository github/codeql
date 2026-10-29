// Generated automatically from org.apache.sshd.client.config.hosts.HostConfigEntryResolver for testing purposes

package org.apache.sshd.client.config.hosts;

import java.net.SocketAddress;
import org.apache.sshd.client.config.hosts.HostConfigEntry;
import org.apache.sshd.common.AttributeRepository;

public interface HostConfigEntryResolver
{
    HostConfigEntry resolveEffectiveHost(String p0, int p1, SocketAddress p2, String p3, String p4, AttributeRepository p5);
    static HostConfigEntryResolver EMPTY = null;
}
