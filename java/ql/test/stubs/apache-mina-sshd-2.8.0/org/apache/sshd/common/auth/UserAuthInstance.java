// Generated automatically from org.apache.sshd.common.auth.UserAuthInstance for testing purposes

package org.apache.sshd.common.auth;

import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.session.SessionContext;

public interface UserAuthInstance<S extends SessionContext> extends NamedResource
{
    S getSession();
}
