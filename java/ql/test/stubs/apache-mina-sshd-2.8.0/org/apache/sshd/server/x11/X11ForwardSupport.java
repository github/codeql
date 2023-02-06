// Generated automatically from org.apache.sshd.server.x11.X11ForwardSupport for testing purposes

package org.apache.sshd.server.x11;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.io.IoHandler;

public interface X11ForwardSupport extends Closeable, IoHandler
{
    String createDisplay(boolean p0, String p1, String p2, int p3);
    static String ENV_DISPLAY = null;
    static String XAUTH_COMMAND = null;
}
