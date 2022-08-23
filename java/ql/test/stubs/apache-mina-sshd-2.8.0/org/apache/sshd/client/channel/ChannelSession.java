// Generated automatically from org.apache.sshd.client.channel.ChannelSession for testing purposes

package org.apache.sshd.client.channel;

import java.io.InputStream;
import org.apache.sshd.client.channel.AbstractClientChannel;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.channel.RequestHandler;
import org.apache.sshd.common.util.buffer.Buffer;

public class ChannelSession extends AbstractClientChannel
{
    protected Closeable getInnerCloseable(){ return null; }
    protected RequestHandler.Result handleInternalRequest(String p0, boolean p1, Buffer p2){ return null; }
    protected RequestHandler.Result handleXonXoff(Buffer p0, boolean p1){ return null; }
    protected int securedRead(InputStream p0, int p1, byte[] p2, int p3, int p4){ return 0; }
    protected void closeImmediately0(){}
    protected void doOpen(){}
    protected void pumpInputStream(){}
    public ChannelSession(){}
}
