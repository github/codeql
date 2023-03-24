// Generated automatically from org.apache.sshd.common.keyprovider.KeyIdentityProvider for testing purposes

package org.apache.sshd.common.keyprovider;

import java.security.KeyPair;
import java.util.Collection;
import java.util.Iterator;
import org.apache.sshd.common.session.SessionContext;

public interface KeyIdentityProvider
{
    Iterable<KeyPair> loadKeys(SessionContext p0);
    static Iterable<KeyPair> iterableOf(SessionContext p0, Collection<? extends KeyIdentityProvider> p1){ return null; }
    static KeyIdentityProvider EMPTY_KEYS_PROVIDER = null;
    static KeyIdentityProvider multiProvider(Collection<? extends KeyIdentityProvider> p0){ return null; }
    static KeyIdentityProvider multiProvider(KeyIdentityProvider... p0){ return null; }
    static KeyIdentityProvider resolveKeyIdentityProvider(KeyIdentityProvider p0, KeyIdentityProvider p1){ return null; }
    static KeyIdentityProvider wrapKeyPairs(Iterable<KeyPair> p0){ return null; }
    static KeyIdentityProvider wrapKeyPairs(KeyPair... p0){ return null; }
    static KeyPair exhaustCurrentIdentities(Iterator<? extends KeyPair> p0){ return null; }
    static boolean isEmpty(KeyIdentityProvider p0){ return false; }
}
