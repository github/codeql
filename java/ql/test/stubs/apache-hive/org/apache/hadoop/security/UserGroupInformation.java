// Generated automatically from org.apache.hadoop.security.UserGroupInformation for testing purposes

package org.apache.hadoop.security;

import java.security.PrivilegedAction;
import java.security.PrivilegedExceptionAction;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import javax.security.auth.Subject;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.security.Credentials;
import org.apache.hadoop.security.SaslRpcServer;
import org.apache.hadoop.security.token.Token;
import org.apache.hadoop.security.token.TokenIdentifier;
import org.slf4j.Logger;

public class UserGroupInformation
{
    protected UserGroupInformation() {}
    protected Subject getSubject(){ return null; }
    public <T> T doAs(java.security.PrivilegedAction<T> p0){ return null; }
    public <T> T doAs(java.security.PrivilegedExceptionAction<T> p0){ return null; }
    public Collection<Token<? extends TokenIdentifier>> getTokens(){ return null; }
    public Credentials getCredentials(){ return null; }
    public List<String> getGroups(){ return null; }
    public Set<TokenIdentifier> getTokenIdentifiers(){ return null; }
    public String getPrimaryGroupName(){ return null; }
    public String getShortUserName(){ return null; }
    public String getUserName(){ return null; }
    public String toString(){ return null; }
    public String[] getGroupNames(){ return null; }
    public UserGroupInformation getRealUser(){ return null; }
    public UserGroupInformation.AuthenticationMethod getAuthenticationMethod(){ return null; }
    public UserGroupInformation.AuthenticationMethod getRealAuthenticationMethod(){ return null; }
    public boolean addToken(Text p0, Token<? extends TokenIdentifier> p1){ return false; }
    public boolean addToken(Token<? extends TokenIdentifier> p0){ return false; }
    public boolean addTokenIdentifier(TokenIdentifier p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean hasKerberosCredentials(){ return false; }
    public boolean isFromKeytab(){ return false; }
    public int hashCode(){ return 0; }
    public static String HADOOP_TOKEN_FILE_LOCATION = null;
    public static String trimLoginMethod(String p0){ return null; }
    public static UserGroupInformation createProxyUser(String p0, UserGroupInformation p1){ return null; }
    public static UserGroupInformation createProxyUserForTesting(String p0, UserGroupInformation p1, String[] p2){ return null; }
    public static UserGroupInformation createRemoteUser(String p0){ return null; }
    public static UserGroupInformation createRemoteUser(String p0, SaslRpcServer.AuthMethod p1){ return null; }
    public static UserGroupInformation createUserForTesting(String p0, String[] p1){ return null; }
    public static UserGroupInformation getBestUGI(String p0, String p1){ return null; }
    public static UserGroupInformation getCurrentUser(){ return null; }
    public static UserGroupInformation getLoginUser(){ return null; }
    public static UserGroupInformation getUGIFromSubject(Subject p0){ return null; }
    public static UserGroupInformation getUGIFromTicketCache(String p0, String p1){ return null; }
    public static UserGroupInformation loginUserFromKeytabAndReturnUGI(String p0, String p1){ return null; }
    public static UserGroupInformation.AuthenticationMethod getRealAuthenticationMethod(UserGroupInformation p0){ return null; }
    public static boolean isLoginKeytabBased(){ return false; }
    public static boolean isLoginTicketBased(){ return false; }
    public static boolean isSecurityEnabled(){ return false; }
    public static void logAllUserInfo(Logger p0, UserGroupInformation p1){}
    public static void logAllUserInfo(UserGroupInformation p0){}
    public static void logUserInfo(Logger p0, String p1, UserGroupInformation p2){}
    public static void loginUserFromKeytab(String p0, String p1){}
    public static void loginUserFromSubject(Subject p0){}
    public static void main(String[] p0){}
    public static void reattachMetrics(){}
    public static void reset(){}
    public static void setConfiguration(Configuration p0){}
    public static void setLoginUser(UserGroupInformation p0){}
    public static void setShouldRenewImmediatelyForTests(boolean p0){}
    public void addCredentials(Credentials p0){}
    public void checkTGTAndReloginFromKeytab(){}
    public void logoutUserFromKeytab(){}
    public void reloginFromKeytab(){}
    public void reloginFromTicketCache(){}
    public void setAuthenticationMethod(SaslRpcServer.AuthMethod p0){}
    public void setAuthenticationMethod(UserGroupInformation.AuthenticationMethod p0){}
    static public enum AuthenticationMethod
    {
        CERTIFICATE, KERBEROS, KERBEROS_SSL, PROXY, SIMPLE, TOKEN;
        private AuthenticationMethod() {}
        public SaslRpcServer.AuthMethod getAuthMethod(){ return null; }
    }
}
