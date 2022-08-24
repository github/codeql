// Generated automatically from org.apache.sshd.common.session.helpers.SessionHelper for testing purposes

package org.apache.sshd.common.session.helpers;

import java.net.SocketAddress;
import java.time.Duration;
import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolver;
import org.apache.sshd.common.digest.Digest;
import org.apache.sshd.common.forward.Forwarder;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.kex.AbstractKexFactoryManager;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.random.Random;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.ReservedSessionMessagesHandler;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionDisconnectHandler;
import org.apache.sshd.common.session.SessionListener;
import org.apache.sshd.common.session.UnknownChannelReferenceHandler;
import org.apache.sshd.common.session.helpers.TimeoutIndicator;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.io.functors.Invoker;
import org.apache.sshd.common.util.net.SshdSocketAddress;

abstract public class SessionHelper extends AbstractKexFactoryManager implements Session
{
    protected SessionHelper() {}
    protected Buffer preProcessEncodeBuffer(int p0, Buffer p1){ return null; }
    protected Forwarder getForwarder(){ return null; }
    protected Instant authStart = null;
    protected Instant idleStart = null;
    protected IoWriteFuture sendIdentification(String p0, List<String> p1){ return null; }
    protected IoWriteFuture sendNotImplemented(long p0){ return null; }
    protected List<String> doReadIdentification(Buffer p0, boolean p1){ return null; }
    protected Map<KexProposalOption, String> createProposal(String p0){ return null; }
    protected Map<KexProposalOption, String> mergeProposals(Map<KexProposalOption, String> p0, Map<KexProposalOption, String> p1){ return null; }
    protected ReservedSessionMessagesHandler resolveReservedSessionMessagesHandler(){ return null; }
    protected SessionHelper(boolean p0, FactoryManager p1, IoSession p2){}
    protected SocketAddress resolvePeerAddress(SocketAddress p0){ return null; }
    protected String resolveIdentificationString(String p0){ return null; }
    protected String resolveSessionKexProposal(String p0){ return null; }
    protected TimeoutIndicator checkAuthenticationTimeout(Instant p0, Duration p1){ return null; }
    protected TimeoutIndicator checkForTimeouts(){ return null; }
    protected TimeoutIndicator checkIdleTimeout(Instant p0, Duration p1){ return null; }
    protected abstract ConnectionService getConnectionService();
    protected boolean doInvokeUnimplementedMessageHandler(int p0, Buffer p1){ return false; }
    protected byte[] resizeKey(byte[] p0, int p1, Digest p2, byte[] p3, byte[] p4){ return null; }
    protected final Object sessionLock = null;
    protected long calculateNextIgnorePacketCount(Random p0, long p1, int p2){ return 0; }
    protected void doInvokeDebugMessageHandler(Buffer p0){}
    protected void doInvokeIgnoreMessageHandler(Buffer p0){}
    protected void handleDebug(Buffer p0){}
    protected void handleDisconnect(Buffer p0){}
    protected void handleDisconnect(int p0, String p1, String p2, Buffer p3){}
    protected void handleIgnore(Buffer p0){}
    protected void handleUnimplemented(Buffer p0){}
    protected void invokeSessionSignaller(Invoker<SessionListener, Void> p0){}
    protected void signalDisconnect(SessionListener p0, int p1, String p2, String p3, boolean p4){}
    protected void signalDisconnect(int p0, String p1, String p2, boolean p3){}
    protected void signalExceptionCaught(SessionListener p0, Throwable p1){}
    protected void signalExceptionCaught(Throwable p0){}
    protected void signalNegotiationEnd(Map<KexProposalOption, String> p0, Map<KexProposalOption, String> p1, Map<KexProposalOption, String> p2, Throwable p3){}
    protected void signalNegotiationEnd(SessionListener p0, Map<KexProposalOption, String> p1, Map<KexProposalOption, String> p2, Map<KexProposalOption, String> p3, Throwable p4){}
    protected void signalNegotiationOptionsCreated(Map<KexProposalOption, String> p0){}
    protected void signalNegotiationOptionsCreated(SessionListener p0, Map<KexProposalOption, String> p1){}
    protected void signalNegotiationStart(Map<KexProposalOption, String> p0, Map<KexProposalOption, String> p1){}
    protected void signalNegotiationStart(SessionListener p0, Map<KexProposalOption, String> p1, Map<KexProposalOption, String> p2){}
    protected void signalPeerIdentificationReceived(SessionListener p0, String p1, List<String> p2){}
    protected void signalPeerIdentificationReceived(String p0, List<String> p1){}
    protected void signalReadPeerIdentificationLine(SessionListener p0, String p1, List<String> p2){}
    protected void signalReadPeerIdentificationLine(String p0, List<String> p1){}
    protected void signalSendIdentification(SessionListener p0, String p1, List<String> p2){}
    protected void signalSendIdentification(String p0, List<String> p1){}
    protected void signalSessionClosed(){}
    protected void signalSessionClosed(SessionListener p0){}
    protected void signalSessionCreated(IoSession p0){}
    protected void signalSessionCreated(SessionListener p0){}
    protected void signalSessionEstablished(IoSession p0){}
    protected void signalSessionEstablished(SessionListener p0){}
    protected void signalSessionEvent(SessionListener p0, SessionListener.Event p1){}
    protected void signalSessionEvent(SessionListener.Event p0){}
    public <T> T computeAttributeIfAbsent(AttributeRepository.AttributeKey<T> p0, Function<? super AttributeRepository.AttributeKey<T>, ? extends T> p1){ return null; }
    public <T> T getAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    public <T> T removeAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    public <T> T setAttribute(AttributeRepository.AttributeKey<T> p0, T p1){ return null; }
    public ChannelStreamWriterResolver getChannelStreamWriterResolver(){ return null; }
    public ChannelStreamWriterResolver resolveChannelStreamWriterResolver(){ return null; }
    public Collection<AttributeRepository.AttributeKey<? extends Object>> attributeKeys(){ return null; }
    public Duration getAuthTimeout(){ return null; }
    public Duration getIdleTimeout(){ return null; }
    public FactoryManager getFactoryManager(){ return null; }
    public Instant getAuthTimeoutStart(){ return null; }
    public Instant getIdleTimeoutStart(){ return null; }
    public Instant resetAuthTimeout(){ return null; }
    public Instant resetIdleTimeout(){ return null; }
    public IoSession getIoSession(){ return null; }
    public IoWriteFuture sendDebugMessage(boolean p0, Object p1, String p2){ return null; }
    public IoWriteFuture sendIgnoreMessage(byte... p0){ return null; }
    public IoWriteFuture writePacket(Buffer p0, long p1, TimeUnit p2){ return null; }
    public List<Map.Entry<Integer, SshdSocketAddress>> getRemoteForwardsBindings(){ return null; }
    public List<Map.Entry<SshdSocketAddress, SshdSocketAddress>> getLocalForwardsBindings(){ return null; }
    public List<SshdSocketAddress> getBoundLocalPortForwards(int p0){ return null; }
    public List<SshdSocketAddress> getStartedLocalPortForwards(){ return null; }
    public Map<String, Object> getProperties(){ return null; }
    public NavigableSet<Integer> getStartedRemotePortForwards(){ return null; }
    public PropertyResolver getParentPropertyResolver(){ return null; }
    public ReservedSessionMessagesHandler getReservedSessionMessagesHandler(){ return null; }
    public SessionDisconnectHandler getSessionDisconnectHandler(){ return null; }
    public SshdSocketAddress getBoundRemotePortForward(int p0){ return null; }
    public String getUsername(){ return null; }
    public String toString(){ return null; }
    public TimeoutIndicator getTimeoutStatus(){ return null; }
    public UnknownChannelReferenceHandler getUnknownChannelReferenceHandler(){ return null; }
    public UnknownChannelReferenceHandler resolveUnknownChannelReferenceHandler(){ return null; }
    public boolean isAuthenticated(){ return false; }
    public boolean isLocalPortForwardingStartedForPort(int p0){ return false; }
    public boolean isRemotePortForwardingStartedForPort(int p0){ return false; }
    public boolean isServerSession(){ return false; }
    public int getAttributesCount(){ return 0; }
    public void clearAttributes(){}
    public void disconnect(int p0, String p1){}
    public void exceptionCaught(Throwable p0){}
    public void setAuthenticated(){}
    public void setChannelStreamWriterResolver(ChannelStreamWriterResolver p0){}
    public void setReservedSessionMessagesHandler(ReservedSessionMessagesHandler p0){}
    public void setSessionDisconnectHandler(SessionDisconnectHandler p0){}
    public void setUnknownChannelReferenceHandler(UnknownChannelReferenceHandler p0){}
    public void setUsername(String p0){}
}
