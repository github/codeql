// Generated automatically from org.apache.sshd.client.channel.AbstractClientChannel for testing purposes

package org.apache.sshd.client.channel;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collection;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import org.apache.sshd.client.channel.ClientChannel;
import org.apache.sshd.client.channel.ClientChannelEvent;
import org.apache.sshd.client.future.OpenFuture;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.channel.AbstractChannel;
import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.channel.ChannelAsyncInputStream;
import org.apache.sshd.common.channel.ChannelAsyncOutputStream;
import org.apache.sshd.common.channel.RequestHandler;
import org.apache.sshd.common.channel.StreamingChannel;
import org.apache.sshd.common.io.IoInputStream;
import org.apache.sshd.common.io.IoOutputStream;
import org.apache.sshd.common.util.EventNotifier;
import org.apache.sshd.common.util.buffer.Buffer;

abstract public class AbstractClientChannel extends AbstractChannel implements ClientChannel
{
    protected AbstractClientChannel() {}
    protected <C extends Collection<ClientChannelEvent>> C updateCurrentChannelState(C p0){ return null; }
    protected AbstractClientChannel(String p0){}
    protected AbstractClientChannel(String p0, Collection<? extends RequestHandler<Channel>> p1){}
    protected ChannelAsyncInputStream asyncErr = null;
    protected ChannelAsyncInputStream asyncOut = null;
    protected ChannelAsyncOutputStream asyncIn = null;
    protected Closeable getInnerCloseable(){ return null; }
    protected InputStream in = null;
    protected InputStream invertedErr = null;
    protected InputStream invertedOut = null;
    protected OpenFuture openFuture = null;
    protected OutputStream err = null;
    protected OutputStream invertedIn = null;
    protected OutputStream out = null;
    protected StreamingChannel.Streaming streaming = null;
    protected String openFailureLang = null;
    protected String openFailureMsg = null;
    protected abstract void doOpen();
    protected final AtomicBoolean opened = null;
    protected final AtomicReference<Integer> exitStatusHolder = null;
    protected final AtomicReference<String> exitSignalHolder = null;
    protected int openFailureReason = 0;
    protected void addChannelSignalRequestHandlers(EventNotifier<String> p0){}
    protected void doWriteData(byte[] p0, int p1, long p2){}
    protected void doWriteExtendedData(byte[] p0, int p1, long p2){}
    public InputStream getIn(){ return null; }
    public InputStream getInvertedErr(){ return null; }
    public InputStream getInvertedOut(){ return null; }
    public Integer getExitStatus(){ return null; }
    public IoInputStream getAsyncErr(){ return null; }
    public IoInputStream getAsyncOut(){ return null; }
    public IoOutputStream getAsyncIn(){ return null; }
    public OpenFuture open(){ return null; }
    public OpenFuture open(int p0, long p1, long p2, Buffer p3){ return null; }
    public OutputStream getErr(){ return null; }
    public OutputStream getInvertedIn(){ return null; }
    public OutputStream getOut(){ return null; }
    public Set<ClientChannelEvent> getChannelState(){ return null; }
    public Set<ClientChannelEvent> waitFor(Collection<ClientChannelEvent> p0, long p1){ return null; }
    public StreamingChannel.Streaming getStreaming(){ return null; }
    public String getChannelType(){ return null; }
    public String getExitSignal(){ return null; }
    public void handleOpenFailure(Buffer p0){}
    public void handleOpenSuccess(int p0, long p1, long p2, Buffer p3){}
    public void handleWindowAdjust(Buffer p0){}
    public void setErr(OutputStream p0){}
    public void setIn(InputStream p0){}
    public void setOut(OutputStream p0){}
    public void setStreaming(StreamingChannel.Streaming p0){}
}
