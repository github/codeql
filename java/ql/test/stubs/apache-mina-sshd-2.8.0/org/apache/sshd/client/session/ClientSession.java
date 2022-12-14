// Generated automatically from org.apache.sshd.client.session.ClientSession for testing purposes

package org.apache.sshd.client.session;

import java.io.OutputStream;
import java.net.SocketAddress;
import java.nio.charset.Charset;
import java.security.PublicKey;
import java.time.Duration;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.apache.sshd.client.ClientAuthenticationManager;
import org.apache.sshd.client.ClientFactoryManager;
import org.apache.sshd.client.channel.ChannelDirectTcpip;
import org.apache.sshd.client.channel.ChannelExec;
import org.apache.sshd.client.channel.ChannelShell;
import org.apache.sshd.client.channel.ChannelSubsystem;
import org.apache.sshd.client.channel.ClientChannel;
import org.apache.sshd.client.channel.ClientChannelEvent;
import org.apache.sshd.client.future.AuthFuture;
import org.apache.sshd.client.session.ClientProxyConnectorHolder;
import org.apache.sshd.client.session.forward.DynamicPortForwardingTracker;
import org.apache.sshd.client.session.forward.ExplicitPortForwardingTracker;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.channel.PtyChannelConfigurationHolder;
import org.apache.sshd.common.forward.PortForwardingManager;
import org.apache.sshd.common.future.KeyExchangeFuture;
import org.apache.sshd.common.keyprovider.KeyIdentityProvider;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public interface ClientSession extends ClientAuthenticationManager, ClientProxyConnectorHolder, PortForwardingManager, Session
{
    AttributeRepository getConnectionContext();
    AuthFuture auth();
    ChannelDirectTcpip createDirectTcpipChannel(SshdSocketAddress p0, SshdSocketAddress p1);
    ChannelExec createExecChannel(String p0, PtyChannelConfigurationHolder p1, Map<String, ? extends Object> p2);
    ChannelShell createShellChannel(PtyChannelConfigurationHolder p0, Map<String, ? extends Object> p1);
    ChannelSubsystem createSubsystemChannel(String p0);
    ClientChannel createChannel(String p0);
    ClientChannel createChannel(String p0, String p1);
    ClientFactoryManager getFactoryManager();
    KeyExchangeFuture switchToNoneCipher();
    Map<Object, Object> getMetadataMap();
    PublicKey getServerKey();
    Set<ClientSession.ClientSessionEvent> getSessionState();
    Set<ClientSession.ClientSessionEvent> waitFor(Collection<ClientSession.ClientSessionEvent> p0, long p1);
    SocketAddress getConnectAddress();
    default ChannelExec createExecChannel(String p0){ return null; }
    default ChannelShell createShellChannel(){ return null; }
    default DynamicPortForwardingTracker createDynamicPortForwardingTracker(SshdSocketAddress p0){ return null; }
    default ExplicitPortForwardingTracker createLocalPortForwardingTracker(SshdSocketAddress p0, SshdSocketAddress p1){ return null; }
    default ExplicitPortForwardingTracker createLocalPortForwardingTracker(int p0, SshdSocketAddress p1){ return null; }
    default ExplicitPortForwardingTracker createRemotePortForwardingTracker(SshdSocketAddress p0, SshdSocketAddress p1){ return null; }
    default Set<ClientSession.ClientSessionEvent> waitFor(Collection<ClientSession.ClientSessionEvent> p0, Duration p1){ return null; }
    default String executeRemoteCommand(String p0){ return null; }
    default String executeRemoteCommand(String p0, OutputStream p1, Charset p2){ return null; }
    default void executeRemoteCommand(String p0, OutputStream p1, OutputStream p2, Charset p3){}
    static Iterator<String> passwordIteratorOf(ClientSession p0){ return null; }
    static KeyIdentityProvider providerOf(ClientSession p0){ return null; }
    static Set<ClientChannelEvent> REMOTE_COMMAND_WAIT_EVENTS = null;
    static public enum ClientSessionEvent
    {
        AUTHED, CLOSED, TIMEOUT, WAIT_AUTH;
        private ClientSessionEvent() {}
    }
}
