// Generated automatically from org.apache.sshd.client.session.ClientUserAuthService for testing purposes

package org.apache.sshd.client.session;

import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;
import org.apache.sshd.client.auth.UserAuthFactory;
import org.apache.sshd.client.future.AuthFuture;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.ClientSessionHolder;
import org.apache.sshd.client.session.ClientSessionImpl;
import org.apache.sshd.common.Service;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.closeable.AbstractCloseable;

public class ClientUserAuthService extends AbstractCloseable implements ClientSessionHolder, Service
{
    protected ClientUserAuthService() {}
    protected AuthFuture createAuthFuture(ClientSession p0, String p1){ return null; }
    protected AuthFuture updateCurrentAuthFuture(ClientSession p0, String p1){ return null; }
    protected IoWriteFuture sendInitialAuthRequest(ClientSession p0, String p1){ return null; }
    protected List<String> serverMethods = null;
    protected final AtomicReference<AuthFuture> authFutureHolder = null;
    protected final ClientSessionImpl clientSession = null;
    protected final List<String> clientMethods = null;
    protected final List<UserAuthFactory> authFactories = null;
    protected void preClose(){}
    protected void processUserAuth(Buffer p0){}
    protected void tryNext(int p0){}
    public AuthFuture auth(String p0){ return null; }
    public ClientSession getClientSession(){ return null; }
    public ClientSession getSession(){ return null; }
    public ClientUserAuthService(Session p0){}
    public Map<String, Object> getProperties(){ return null; }
    public String getCurrentServiceName(){ return null; }
    public void process(int p0, Buffer p1){}
    public void start(){}
}
