// Generated automatically from org.apache.sshd.common.channel.AbstractChannel for testing purposes

package org.apache.sshd.common.channel;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;
import java.util.function.IntUnaryOperator;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.channel.ChannelListener;
import org.apache.sshd.common.channel.RequestHandler;
import org.apache.sshd.common.channel.Window;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolver;
import org.apache.sshd.common.future.DefaultCloseFuture;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.closeable.AbstractInnerCloseable;
import org.apache.sshd.common.util.io.functors.Invoker;
import org.apache.sshd.common.util.threads.CloseableExecutorService;
import org.apache.sshd.common.util.threads.ExecutorServiceCarrier;

abstract public class AbstractChannel extends AbstractInnerCloseable implements Channel, ExecutorServiceCarrier
{
    protected AbstractChannel() {}
    protected AbstractChannel(String p0, boolean p1){}
    protected AbstractChannel(String p0, boolean p1, Collection<? extends RequestHandler<Channel>> p2, CloseableExecutorService p3){}
    protected AbstractChannel(boolean p0){}
    protected AbstractChannel(boolean p0, Collection<? extends RequestHandler<Channel>> p1){}
    protected AtomicReference<AbstractChannel.GracefulState> gracefulState = null;
    protected Closeable getInnerCloseable(){ return null; }
    protected ConnectionService service = null;
    protected Date addPendingRequest(String p0, boolean p1){ return null; }
    protected Date removePendingRequest(String p0){ return null; }
    protected IoWriteFuture sendEof(){ return null; }
    protected IoWriteFuture sendResponse(Buffer p0, String p1, RequestHandler.Result p2, boolean p3){ return null; }
    protected RequestHandler.Result handleInternalRequest(String p0, boolean p1, Buffer p2){ return null; }
    protected abstract void doWriteData(byte[] p0, int p1, long p2);
    protected abstract void doWriteExtendedData(byte[] p0, int p1, long p2);
    protected final AtomicBoolean closeSignaled = null;
    protected final AtomicBoolean eofReceived = null;
    protected final AtomicBoolean eofSent = null;
    protected final AtomicBoolean initialized = null;
    protected final AtomicBoolean unregisterSignaled = null;
    protected final ChannelListener channelListenerProxy = null;
    protected final Collection<ChannelListener> channelListeners = null;
    protected final DefaultCloseFuture gracefulFuture = null;
    protected long validateIncomingDataSize(int p0, long p1){ return 0; }
    protected void configureWindow(){}
    protected void handleChannelRequest(String p0, boolean p1, Buffer p2){}
    protected void handleUnknownChannelRequest(String p0, boolean p1, Buffer p2){}
    protected void invokeChannelSignaller(Invoker<ChannelListener, Void> p0){}
    protected void notifyStateChanged(ChannelListener p0, String p1){}
    protected void notifyStateChanged(String p0){}
    protected void preClose(){}
    protected void sendWindowAdjust(long p0){}
    protected void setRecipient(int p0){}
    protected void signalChannelClosed(ChannelListener p0, Throwable p1){}
    protected void signalChannelInitialized(){}
    protected void signalChannelInitialized(ChannelListener p0){}
    protected void signalChannelOpenFailure(ChannelListener p0, Throwable p1){}
    protected void signalChannelOpenFailure(Throwable p0){}
    protected void signalChannelOpenSuccess(){}
    protected void signalChannelOpenSuccess(ChannelListener p0){}
    public <T> T computeAttributeIfAbsent(AttributeRepository.AttributeKey<T> p0, Function<? super AttributeRepository.AttributeKey<T>, ? extends T> p1){ return null; }
    public <T> T getAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    public <T> T removeAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    public <T> T setAttribute(AttributeRepository.AttributeKey<T> p0, T p1){ return null; }
    public ChannelListener getChannelListenerProxy(){ return null; }
    public ChannelStreamWriterResolver getChannelStreamWriterResolver(){ return null; }
    public ChannelStreamWriterResolver resolveChannelStreamWriterResolver(){ return null; }
    public CloseableExecutorService getExecutorService(){ return null; }
    public Collection<AttributeRepository.AttributeKey<? extends Object>> attributeKeys(){ return null; }
    public IoWriteFuture writePacket(Buffer p0){ return null; }
    public List<RequestHandler<Channel>> getRequestHandlers(){ return null; }
    public Map<String, Object> getProperties(){ return null; }
    public PropertyResolver getParentPropertyResolver(){ return null; }
    public Session getSession(){ return null; }
    public String toString(){ return null; }
    public Window getLocalWindow(){ return null; }
    public Window getRemoteWindow(){ return null; }
    public boolean isEofSent(){ return false; }
    public boolean isEofSignalled(){ return false; }
    public boolean isInitialized(){ return false; }
    public int getAttributesCount(){ return 0; }
    public int getId(){ return 0; }
    public int getRecipient(){ return 0; }
    public static IntUnaryOperator RESPONSE_BUFFER_GROWTH_FACTOR = null;
    public void addChannelListener(ChannelListener p0){}
    public void addRequestHandler(RequestHandler<Channel> p0){}
    public void clearAttributes(){}
    public void handleChannelRegistrationResult(ConnectionService p0, Session p1, int p2, boolean p3){}
    public void handleChannelUnregistration(ConnectionService p0){}
    public void handleClose(){}
    public void handleData(Buffer p0){}
    public void handleEof(){}
    public void handleExtendedData(Buffer p0){}
    public void handleFailure(){}
    public void handleRequest(Buffer p0){}
    public void handleSuccess(){}
    public void handleWindowAdjust(Buffer p0){}
    public void init(ConnectionService p0, Session p1, int p2){}
    public void removeChannelListener(ChannelListener p0){}
    public void removeRequestHandler(RequestHandler<Channel> p0){}
    public void setChannelStreamWriterResolver(ChannelStreamWriterResolver p0){}
    public void signalChannelClosed(Throwable p0){}
    static enum GracefulState
    {
        CloseReceived, CloseSent, Closed, Opened;
        private GracefulState() {}
    }
}
