// Generated automatically from org.apache.sshd.common.forward.PortForwardingInformationProvider for testing purposes

package org.apache.sshd.common.forward;

import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public interface PortForwardingInformationProvider
{
    List<Map.Entry<Integer, SshdSocketAddress>> getRemoteForwardsBindings();
    List<Map.Entry<SshdSocketAddress, SshdSocketAddress>> getLocalForwardsBindings();
    List<SshdSocketAddress> getBoundLocalPortForwards(int p0);
    List<SshdSocketAddress> getStartedLocalPortForwards();
    NavigableSet<Integer> getStartedRemotePortForwards();
    SshdSocketAddress getBoundRemotePortForward(int p0);
    default boolean isLocalPortForwardingStartedForPort(int p0){ return false; }
    default boolean isRemotePortForwardingStartedForPort(int p0){ return false; }
}
