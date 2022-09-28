// Generated automatically from org.apache.sshd.common.session.SessionWorkBuffer for testing purposes

package org.apache.sshd.common.session;

import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionHolder;
import org.apache.sshd.common.util.buffer.Buffer;
import org.apache.sshd.common.util.buffer.ByteArrayBuffer;

public class SessionWorkBuffer extends ByteArrayBuffer implements SessionHolder<Session>
{
    protected SessionWorkBuffer() {}
    public Buffer clear(boolean p0){ return null; }
    public Session getSession(){ return null; }
    public SessionWorkBuffer(Session p0){}
    public void forceClear(boolean p0){}
}
