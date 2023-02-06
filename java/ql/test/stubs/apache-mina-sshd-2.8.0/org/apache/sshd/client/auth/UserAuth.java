// Generated automatically from org.apache.sshd.client.auth.UserAuth for testing purposes

package org.apache.sshd.client.auth;

import java.util.List;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.ClientSessionHolder;
import org.apache.sshd.common.auth.UserAuthInstance;
import org.apache.sshd.common.session.SessionContext;
import org.apache.sshd.common.util.buffer.Buffer;

public interface UserAuth extends ClientSessionHolder, UserAuthInstance<ClientSession>
{
    boolean process(Buffer p0);
    default void signalAuthMethodFailure(ClientSession p0, String p1, boolean p2, List<String> p3, Buffer p4){}
    default void signalAuthMethodSuccess(ClientSession p0, String p1, Buffer p2){}
    void destroy();
    void init(ClientSession p0, String p1);
}
