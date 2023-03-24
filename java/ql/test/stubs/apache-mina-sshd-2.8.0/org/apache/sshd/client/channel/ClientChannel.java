// Generated automatically from org.apache.sshd.client.channel.ClientChannel for testing purposes

package org.apache.sshd.client.channel;

import java.io.InputStream;
import java.io.OutputStream;
import java.time.Duration;
import java.util.Collection;
import java.util.Set;
import org.apache.sshd.client.channel.ClientChannelEvent;
import org.apache.sshd.client.future.OpenFuture;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.ClientSessionHolder;
import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.channel.StreamingChannel;
import org.apache.sshd.common.io.IoInputStream;
import org.apache.sshd.common.io.IoOutputStream;

public interface ClientChannel extends Channel, ClientSessionHolder, StreamingChannel
{
    InputStream getInvertedErr();
    InputStream getInvertedOut();
    Integer getExitStatus();
    IoInputStream getAsyncErr();
    IoInputStream getAsyncOut();
    IoOutputStream getAsyncIn();
    OpenFuture open();
    OutputStream getInvertedIn();
    Set<ClientChannelEvent> getChannelState();
    Set<ClientChannelEvent> waitFor(Collection<ClientChannelEvent> p0, long p1);
    String getChannelType();
    String getExitSignal();
    default ClientSession getClientSession(){ return null; }
    default Set<ClientChannelEvent> waitFor(Collection<ClientChannelEvent> p0, Duration p1){ return null; }
    static void validateCommandExitStatusCode(String p0, Integer p1){}
    void setErr(OutputStream p0);
    void setIn(InputStream p0);
    void setOut(OutputStream p0);
}
