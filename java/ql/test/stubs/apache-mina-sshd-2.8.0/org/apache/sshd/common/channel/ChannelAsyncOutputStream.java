// Generated automatically from org.apache.sshd.common.channel.ChannelAsyncOutputStream for testing purposes

package org.apache.sshd.common.channel;

import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.channel.ChannelHolder;
import org.apache.sshd.common.channel.IoWriteFutureImpl;
import org.apache.sshd.common.future.CloseFuture;
import org.apache.sshd.common.io.IoOutputStream;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.closeable.AbstractCloseable;

public class ChannelAsyncOutputStream extends AbstractCloseable implements ChannelHolder, IoOutputStream
{
    protected ChannelAsyncOutputStream() {}
    protected Buffer createSendBuffer(Buffer p0, Channel p1, long p2){ return null; }
    protected CloseFuture doCloseGracefully(){ return null; }
    protected void doWriteIfPossible(boolean p0){}
    protected void onWritten(IoWriteFutureImpl p0, int p1, long p2, IoWriteFuture p3){}
    protected void preClose(){}
    public Channel getChannel(){ return null; }
    public ChannelAsyncOutputStream(Channel p0, byte p1){}
    public ChannelAsyncOutputStream(Channel p0, byte p1, boolean p2){}
    public IoWriteFuture writeBuffer(Buffer p0){ return null; }
    public String toString(){ return null; }
    public boolean isSendChunkIfRemoteWindowIsSmallerThanPacketSize(){ return false; }
    public byte getCommandType(){ return 0; }
    public void onWindowExpanded(){}
    public void setSendChunkIfRemoteWindowIsSmallerThanPacketSize(boolean p0){}
}
