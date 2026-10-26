// Generated automatically from org.apache.sshd.common.Service for testing purposes

package org.apache.sshd.common;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionHolder;
import org.apache.sshd.common.util.buffer.Buffer;

public interface Service extends Closeable, PropertyResolver, SessionHolder<Session>
{
    default PropertyResolver getParentPropertyResolver(){ return null; }
    void process(int p0, Buffer p1);
    void start();
}
