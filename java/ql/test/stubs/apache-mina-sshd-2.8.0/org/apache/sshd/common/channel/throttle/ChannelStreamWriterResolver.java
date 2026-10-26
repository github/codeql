// Generated automatically from org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolver for testing purposes

package org.apache.sshd.common.channel.throttle;

import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriter;

public interface ChannelStreamWriterResolver
{
    ChannelStreamWriter resolveChannelStreamWriter(Channel p0, byte p1);
    static ChannelStreamWriterResolver NONE = null;
}
