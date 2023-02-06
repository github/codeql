// Generated automatically from org.apache.sshd.common.channel.ChannelAsyncInputStream for testing purposes

package org.apache.sshd.common.channel;

import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.channel.ChannelHolder;
import org.apache.sshd.common.future.CloseFuture;
import org.apache.sshd.common.io.IoInputStream;
import org.apache.sshd.common.io.IoReadFuture;
import org.apache.sshd.common.util.Readable;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.closeable.AbstractCloseable;

public class ChannelAsyncInputStream extends AbstractCloseable implements ChannelHolder, IoInputStream
{
    protected ChannelAsyncInputStream() {}
    protected CloseFuture doCloseGracefully(){ return null; }
    protected void preClose(){}
    public Channel getChannel(){ return null; }
    public ChannelAsyncInputStream(Channel p0){}
    public IoReadFuture read(Buffer p0){ return null; }
    public String toString(){ return null; }
    public void write(Readable p0){}
}
