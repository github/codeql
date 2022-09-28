// Generated automatically from org.apache.sshd.client.session.SessionFactory for testing purposes

package org.apache.sshd.client.session;

import org.apache.sshd.client.ClientFactoryManager;
import org.apache.sshd.client.session.ClientSessionImpl;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.session.helpers.AbstractSession;
import org.apache.sshd.common.session.helpers.AbstractSessionFactory;

public class SessionFactory extends AbstractSessionFactory<ClientFactoryManager, ClientSessionImpl>
{
    protected SessionFactory() {}
    protected ClientSessionImpl doCreateSession(IoSession p0){ return null; }
    public SessionFactory(ClientFactoryManager p0){}
    public final ClientFactoryManager getClient(){ return null; }
}
