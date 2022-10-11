// Generated automatically from org.apache.sshd.client.config.hosts.HostPatternsHolder for testing purposes

package org.apache.sshd.client.config.hosts;

import java.util.Collection;
import java.util.List;
import java.util.regex.Pattern;
import org.apache.sshd.client.config.hosts.HostConfigEntry;
import org.apache.sshd.client.config.hosts.HostPatternValue;

abstract public class HostPatternsHolder
{
    protected HostPatternsHolder(){}
    public Collection<HostPatternValue> getPatterns(){ return null; }
    public boolean isHostMatch(String p0, int p1){ return false; }
    public static HostPatternValue toPattern(CharSequence p0){ return null; }
    public static List<HostConfigEntry> findMatchingEntries(String p0, Collection<? extends HostConfigEntry> p1){ return null; }
    public static List<HostConfigEntry> findMatchingEntries(String p0, HostConfigEntry... p1){ return null; }
    public static List<HostPatternValue> parsePatterns(CharSequence... p0){ return null; }
    public static List<HostPatternValue> parsePatterns(Collection<? extends CharSequence> p0){ return null; }
    public static String ALL_HOSTS_PATTERN = null;
    public static String PATTERN_CHARS = null;
    public static boolean isHostMatch(String p0, Pattern p1){ return false; }
    public static boolean isHostMatch(String p0, int p1, Collection<HostPatternValue> p2){ return false; }
    public static boolean isPortMatch(int p0, int p1){ return false; }
    public static boolean isSpecificHostPattern(String p0){ return false; }
    public static boolean isValidPatternChar(char p0){ return false; }
    public static char NEGATION_CHAR_PATTERN = '0';
    public static char NON_STANDARD_PORT_PATTERN_ENCLOSURE_END_DELIM = '0';
    public static char NON_STANDARD_PORT_PATTERN_ENCLOSURE_START_DELIM = '0';
    public static char PORT_VALUE_DELIMITER = '0';
    public static char SINGLE_CHAR_PATTERN = '0';
    public static char WILDCARD_PATTERN = '0';
    public void setPatterns(Collection<HostPatternValue> p0){}
}
