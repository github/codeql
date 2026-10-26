// Generated automatically from org.apache.sshd.common.io.IoService for testing purposes

package org.apache.sshd.common.io;

import java.util.Map;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.io.IoServiceEventListenerManager;
import org.apache.sshd.common.io.IoSession;

public interface IoService extends Closeable, IoServiceEventListenerManager
{
    Map<Long, IoSession> getManagedSessions();
    static boolean DEFAULT_REUSE_ADDRESS = false;
}
