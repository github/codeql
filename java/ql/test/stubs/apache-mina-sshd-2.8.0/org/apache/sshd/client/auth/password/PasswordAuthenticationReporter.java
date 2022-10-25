// Generated automatically from org.apache.sshd.client.auth.password.PasswordAuthenticationReporter for testing purposes

package org.apache.sshd.client.auth.password;

import java.util.List;
import org.apache.sshd.client.session.ClientSession;

public interface PasswordAuthenticationReporter
{
    default void signalAuthenticationAttempt(ClientSession p0, String p1, String p2, boolean p3, String p4){}
    default void signalAuthenticationExhausted(ClientSession p0, String p1){}
    default void signalAuthenticationFailure(ClientSession p0, String p1, String p2, boolean p3, List<String> p4){}
    default void signalAuthenticationSuccess(ClientSession p0, String p1, String p2){}
}
