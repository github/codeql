// Generated automatically from org.apache.sshd.common.ServiceFactory for testing purposes

package org.apache.sshd.common;

import java.util.Collection;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.Service;
import org.apache.sshd.common.session.Session;

public interface ServiceFactory extends NamedResource
{
    Service create(Session p0);
    static Service create(Collection<? extends ServiceFactory> p0, String p1, Session p2){ return null; }
}
