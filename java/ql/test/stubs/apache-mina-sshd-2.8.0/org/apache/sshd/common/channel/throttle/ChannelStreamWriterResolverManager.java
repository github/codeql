// Generated automatically from org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolverManager for testing purposes

package org.apache.sshd.common.channel.throttle;

import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriter;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolver;

public interface ChannelStreamWriterResolverManager extends ChannelStreamWriterResolver
{
    ChannelStreamWriterResolver getChannelStreamWriterResolver();
    default ChannelStreamWriter resolveChannelStreamWriter(Channel p0, byte p1){ return null; }
    default ChannelStreamWriterResolver resolveChannelStreamWriterResolver(){ return null; }
    void setChannelStreamWriterResolver(ChannelStreamWriterResolver p0);
}
