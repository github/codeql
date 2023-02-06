// Generated automatically from org.apache.sshd.client.session.ClientSessionImpl for testing purposes

package org.apache.sshd.client.session;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.sshd.client.ClientFactoryManager;
import org.apache.sshd.client.future.AuthFuture;
import org.apache.sshd.client.session.AbstractClientSession;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.common.Service;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.session.SessionListener;
import org.apache.sshd.common.util.buffer.Buffer;

public class ClientSessionImpl extends AbstractClientSession
{
    protected ClientSessionImpl() {}
    protected <C extends Collection<ClientSession.ClientSessionEvent>> C updateCurrentSessionState(C p0){ return null; }
    protected List<Service> getServices(){ return null; }
    protected String nextServiceName(){ return null; }
    protected void handleDisconnect(int p0, String p1, String p2, Buffer p3){}
    protected void preClose(){}
    protected void sendInitialServiceRequest(){}
    protected void signalAuthFailure(Throwable p0){}
    protected void signalSessionEvent(SessionListener.Event p0){}
    public AuthFuture auth(){ return null; }
    public ClientSessionImpl(ClientFactoryManager p0, IoSession p1){}
    public Map<Object, Object> getMetadataMap(){ return null; }
    public Set<ClientSession.ClientSessionEvent> getSessionState(){ return null; }
    public Set<ClientSession.ClientSessionEvent> waitFor(Collection<ClientSession.ClientSessionEvent> p0, long p1){ return null; }
    public void exceptionCaught(Throwable p0){}
    public void switchToNextService(){}
}
