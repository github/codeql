// Generated automatically from org.apache.sshd.common.session.Session for testing purposes

package org.apache.sshd.common.session;

import java.net.SocketAddress;
import java.time.Duration;
import java.time.Instant;
import java.util.concurrent.TimeUnit;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.FactoryManagerHolder;
import org.apache.sshd.common.Service;
import org.apache.sshd.common.auth.MutableUserHolder;
import org.apache.sshd.common.channel.ChannelListenerManager;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolverManager;
import org.apache.sshd.common.forward.PortForwardingEventListenerManager;
import org.apache.sshd.common.forward.PortForwardingInformationProvider;
import org.apache.sshd.common.future.KeyExchangeFuture;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.kex.KexFactoryManager;
import org.apache.sshd.common.kex.KeyExchange;
import org.apache.sshd.common.session.ReservedSessionMessagesManager;
import org.apache.sshd.common.session.SessionContext;
import org.apache.sshd.common.session.SessionDisconnectHandlerManager;
import org.apache.sshd.common.session.SessionListenerManager;
import org.apache.sshd.common.session.UnknownChannelReferenceHandlerManager;
import org.apache.sshd.common.session.helpers.TimeoutIndicator;
import org.apache.sshd.common.util.buffer.Buffer;

public interface Session extends ChannelListenerManager, ChannelStreamWriterResolverManager, FactoryManagerHolder, KexFactoryManager, MutableUserHolder, PortForwardingEventListenerManager, PortForwardingInformationProvider, ReservedSessionMessagesManager, SessionContext, SessionDisconnectHandlerManager, SessionListenerManager, UnknownChannelReferenceHandlerManager
{
    <T extends Service> T getService(Class<T> p0);
    Buffer createBuffer(byte p0, int p1);
    Buffer prepareBuffer(byte p0, Buffer p1);
    Buffer request(String p0, Buffer p1, long p2);
    Duration getAuthTimeout();
    Duration getIdleTimeout();
    Instant getAuthTimeoutStart();
    Instant getIdleTimeoutStart();
    Instant resetAuthTimeout();
    Instant resetIdleTimeout();
    IoSession getIoSession();
    IoWriteFuture sendDebugMessage(boolean p0, Object p1, String p2);
    IoWriteFuture sendIgnoreMessage(byte... p0);
    IoWriteFuture writePacket(Buffer p0);
    IoWriteFuture writePacket(Buffer p0, long p1, TimeUnit p2);
    KeyExchange getKex();
    KeyExchangeFuture reExchangeKeys();
    TimeoutIndicator getTimeoutStatus();
    default <T> T resolveAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    default Buffer createBuffer(byte p0){ return null; }
    default Buffer request(String p0, Buffer p1, Duration p2){ return null; }
    default Buffer request(String p0, Buffer p1, long p2, TimeUnit p3){ return null; }
    default IoWriteFuture writePacket(Buffer p0, Duration p1){ return null; }
    default IoWriteFuture writePacket(Buffer p0, long p1){ return null; }
    default SocketAddress getLocalAddress(){ return null; }
    default SocketAddress getRemoteAddress(){ return null; }
    static <T> T resolveAttribute(Session p0, AttributeRepository.AttributeKey<T> p1){ return null; }
    void disconnect(int p0, String p1);
    void exceptionCaught(Throwable p0);
    void setAuthenticated();
    void startService(String p0, Buffer p1);
}
