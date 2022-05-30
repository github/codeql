// Generated automatically from org.apache.sshd.common.session.SessionContext for testing purposes

package org.apache.sshd.common.session;

import java.util.Map;
import org.apache.sshd.common.AttributeStore;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.auth.UsernameHolder;
import org.apache.sshd.common.cipher.CipherInformation;
import org.apache.sshd.common.compression.CompressionInformation;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.kex.KexState;
import org.apache.sshd.common.mac.MacInformation;
import org.apache.sshd.common.session.SessionHeartbeatController;
import org.apache.sshd.common.util.net.ConnectionEndpointsIndicator;

public interface SessionContext extends AttributeStore, Closeable, ConnectionEndpointsIndicator, SessionHeartbeatController, UsernameHolder
{
    CipherInformation getCipherInformation(boolean p0);
    CompressionInformation getCompressionInformation(boolean p0);
    KexState getKexState();
    MacInformation getMacInformation(boolean p0);
    Map<KexProposalOption, String> getClientKexProposals();
    Map<KexProposalOption, String> getKexNegotiationResult();
    Map<KexProposalOption, String> getServerKexProposals();
    String getClientVersion();
    String getNegotiatedKexParameter(KexProposalOption p0);
    String getServerVersion();
    boolean isAuthenticated();
    boolean isServerSession();
    byte[] getSessionId();
    static String DEFAULT_SSH_VERSION_PREFIX = null;
    static String FALLBACK_SSH_VERSION_PREFIX = null;
    static boolean isDataIntegrityTransport(SessionContext p0){ return false; }
    static boolean isSecureSessionTransport(SessionContext p0){ return false; }
    static boolean isValidVersionPrefix(String p0){ return false; }
    static int MAX_VERSION_LINE_LENGTH = 0;
}
