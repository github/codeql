// Generated automatically from org.apache.sshd.common.auth.UserAuthMethodFactory for testing purposes

package org.apache.sshd.common.auth;

import java.util.Collection;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.auth.UserAuthInstance;
import org.apache.sshd.common.session.SessionContext;

public interface UserAuthMethodFactory<S extends SessionContext, M extends UserAuthInstance<S>> extends NamedResource
{
    M createUserAuth(S p0);
    static <S extends SessionContext, M extends UserAuthInstance<S>> M createUserAuth(S p0, Collection<? extends UserAuthMethodFactory<S, M>> p1, String p2){ return null; }
    static String HOST_BASED = null;
    static String KB_INTERACTIVE = null;
    static String PASSWORD = null;
    static String PUBLIC_KEY = null;
    static boolean isDataIntegrityAuthenticationTransport(SessionContext p0){ return false; }
    static boolean isSecureAuthenticationTransport(SessionContext p0){ return false; }
}
