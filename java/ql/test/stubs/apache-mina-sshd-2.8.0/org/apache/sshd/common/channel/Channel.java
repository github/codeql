// Generated automatically from org.apache.sshd.common.channel.Channel for testing purposes

package org.apache.sshd.common.channel;

import java.util.Collection;
import java.util.List;
import org.apache.sshd.client.future.OpenFuture;
import org.apache.sshd.common.AttributeRepository;
import org.apache.sshd.common.AttributeStore;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.channel.ChannelListenerManager;
import org.apache.sshd.common.channel.RequestHandler;
import org.apache.sshd.common.channel.Window;
import org.apache.sshd.common.channel.throttle.ChannelStreamWriterResolverManager;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionHolder;
import org.apache.sshd.common.util.buffer.Buffer;

public interface Channel extends AttributeStore, ChannelListenerManager, ChannelStreamWriterResolverManager, Closeable, PropertyResolver, SessionHolder<Session>
{
    IoWriteFuture writePacket(Buffer p0);
    List<RequestHandler<Channel>> getRequestHandlers();
    OpenFuture open(int p0, long p1, long p2, Buffer p3);
    Window getLocalWindow();
    Window getRemoteWindow();
    boolean isEofSignalled();
    boolean isInitialized();
    default <T> T resolveAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    default void addRequestHandlers(Collection<? extends RequestHandler<Channel>> p0){}
    default void removeRequestHandlers(Collection<? extends RequestHandler<Channel>> p0){}
    int getId();
    int getRecipient();
    static <T> T resolveAttribute(Channel p0, AttributeRepository.AttributeKey<T> p1){ return null; }
    static String CHANNEL_EXEC = null;
    static String CHANNEL_SHELL = null;
    static String CHANNEL_SUBSYSTEM = null;
    void addRequestHandler(RequestHandler<Channel> p0);
    void handleChannelRegistrationResult(ConnectionService p0, Session p1, int p2, boolean p3);
    void handleChannelUnregistration(ConnectionService p0);
    void handleClose();
    void handleData(Buffer p0);
    void handleEof();
    void handleExtendedData(Buffer p0);
    void handleFailure();
    void handleOpenFailure(Buffer p0);
    void handleOpenSuccess(int p0, long p1, long p2, Buffer p3);
    void handleRequest(Buffer p0);
    void handleSuccess();
    void handleWindowAdjust(Buffer p0);
    void init(ConnectionService p0, Session p1, int p2);
    void removeRequestHandler(RequestHandler<Channel> p0);
}
