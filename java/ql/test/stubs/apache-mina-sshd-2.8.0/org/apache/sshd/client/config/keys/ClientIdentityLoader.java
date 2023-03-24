// Generated automatically from org.apache.sshd.client.config.keys.ClientIdentityLoader for testing purposes

package org.apache.sshd.client.config.keys;

import java.security.KeyPair;
import java.util.Collection;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.config.keys.FilePasswordProvider;
import org.apache.sshd.common.keyprovider.KeyIdentityProvider;
import org.apache.sshd.common.session.SessionContext;

public interface ClientIdentityLoader
{
    Iterable<KeyPair> loadClientIdentities(SessionContext p0, NamedResource p1, FilePasswordProvider p2);
    boolean isValidLocation(NamedResource p0);
    static ClientIdentityLoader DEFAULT = null;
    static KeyIdentityProvider asKeyIdentityProvider(ClientIdentityLoader p0, Collection<? extends NamedResource> p1, FilePasswordProvider p2, boolean p3){ return null; }
}
