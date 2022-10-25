// Generated automatically from org.apache.sshd.common.session.helpers.AbstractSessionFactory for testing purposes

package org.apache.sshd.common.session.helpers;

import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.session.helpers.AbstractSession;
import org.apache.sshd.common.session.helpers.AbstractSessionIoHandler;

abstract public class AbstractSessionFactory<M extends FactoryManager, S extends AbstractSession> extends AbstractSessionIoHandler
{
    protected AbstractSessionFactory() {}
    protected AbstractSessionFactory(M p0){}
    protected S createSession(IoSession p0){ return null; }
    protected S setupSession(S p0){ return null; }
    protected abstract S doCreateSession(IoSession p0);
    public M getFactoryManager(){ return null; }
}
