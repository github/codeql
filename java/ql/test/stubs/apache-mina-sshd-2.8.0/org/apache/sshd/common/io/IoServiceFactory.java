// Generated automatically from org.apache.sshd.common.io.IoServiceFactory for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.io.IoAcceptor;
import org.apache.sshd.common.io.IoConnector;
import org.apache.sshd.common.io.IoHandler;
import org.apache.sshd.common.io.IoServiceEventListenerManager;

public interface IoServiceFactory extends Closeable, IoServiceEventListenerManager
{
    IoAcceptor createAcceptor(IoHandler p0);
    IoConnector createConnector(IoHandler p0);
}
