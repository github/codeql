// Generated automatically from org.apache.sshd.common.channel.ChannelListenerManager for testing purposes

package org.apache.sshd.common.channel;

import org.apache.sshd.common.channel.ChannelListener;

public interface ChannelListenerManager
{
    ChannelListener getChannelListenerProxy();
    void addChannelListener(ChannelListener p0);
    void removeChannelListener(ChannelListener p0);
}
