// Generated automatically from org.apache.sshd.client.session.AbstractClientSession for testing purposes

package org.apache.sshd.client.session;

import java.net.SocketAddress;
import java.security.KeyPair;
import java.security.PublicKey;
import java.util.List;
import java.util.Map;
import org.apache.sshd.client.ClientFactoryManager;
import org.apache.sshd.client.auth.AuthenticationIdentitiesProvider;
import org.apache.sshd.client.auth.UserAuthFactory;
import org.apache.sshd.client.auth.hostbased.HostBasedAuthenticationReporter;
import org.apache.sshd.client.auth.keyboard.UserInteraction;
import org.apache.sshd.client.auth.password.PasswordAuthenticationReporter;
import org.apache.sshd.client.auth.password.PasswordIdentityProvider;
import org.apache.sshd.client.auth.pubkey.PublicKeyAuthenticationReporter;
import org.apache.sshd.client.channel.ChannelDirectTcpip;
import org.apache.sshd.client.channel.ChannelExec;
import org.apache.sshd.client.channel.ChannelShell;
import org.apache.sshd.client.channel.ChannelSubsystem;
import org.apache.sshd.client.channel.ClientChannel;
import org.apache.sshd.client.keyverifier.ServerKeyVerifier;
import org.apache.sshd.client.session.ClientProxyConnector;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.ClientUserAuthService;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.channel.PtyChannelConfigurationHolder;
import org.apache.sshd.common.forward.Forwarder;
import org.apache.sshd.common.future.KeyExchangeFuture;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.keyprovider.KeyIdentityProvider;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.helpers.AbstractSession;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.net.SshdSocketAddress;

abstract public class AbstractClientSession extends AbstractSession implements ClientSession
{
    protected AbstractClientSession() {}
    protected AbstractClientSession(ClientFactoryManager p0, IoSession p1){}
    protected ClientUserAuthService getUserAuthService(){ return null; }
    protected ConnectionService getConnectionService(){ return null; }
    protected Forwarder getForwarder(){ return null; }
    protected IoWriteFuture sendClientIdentification(){ return null; }
    protected String resolveAvailableSignaturesProposal(FactoryManager p0){ return null; }
    protected boolean readIdentification(Buffer p0){ return false; }
    protected byte[] receiveKexInit(Buffer p0){ return null; }
    protected byte[] sendKexInit(Map<KexProposalOption, String> p0){ return null; }
    protected final boolean sendImmediateClientIdentification = false;
    protected final boolean sendImmediateKexInit = false;
    protected void checkKeys(){}
    protected void initializeKeyExchangePhase(){}
    protected void initializeProxyConnector(){}
    protected void receiveKexInit(Map<KexProposalOption, String> p0, byte[] p1){}
    protected void setKexSeed(byte... p0){}
    protected void signalExtraServerVersionInfo(String p0, List<String> p1){}
    public AttributeRepository getConnectionContext(){ return null; }
    public AuthenticationIdentitiesProvider getRegisteredIdentities(){ return null; }
    public ChannelDirectTcpip createDirectTcpipChannel(SshdSocketAddress p0, SshdSocketAddress p1){ return null; }
    public ChannelExec createExecChannel(String p0, PtyChannelConfigurationHolder p1, Map<String, ? extends Object> p2){ return null; }
    public ChannelShell createShellChannel(PtyChannelConfigurationHolder p0, Map<String, ? extends Object> p1){ return null; }
    public ChannelSubsystem createSubsystemChannel(String p0){ return null; }
    public ClientChannel createChannel(String p0){ return null; }
    public ClientChannel createChannel(String p0, String p1){ return null; }
    public ClientFactoryManager getFactoryManager(){ return null; }
    public ClientProxyConnector getClientProxyConnector(){ return null; }
    public HostBasedAuthenticationReporter getHostBasedAuthenticationReporter(){ return null; }
    public KeyExchangeFuture switchToNoneCipher(){ return null; }
    public KeyIdentityProvider getKeyIdentityProvider(){ return null; }
    public KeyPair removePublicKeyIdentity(KeyPair p0){ return null; }
    public List<UserAuthFactory> getUserAuthFactories(){ return null; }
    public PasswordAuthenticationReporter getPasswordAuthenticationReporter(){ return null; }
    public PasswordIdentityProvider getPasswordIdentityProvider(){ return null; }
    public PublicKey getServerKey(){ return null; }
    public PublicKeyAuthenticationReporter getPublicKeyAuthenticationReporter(){ return null; }
    public ServerKeyVerifier getServerKeyVerifier(){ return null; }
    public SocketAddress getConnectAddress(){ return null; }
    public SshdSocketAddress startDynamicPortForwarding(SshdSocketAddress p0){ return null; }
    public SshdSocketAddress startLocalPortForwarding(SshdSocketAddress p0, SshdSocketAddress p1){ return null; }
    public SshdSocketAddress startRemotePortForwarding(SshdSocketAddress p0, SshdSocketAddress p1){ return null; }
    public String removePasswordIdentity(String p0){ return null; }
    public UserInteraction getUserInteraction(){ return null; }
    public void addPasswordIdentity(String p0){}
    public void addPublicKeyIdentity(KeyPair p0){}
    public void setClientProxyConnector(ClientProxyConnector p0){}
    public void setConnectAddress(SocketAddress p0){}
    public void setHostBasedAuthenticationReporter(HostBasedAuthenticationReporter p0){}
    public void setKeyIdentityProvider(KeyIdentityProvider p0){}
    public void setPasswordAuthenticationReporter(PasswordAuthenticationReporter p0){}
    public void setPasswordIdentityProvider(PasswordIdentityProvider p0){}
    public void setPublicKeyAuthenticationReporter(PublicKeyAuthenticationReporter p0){}
    public void setServerKey(PublicKey p0){}
    public void setServerKeyVerifier(ServerKeyVerifier p0){}
    public void setUserAuthFactories(List<UserAuthFactory> p0){}
    public void setUserInteraction(UserInteraction p0){}
    public void startService(String p0, Buffer p1){}
    public void stopDynamicPortForwarding(SshdSocketAddress p0){}
    public void stopLocalPortForwarding(SshdSocketAddress p0){}
    public void stopRemotePortForwarding(SshdSocketAddress p0){}
}
