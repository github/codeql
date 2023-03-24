// Generated automatically from org.apache.sshd.common.channel.throttle.ChannelStreamWriter for testing purposes

package org.apache.sshd.common.channel.throttle;

import java.nio.channels.Channel;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.util.buffer.Buffer;

public interface ChannelStreamWriter extends Channel
{
    IoWriteFuture writeData(Buffer p0);
}
