// Generated automatically from org.apache.sshd.common.session.UnknownChannelReferenceHandler for testing purposes

package org.apache.sshd.common.session;

import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.util.buffer.Buffer;

public interface UnknownChannelReferenceHandler
{
    Channel handleUnknownChannelCommand(ConnectionService p0, byte p1, int p2, Buffer p3);
}
