// Generated automatically from org.apache.sshd.client.SshClient for testing purposes

package org.apache.sshd.client;

import java.net.SocketAddress;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.security.KeyPair;
import java.util.Collection;
import java.util.List;
import org.apache.sshd.client.ClientFactoryManager;
import org.apache.sshd.client.auth.AuthenticationIdentitiesProvider;
import org.apache.sshd.client.auth.UserAuthFactory;
import org.apache.sshd.client.auth.hostbased.HostBasedAuthenticationReporter;
import org.apache.sshd.client.auth.keyboard.UserInteraction;
import org.apache.sshd.client.auth.password.PasswordAuthenticationReporter;
import org.apache.sshd.client.auth.password.PasswordIdentityProvider;
import org.apache.sshd.client.auth.pubkey.PublicKeyAuthenticationReporter;
import org.apache.sshd.client.config.hosts.HostConfigEntry;
import org.apache.sshd.client.config.hosts.HostConfigEntryResolver;
import org.apache.sshd.client.config.keys.ClientIdentityLoader;
import org.apache.sshd.client.future.ConnectFuture;
import org.apache.sshd.client.keyverifier.ServerKeyVerifier;
import org.apache.sshd.client.session.ClientProxyConnector;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.SessionFactory;
import org.apache.sshd.client.simple.SimpleClient;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.Factory;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.ServiceFactory;
import org.apache.sshd.common.config.keys.FilePasswordProvider;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.SshFutureListener;
import org.apache.sshd.common.helpers.AbstractFactoryManager;
import org.apache.sshd.common.io.IoConnectFuture;
import org.apache.sshd.common.io.IoConnector;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.keyprovider.KeyIdentityProvider;

public class SshClient extends AbstractFactoryManager implements ClientFactoryManager, Closeable
{
    protected Closeable getInnerCloseable(){ return null; }
    protected ConnectFuture doConnect(HostConfigEntry p0, List<HostConfigEntry> p1, AttributeRepository p2, SocketAddress p3){ return null; }
    protected ConnectFuture doConnect(String p0, SocketAddress p1, AttributeRepository p2, SocketAddress p3, KeyIdentityProvider p4, HostConfigEntry p5){ return null; }
    protected HostConfigEntry resolveHost(String p0, String p1, int p2, AttributeRepository p3, SocketAddress p4){ return null; }
    protected IoConnector connector = null;
    protected IoConnector createConnector(){ return null; }
    protected KeyIdentityProvider preloadClientIdentities(Collection<? extends NamedResource> p0){ return null; }
    protected List<HostConfigEntry> parseProxyJumps(String p0, AttributeRepository p1){ return null; }
    protected List<UserAuthFactory> userAuthFactories = null;
    protected SessionFactory createSessionFactory(){ return null; }
    protected SessionFactory sessionFactory = null;
    protected SshFutureListener<IoConnectFuture> createConnectCompletionListener(ConnectFuture p0, String p1, SocketAddress p2, KeyIdentityProvider p3, HostConfigEntry p4){ return null; }
    protected void checkConfig(){}
    protected void onConnectOperationComplete(IoSession p0, ConnectFuture p1, String p2, SocketAddress p3, KeyIdentityProvider p4, HostConfigEntry p5){}
    protected void setupDefaultSessionIdentities(ClientSession p0, KeyIdentityProvider p1){}
    public AuthenticationIdentitiesProvider getRegisteredIdentities(){ return null; }
    public ClientIdentityLoader getClientIdentityLoader(){ return null; }
    public ClientProxyConnector getClientProxyConnector(){ return null; }
    public ConnectFuture connect(HostConfigEntry p0, AttributeRepository p1, SocketAddress p2){ return null; }
    public ConnectFuture connect(String p0){ return null; }
    public ConnectFuture connect(String p0, SocketAddress p1, AttributeRepository p2, SocketAddress p3){ return null; }
    public ConnectFuture connect(String p0, String p1, int p2, AttributeRepository p3, SocketAddress p4){ return null; }
    public FilePasswordProvider getFilePasswordProvider(){ return null; }
    public HostBasedAuthenticationReporter getHostBasedAuthenticationReporter(){ return null; }
    public HostConfigEntryResolver getHostConfigEntryResolver(){ return null; }
    public KeyIdentityProvider getKeyIdentityProvider(){ return null; }
    public KeyPair removePublicKeyIdentity(KeyPair p0){ return null; }
    public List<UserAuthFactory> getUserAuthFactories(){ return null; }
    public PasswordAuthenticationReporter getPasswordAuthenticationReporter(){ return null; }
    public PasswordIdentityProvider getPasswordIdentityProvider(){ return null; }
    public PublicKeyAuthenticationReporter getPublicKeyAuthenticationReporter(){ return null; }
    public ServerKeyVerifier getServerKeyVerifier(){ return null; }
    public SessionFactory getSessionFactory(){ return null; }
    public SshClient(){}
    public String removePasswordIdentity(String p0){ return null; }
    public String toString(){ return null; }
    public UserInteraction getUserInteraction(){ return null; }
    public boolean isStarted(){ return false; }
    public static <C extends SshClient> C setKeyPairProvider(C p0, Path p1, boolean p2, boolean p3, FilePasswordProvider p4, LinkOption... p5){ return null; }
    public static <C extends SshClient> C setKeyPairProvider(C p0, boolean p1, boolean p2, FilePasswordProvider p3, LinkOption... p4){ return null; }
    public static Factory<SshClient> DEFAULT_SSH_CLIENT_FACTORY = null;
    public static List<ServiceFactory> DEFAULT_SERVICE_FACTORIES = null;
    public static List<UserAuthFactory> DEFAULT_USER_AUTH_FACTORIES = null;
    public static SimpleClient setUpDefaultSimpleClient(){ return null; }
    public static SimpleClient wrapAsSimpleClient(SshClient p0){ return null; }
    public static SshClient setUpDefaultClient(){ return null; }
    public void addPasswordIdentity(String p0){}
    public void addPublicKeyIdentity(KeyPair p0){}
    public void open(){}
    public void setClientIdentityLoader(ClientIdentityLoader p0){}
    public void setClientProxyConnector(ClientProxyConnector p0){}
    public void setFilePasswordProvider(FilePasswordProvider p0){}
    public void setHostBasedAuthenticationReporter(HostBasedAuthenticationReporter p0){}
    public void setHostConfigEntryResolver(HostConfigEntryResolver p0){}
    public void setKeyIdentityProvider(KeyIdentityProvider p0){}
    public void setPasswordAuthenticationReporter(PasswordAuthenticationReporter p0){}
    public void setPasswordIdentityProvider(PasswordIdentityProvider p0){}
    public void setPublicKeyAuthenticationReporter(PublicKeyAuthenticationReporter p0){}
    public void setServerKeyVerifier(ServerKeyVerifier p0){}
    public void setSessionFactory(SessionFactory p0){}
    public void setUserAuthFactories(List<UserAuthFactory> p0){}
    public void setUserInteraction(UserInteraction p0){}
    public void start(){}
    public void stop(){}
}
