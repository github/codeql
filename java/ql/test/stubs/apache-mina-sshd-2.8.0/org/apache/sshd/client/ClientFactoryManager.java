// Generated automatically from org.apache.sshd.client.ClientFactoryManager for testing purposes

package org.apache.sshd.client;

import org.apache.sshd.client.ClientAuthenticationManager;
import org.apache.sshd.client.config.hosts.HostConfigEntryResolver;
import org.apache.sshd.client.config.keys.ClientIdentityLoaderManager;
import org.apache.sshd.client.session.ClientProxyConnectorHolder;
import org.apache.sshd.client.session.ClientSessionCreator;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.config.keys.FilePasswordProviderManager;

public interface ClientFactoryManager extends ClientAuthenticationManager, ClientIdentityLoaderManager, ClientProxyConnectorHolder, ClientSessionCreator, FactoryManager, FilePasswordProviderManager
{
    HostConfigEntryResolver getHostConfigEntryResolver();
    void setHostConfigEntryResolver(HostConfigEntryResolver p0);
}
