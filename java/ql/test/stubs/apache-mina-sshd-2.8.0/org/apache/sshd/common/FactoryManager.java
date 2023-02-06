// Generated automatically from org.apache.sshd.common.FactoryManager for testing purposes

package org.apache.sshd.common;

import java.util.List;
import java.util.concurrent.ScheduledExecutorService;
import org.apache.sshd.agent.SshAgentFactory;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.AttributeStore;
import org.apache.sshd.common.Factory;
import org.apache.sshd.common.ServiceFactory;
import org.apache.sshd.common.channel.ChannelFactory;
import org.apache.sshd.common.channel.ChannelListenerManager;
import org.apache.sshd.common.channel.RequestHandler;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolverManager;
import org.apache.sshd.common.file.FileSystemFactory;
import org.apache.sshd.common.forward.ForwarderFactory;
import org.apache.sshd.common.forward.PortForwardingEventListenerManager;
import org.apache.sshd.common.io.IoServiceEventListenerManager;
import org.apache.sshd.common.io.IoServiceFactory;
import org.apache.sshd.common.kex.KexFactoryManager;
import org.apache.sshd.common.random.Random;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.ReservedSessionMessagesManager;
import org.apache.sshd.common.session.SessionDisconnectHandlerManager;
import org.apache.sshd.common.session.SessionHeartbeatController;
import org.apache.sshd.common.session.SessionListenerManager;
import org.apache.sshd.common.session.UnknownChannelReferenceHandlerManager;
import org.apache.sshd.server.forward.AgentForwardingFilter;
import org.apache.sshd.server.forward.ForwardingFilter;
import org.apache.sshd.server.forward.TcpForwardingFilter;
import org.apache.sshd.server.forward.X11ForwardingFilter;

public interface FactoryManager extends AttributeStore, ChannelListenerManager, ChannelStreamWriterResolverManager, IoServiceEventListenerManager, KexFactoryManager, PortForwardingEventListenerManager, ReservedSessionMessagesManager, SessionDisconnectHandlerManager, SessionHeartbeatController, SessionListenerManager, UnknownChannelReferenceHandlerManager
{
    Factory<? extends Random> getRandomFactory();
    FileSystemFactory getFileSystemFactory();
    ForwarderFactory getForwarderFactory();
    ForwardingFilter getForwardingFilter();
    IoServiceFactory getIoServiceFactory();
    List<? extends ChannelFactory> getChannelFactories();
    List<? extends ServiceFactory> getServiceFactories();
    List<RequestHandler<ConnectionService>> getGlobalRequestHandlers();
    ScheduledExecutorService getScheduledExecutorService();
    SshAgentFactory getAgentFactory();
    String getVersion();
    default <T> T resolveAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    default AgentForwardingFilter getAgentForwardingFilter(){ return null; }
    default TcpForwardingFilter getTcpForwardingFilter(){ return null; }
    default X11ForwardingFilter getX11ForwardingFilter(){ return null; }
    static <T> T resolveAttribute(FactoryManager p0, AttributeRepository.AttributeKey<T> p1){ return null; }
    static String DEFAULT_VERSION = null;
}
