// Generated automatically from org.apache.sshd.client.auth.AuthenticationIdentitiesProvider for testing purposes

package org.apache.sshd.client.auth;

import java.util.Comparator;
import java.util.List;
import org.apache.sshd.client.auth.password.PasswordIdentityProvider;
import org.apache.sshd.common.keyprovider.KeyIdentityProvider;
import org.apache.sshd.common.session.SessionContext;

public interface AuthenticationIdentitiesProvider extends KeyIdentityProvider, PasswordIdentityProvider
{
    Iterable<? extends Object> loadIdentities(SessionContext p0);
    static AuthenticationIdentitiesProvider wrapIdentities(Iterable<? extends Object> p0){ return null; }
    static Comparator<Object> KEYPAIR_IDENTITY_COMPARATOR = null;
    static Comparator<Object> PASSWORD_IDENTITY_COMPARATOR = null;
    static int findIdentityIndex(List<? extends Object> p0, Comparator<? super Object> p1, Object p2){ return 0; }
}
