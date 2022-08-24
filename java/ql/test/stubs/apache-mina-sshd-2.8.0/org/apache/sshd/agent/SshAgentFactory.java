// Generated automatically from org.apache.sshd.agent.SshAgentFactory for testing purposes

package org.apache.sshd.agent;

import java.util.List;
import org.apache.sshd.agent.SshAgent;
import org.apache.sshd.agent.SshAgentServer;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.channel.ChannelFactory;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.Session;

public interface SshAgentFactory
{
    List<ChannelFactory> getChannelForwardingFactories(FactoryManager p0);
    SshAgent createClient(Session p0, FactoryManager p1);
    SshAgentServer createServer(ConnectionService p0);
}
