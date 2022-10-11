// Generated automatically from org.apache.sshd.common.forward.PortForwardingEventListenerManagerHolder for testing purposes

package org.apache.sshd.common.forward;

import java.util.Collection;
import org.apache.sshd.common.forward.PortForwardingEventListenerManager;

public interface PortForwardingEventListenerManagerHolder
{
    Collection<PortForwardingEventListenerManager> getRegisteredManagers();
    boolean addPortForwardingEventListenerManager(PortForwardingEventListenerManager p0);
    boolean removePortForwardingEventListenerManager(PortForwardingEventListenerManager p0);
}
