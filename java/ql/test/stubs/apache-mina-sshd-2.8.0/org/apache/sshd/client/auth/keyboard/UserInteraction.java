// Generated automatically from org.apache.sshd.client.auth.keyboard.UserInteraction for testing purposes

package org.apache.sshd.client.auth.keyboard;

import java.security.KeyPair;
import java.util.List;
import org.apache.sshd.client.session.ClientSession;

public interface UserInteraction
{
    String getUpdatedPassword(ClientSession p0, String p1, String p2);
    String[] interactive(ClientSession p0, String p1, String p2, String p3, String[] p4, boolean[] p5);
    default KeyPair resolveAuthPublicKeyIdentityAttempt(ClientSession p0){ return null; }
    default String resolveAuthPasswordAttempt(ClientSession p0){ return null; }
    default boolean isInteractionAllowed(ClientSession p0){ return false; }
    default void serverVersionInfo(ClientSession p0, List<String> p1){}
    default void welcome(ClientSession p0, String p1, String p2){}
    static String AUTO_DETECT_PASSWORD_PROMPT = null;
    static String CHECK_INTERACTIVE_PASSWORD_DELIM = null;
    static String DEFAULT_CHECK_INTERACTIVE_PASSWORD_DELIM = null;
    static String DEFAULT_INTERACTIVE_PASSWORD_PROMPT = null;
    static String INTERACTIVE_PASSWORD_PROMPT = null;
    static UserInteraction NONE = null;
    static boolean DEFAULT_AUTO_DETECT_PASSWORD_PROMPT = false;
    static int findPromptComponentLastPosition(String p0, String p1){ return 0; }
}
