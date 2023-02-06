// Generated automatically from org.apache.sshd.common.helpers.AbstractFactoryManager for testing purposes

package org.apache.sshd.common.helpers;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.function.Function;
import org.apache.sshd.agent.SshAgentFactory;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.Factory;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.ServiceFactory;
import org.apache.sshd.common.channel.ChannelFactory;
import org.apache.sshd.common.channel.ChannelListener;
import org.apache.sshd.common.channel.RequestHandler;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolver;
import org.apache.sshd.common.file.FileSystemFactory;
import org.apache.sshd.common.forward.ForwarderFactory;
import org.apache.sshd.common.forward.PortForwardingEventListener;
import org.apache.sshd.common.io.IoServiceEventListener;
import org.apache.sshd.common.io.IoServiceFactory;
import org.apache.sshd.common.io.IoServiceFactoryFactory;
import org.apache.sshd.common.kex.AbstractKexFactoryManager;
import org.apache.sshd.common.random.Random;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.ReservedSessionMessagesHandler;
import org.apache.sshd.common.session.SessionDisconnectHandler;
import org.apache.sshd.common.session.SessionListener;
import org.apache.sshd.common.session.UnknownChannelReferenceHandler;
import org.apache.sshd.common.session.helpers.AbstractSession;
import org.apache.sshd.common.session.helpers.AbstractSessionFactory;
import org.apache.sshd.common.session.helpers.SessionTimeoutListener;
import org.apache.sshd.server.forward.ForwardingFilter;

abstract public class AbstractFactoryManager extends AbstractKexFactoryManager implements FactoryManager
{
    protected AbstractFactoryManager(){}
    protected Factory<? extends Random> randomFactory = null;
    protected FileSystemFactory fileSystemFactory = null;
    protected ForwarderFactory forwarderFactory = null;
    protected ForwardingFilter forwardingFilter = null;
    protected IoServiceFactory ioServiceFactory = null;
    protected IoServiceFactoryFactory ioServiceFactoryFactory = null;
    protected List<? extends ChannelFactory> channelFactories = null;
    protected List<? extends ServiceFactory> serviceFactories = null;
    protected List<RequestHandler<ConnectionService>> globalRequestHandlers = null;
    protected ScheduledExecutorService executor = null;
    protected ScheduledFuture<? extends Object> timeoutListenerFuture = null;
    protected SessionTimeoutListener createSessionTimeoutListener(){ return null; }
    protected SessionTimeoutListener sessionTimeoutListener = null;
    protected SshAgentFactory agentFactory = null;
    protected boolean shutdownExecutor = false;
    protected final ChannelListener channelListenerProxy = null;
    protected final Collection<ChannelListener> channelListeners = null;
    protected final Collection<PortForwardingEventListener> tunnelListeners = null;
    protected final Collection<SessionListener> sessionListeners = null;
    protected final PortForwardingEventListener tunnelListenerProxy = null;
    protected final SessionListener sessionListenerProxy = null;
    protected void checkConfig(){}
    protected void removeSessionTimeout(AbstractSessionFactory<? extends Object, ? extends Object> p0){}
    protected void setupSessionTimeout(AbstractSessionFactory<? extends Object, ? extends Object> p0){}
    protected void stopSessionTimeoutListener(AbstractSessionFactory<? extends Object, ? extends Object> p0){}
    public <T> T computeAttributeIfAbsent(AttributeRepository.AttributeKey<T> p0, Function<? super AttributeRepository.AttributeKey<T>, ? extends T> p1){ return null; }
    public <T> T getAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    public <T> T removeAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    public <T> T setAttribute(AttributeRepository.AttributeKey<T> p0, T p1){ return null; }
    public ChannelListener getChannelListenerProxy(){ return null; }
    public ChannelStreamWriterResolver getChannelStreamWriterResolver(){ return null; }
    public Collection<AttributeRepository.AttributeKey<? extends Object>> attributeKeys(){ return null; }
    public Factory<? extends Random> getRandomFactory(){ return null; }
    public FileSystemFactory getFileSystemFactory(){ return null; }
    public ForwarderFactory getForwarderFactory(){ return null; }
    public ForwardingFilter getForwardingFilter(){ return null; }
    public IoServiceEventListener getIoServiceEventListener(){ return null; }
    public IoServiceFactory getIoServiceFactory(){ return null; }
    public IoServiceFactoryFactory getIoServiceFactoryFactory(){ return null; }
    public List<? extends ChannelFactory> getChannelFactories(){ return null; }
    public List<? extends ServiceFactory> getServiceFactories(){ return null; }
    public List<RequestHandler<ConnectionService>> getGlobalRequestHandlers(){ return null; }
    public Map<String, Object> getProperties(){ return null; }
    public PortForwardingEventListener getPortForwardingEventListenerProxy(){ return null; }
    public PropertyResolver getParentPropertyResolver(){ return null; }
    public ReservedSessionMessagesHandler getReservedSessionMessagesHandler(){ return null; }
    public ScheduledExecutorService getScheduledExecutorService(){ return null; }
    public SessionDisconnectHandler getSessionDisconnectHandler(){ return null; }
    public SessionListener getSessionListenerProxy(){ return null; }
    public SshAgentFactory getAgentFactory(){ return null; }
    public String getVersion(){ return null; }
    public UnknownChannelReferenceHandler getUnknownChannelReferenceHandler(){ return null; }
    public UnknownChannelReferenceHandler resolveUnknownChannelReferenceHandler(){ return null; }
    public int getAttributesCount(){ return 0; }
    public int getNioWorkers(){ return 0; }
    public void addChannelListener(ChannelListener p0){}
    public void addPortForwardingEventListener(PortForwardingEventListener p0){}
    public void addSessionListener(SessionListener p0){}
    public void clearAttributes(){}
    public void removeChannelListener(ChannelListener p0){}
    public void removePortForwardingEventListener(PortForwardingEventListener p0){}
    public void removeSessionListener(SessionListener p0){}
    public void setAgentFactory(SshAgentFactory p0){}
    public void setChannelFactories(List<? extends ChannelFactory> p0){}
    public void setChannelStreamWriterResolver(ChannelStreamWriterResolver p0){}
    public void setFileSystemFactory(FileSystemFactory p0){}
    public void setForwarderFactory(ForwarderFactory p0){}
    public void setForwardingFilter(ForwardingFilter p0){}
    public void setGlobalRequestHandlers(List<RequestHandler<ConnectionService>> p0){}
    public void setIoServiceEventListener(IoServiceEventListener p0){}
    public void setIoServiceFactoryFactory(IoServiceFactoryFactory p0){}
    public void setNioWorkers(int p0){}
    public void setParentPropertyResolver(PropertyResolver p0){}
    public void setRandomFactory(Factory<? extends Random> p0){}
    public void setReservedSessionMessagesHandler(ReservedSessionMessagesHandler p0){}
    public void setScheduledExecutorService(ScheduledExecutorService p0){}
    public void setScheduledExecutorService(ScheduledExecutorService p0, boolean p1){}
    public void setServiceFactories(List<? extends ServiceFactory> p0){}
    public void setSessionDisconnectHandler(SessionDisconnectHandler p0){}
    public void setUnknownChannelReferenceHandler(UnknownChannelReferenceHandler p0){}
}
