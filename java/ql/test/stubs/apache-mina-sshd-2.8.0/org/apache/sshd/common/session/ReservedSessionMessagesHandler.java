// Generated automatically from org.apache.sshd.common.session.ReservedSessionMessagesHandler for testing purposes

package org.apache.sshd.common.session;

import java.util.List;
import java.util.Map;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.session.ConnectionService;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.SshdEventListener;
import org.apache.sshd.common.util.buffer.Buffer;

public interface ReservedSessionMessagesHandler extends SshdEventListener
{
    default IoWriteFuture sendIdentification(Session p0, String p1, List<String> p2){ return null; }
    default IoWriteFuture sendKexInitRequest(Session p0, Map<KexProposalOption, String> p1, Buffer p2){ return null; }
    default boolean handleUnimplementedMessage(Session p0, int p1, Buffer p2){ return false; }
    default boolean sendReservedHeartbeat(ConnectionService p0){ return false; }
    default void handleDebugMessage(Session p0, Buffer p1){}
    default void handleIgnoreMessage(Session p0, Buffer p1){}
}
