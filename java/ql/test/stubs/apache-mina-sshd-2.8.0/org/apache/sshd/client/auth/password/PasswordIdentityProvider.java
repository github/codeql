// Generated automatically from org.apache.sshd.client.auth.password.PasswordIdentityProvider for testing purposes

package org.apache.sshd.client.auth.password;

import java.util.Collection;
import java.util.Iterator;
import org.apache.sshd.common.session.SessionContext;

public interface PasswordIdentityProvider
{
    Iterable<String> loadPasswords(SessionContext p0);
    static Iterable<String> iterableOf(SessionContext p0, Collection<? extends PasswordIdentityProvider> p1){ return null; }
    static Iterator<String> iteratorOf(SessionContext p0, PasswordIdentityProvider p1){ return null; }
    static Iterator<String> iteratorOf(SessionContext p0, PasswordIdentityProvider p1, PasswordIdentityProvider p2){ return null; }
    static PasswordIdentityProvider EMPTY_PASSWORDS_PROVIDER = null;
    static PasswordIdentityProvider multiProvider(SessionContext p0, Collection<? extends PasswordIdentityProvider> p1){ return null; }
    static PasswordIdentityProvider multiProvider(SessionContext p0, PasswordIdentityProvider... p1){ return null; }
    static PasswordIdentityProvider resolvePasswordIdentityProvider(SessionContext p0, PasswordIdentityProvider p1, PasswordIdentityProvider p2){ return null; }
    static PasswordIdentityProvider wrapPasswords(Iterable<String> p0){ return null; }
    static PasswordIdentityProvider wrapPasswords(String... p0){ return null; }
}
