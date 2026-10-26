// Generated automatically from org.apache.sshd.common.io.IoServiceFactoryFactory for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.Factory;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.io.IoServiceFactory;
import org.apache.sshd.common.util.threads.CloseableExecutorService;

public interface IoServiceFactoryFactory
{
    IoServiceFactory create(FactoryManager p0);
    void setExecutorServiceFactory(Factory<CloseableExecutorService> p0);
}
