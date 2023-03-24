// Generated automatically from org.apache.sshd.common.channel.ChannelFactory for testing purposes

package org.apache.sshd.common.channel;

import java.util.Collection;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.session.Session;

public interface ChannelFactory extends NamedResource
{
    Channel createChannel(Session p0);
    static Channel createChannel(Session p0, Collection<? extends ChannelFactory> p1, String p2){ return null; }
}
