// Generated automatically from org.apache.sshd.common.channel.ChannelListener for testing purposes

package org.apache.sshd.common.channel;

import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.util.SshdEventListener;

public interface ChannelListener extends SshdEventListener
{
    default void channelClosed(Channel p0, Throwable p1){}
    default void channelInitialized(Channel p0){}
    default void channelOpenFailure(Channel p0, Throwable p1){}
    default void channelOpenSuccess(Channel p0){}
    default void channelStateChanged(Channel p0, String p1){}
    static <L extends ChannelListener> L validateListener(L p0){ return null; }
    static ChannelListener EMPTY = null;
}
