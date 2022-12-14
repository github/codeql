// Generated automatically from org.apache.sshd.client.config.hosts.HostConfigEntry for testing purposes

package org.apache.sshd.client.config.hosts;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.net.URL;
import java.nio.file.OpenOption;
import java.nio.file.Path;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import org.apache.sshd.client.config.hosts.HostConfigEntryResolver;
import org.apache.sshd.client.config.hosts.HostPatternsHolder;
import org.apache.sshd.common.auth.MutableUserHolder;

public class HostConfigEntry extends HostPatternsHolder implements MutableUserHolder
{
    public <A extends Appendable> A append(A p0){ return null; }
    public Collection<String> getIdentities(){ return null; }
    public HostConfigEntry(){}
    public HostConfigEntry(String p0, String p1, int p2, String p3){}
    public HostConfigEntry(String p0, String p1, int p2, String p3, String p4){}
    public Map<String, String> getProperties(){ return null; }
    public Map<String, String> updateGlobalProperties(Map<String, String> p0){ return null; }
    public String appendPropertyValue(String p0, String p1){ return null; }
    public String getHost(){ return null; }
    public String getHostName(){ return null; }
    public String getProperty(String p0){ return null; }
    public String getProperty(String p0, String p1){ return null; }
    public String getProxyJump(){ return null; }
    public String getUsername(){ return null; }
    public String removeProperty(String p0){ return null; }
    public String resolveHostName(String p0){ return null; }
    public String resolveProxyJump(String p0){ return null; }
    public String resolveUsername(String p0){ return null; }
    public String setProperty(String p0, String p1){ return null; }
    public String toString(){ return null; }
    public boolean isIdentitiesOnly(){ return false; }
    public boolean processGlobalValues(HostConfigEntry p0){ return false; }
    public boolean updateGlobalHostName(String p0){ return false; }
    public boolean updateGlobalIdentities(Collection<String> p0){ return false; }
    public boolean updateGlobalIdentityOnly(boolean p0){ return false; }
    public boolean updateGlobalPort(int p0){ return false; }
    public boolean updateGlobalUserName(String p0){ return false; }
    public int getPort(){ return 0; }
    public int resolvePort(int p0){ return 0; }
    public static <A extends Appendable> A appendHostConfigEntries(A p0, Collection<? extends HostConfigEntry> p1){ return null; }
    public static <A extends Appendable> A appendNonEmptyPort(A p0, String p1, int p2){ return null; }
    public static <A extends Appendable> A appendNonEmptyProperties(A p0, Map<String, ? extends Object> p1){ return null; }
    public static <A extends Appendable> A appendNonEmptyProperty(A p0, String p1, Object p2){ return null; }
    public static <A extends Appendable> A appendNonEmptyValues(A p0, String p1, Collection<? extends Object> p2){ return null; }
    public static <A extends Appendable> A appendNonEmptyValues(A p0, String p1, Object... p2){ return null; }
    public static HostConfigEntry findBestMatch(Collection<? extends HostConfigEntry> p0){ return null; }
    public static HostConfigEntry findBestMatch(Iterable<? extends HostConfigEntry> p0){ return null; }
    public static HostConfigEntry findBestMatch(Iterator<? extends HostConfigEntry> p0){ return null; }
    public static HostConfigEntry normalizeEntry(HostConfigEntry p0, String p1, int p2, String p3, String p4){ return null; }
    public static HostConfigEntryResolver toHostConfigEntryResolver(Collection<? extends HostConfigEntry> p0){ return null; }
    public static List<HostConfigEntry> readHostConfigEntries(BufferedReader p0){ return null; }
    public static List<HostConfigEntry> readHostConfigEntries(InputStream p0, boolean p1){ return null; }
    public static List<HostConfigEntry> readHostConfigEntries(Path p0, OpenOption... p1){ return null; }
    public static List<HostConfigEntry> readHostConfigEntries(Reader p0, boolean p1){ return null; }
    public static List<HostConfigEntry> readHostConfigEntries(URL p0){ return null; }
    public static List<HostConfigEntry> updateEntriesList(List<HostConfigEntry> p0, HostConfigEntry p1){ return null; }
    public static List<String> parseConfigValue(String p0){ return null; }
    public static NavigableSet<String> EXPLICIT_PROPERTIES = null;
    public static Path getDefaultHostConfigFile(){ return null; }
    public static String EXCLUSIVE_IDENTITIES_CONFIG_PROP = null;
    public static String HOST_CONFIG_PROP = null;
    public static String HOST_NAME_CONFIG_PROP = null;
    public static String IDENTITY_AGENT = null;
    public static String IDENTITY_FILE_CONFIG_PROP = null;
    public static String MULTI_VALUE_SEPARATORS = null;
    public static String PORT_CONFIG_PROP = null;
    public static String PROXY_JUMP_CONFIG_PROP = null;
    public static String STD_CONFIG_FILENAME = null;
    public static String USER_CONFIG_PROP = null;
    public static String resolveHostName(String p0, String p1){ return null; }
    public static String resolveIdentityFilePath(String p0, String p1, int p2, String p3){ return null; }
    public static String resolveProxyJump(String p0, String p1){ return null; }
    public static String resolveUsername(String p0, String p1){ return null; }
    public static StringBuilder appendUserHome(StringBuilder p0){ return null; }
    public static StringBuilder appendUserHome(StringBuilder p0, Path p1){ return null; }
    public static StringBuilder appendUserHome(StringBuilder p0, String p1){ return null; }
    public static boolean DEFAULT_EXCLUSIVE_IDENTITIES = false;
    public static char HOME_TILDE_CHAR = '0';
    public static char LOCAL_HOME_MACRO = '0';
    public static char LOCAL_HOST_MACRO = '0';
    public static char LOCAL_USER_MACRO = '0';
    public static char PATH_MACRO_CHAR = '0';
    public static char REMOTE_HOST_MACRO = '0';
    public static char REMOTE_PORT_MACRO = '0';
    public static char REMOTE_USER_MACRO = '0';
    public static int resolvePort(int p0, int p1){ return 0; }
    public static void writeHostConfigEntries(OutputStream p0, boolean p1, Collection<? extends HostConfigEntry> p2){}
    public static void writeHostConfigEntries(Path p0, Collection<? extends HostConfigEntry> p1, OpenOption... p2){}
    public void addIdentity(Path p0){}
    public void addIdentity(String p0){}
    public void processProperty(String p0, Collection<String> p1, boolean p2){}
    public void setHost(Collection<String> p0){}
    public void setHost(String p0){}
    public void setHostName(String p0){}
    public void setIdentities(Collection<String> p0){}
    public void setIdentitiesOnly(boolean p0){}
    public void setPort(int p0){}
    public void setProperties(Map<String, String> p0){}
    public void setProxyJump(String p0){}
    public void setUsername(String p0){}
}
