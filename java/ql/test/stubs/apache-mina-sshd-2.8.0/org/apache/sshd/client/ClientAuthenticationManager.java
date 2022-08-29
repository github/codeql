// Generated automatically from org.apache.sshd.client.ClientAuthenticationManager for testing purposes

package org.apache.sshd.client;

import java.security.KeyPair;
import java.util.Collection;
import org.apache.sshd.client.auth.AuthenticationIdentitiesProvider;
import org.apache.sshd.client.auth.UserAuth;
import org.apache.sshd.client.auth.UserAuthFactory;
import org.apache.sshd.client.auth.hostbased.HostBasedAuthenticationReporter;
import org.apache.sshd.client.auth.keyboard.UserInteraction;
import org.apache.sshd.client.auth.password.PasswordAuthenticationReporter;
import org.apache.sshd.client.auth.password.PasswordIdentityProvider;
import org.apache.sshd.client.auth.pubkey.PublicKeyAuthenticationReporter;
import org.apache.sshd.client.keyverifier.ServerKeyVerifier;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.common.auth.UserAuthFactoriesManager;
import org.apache.sshd.common.auth.UserAuthInstance;
import org.apache.sshd.common.auth.UserAuthMethodFactory;
import org.apache.sshd.common.keyprovider.KeyIdentityProviderHolder;
import org.apache.sshd.common.session.SessionContext;

public interface ClientAuthenticationManager extends KeyIdentityProviderHolder, UserAuthFactoriesManager<ClientSession, UserAuth, UserAuthFactory>
{
    AuthenticationIdentitiesProvider getRegisteredIdentities();
    HostBasedAuthenticationReporter getHostBasedAuthenticationReporter();
    KeyPair removePublicKeyIdentity(KeyPair p0);
    PasswordAuthenticationReporter getPasswordAuthenticationReporter();
    PasswordIdentityProvider getPasswordIdentityProvider();
    PublicKeyAuthenticationReporter getPublicKeyAuthenticationReporter();
    ServerKeyVerifier getServerKeyVerifier();
    String removePasswordIdentity(String p0);
    UserInteraction getUserInteraction();
    default void setUserAuthFactoriesNames(Collection<String> p0){}
    void addPasswordIdentity(String p0);
    void addPublicKeyIdentity(KeyPair p0);
    void setHostBasedAuthenticationReporter(HostBasedAuthenticationReporter p0);
    void setPasswordAuthenticationReporter(PasswordAuthenticationReporter p0);
    void setPasswordIdentityProvider(PasswordIdentityProvider p0);
    void setPublicKeyAuthenticationReporter(PublicKeyAuthenticationReporter p0);
    void setServerKeyVerifier(ServerKeyVerifier p0);
    void setUserInteraction(UserInteraction p0);
}
