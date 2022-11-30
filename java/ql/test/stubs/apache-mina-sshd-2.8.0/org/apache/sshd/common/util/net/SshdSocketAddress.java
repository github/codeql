// Generated automatically from org.apache.sshd.common.util.net.SshdSocketAddress for testing purposes

package org.apache.sshd.common.util.net;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SshdSocketAddress extends SocketAddress
{
    protected SshdSocketAddress() {}
    protected boolean isEquivalent(SshdSocketAddress p0){ return false; }
    public InetSocketAddress toInetSocketAddress(){ return null; }
    public SshdSocketAddress(InetSocketAddress p0){}
    public SshdSocketAddress(String p0, int p1){}
    public SshdSocketAddress(int p0){}
    public String getHostName(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int getPort(){ return 0; }
    public int hashCode(){ return 0; }
    public static <V> Map.Entry<SshdSocketAddress, ? extends V> findMatchingOptionalWildcardEntry(Map<SshdSocketAddress, ? extends V> p0, SshdSocketAddress p1){ return null; }
    public static <V> V findByOptionalWildcardAddress(Map<SshdSocketAddress, ? extends V> p0, SshdSocketAddress p1){ return null; }
    public static <V> V removeByOptionalWildcardAddress(Map<SshdSocketAddress, ? extends V> p0, SshdSocketAddress p1){ return null; }
    public static Comparator<InetAddress> BY_HOST_ADDRESS = null;
    public static Comparator<SocketAddress> BY_HOST_AND_PORT = null;
    public static InetAddress getFirstExternalNetwork4Address(){ return null; }
    public static InetSocketAddress toInetSocketAddress(SocketAddress p0){ return null; }
    public static List<InetAddress> getExternalNetwork4Addresses(){ return null; }
    public static Set<String> WELL_KNOWN_IPV4_ADDRESSES = null;
    public static Set<String> WELL_KNOWN_IPV6_ADDRESSES = null;
    public static SshdSocketAddress LOCALHOST_ADDRESS = null;
    public static SshdSocketAddress toSshdSocketAddress(SocketAddress p0){ return null; }
    public static String BROADCAST_ADDRESS = null;
    public static String CARRIER_GRADE_NAT_PREFIX = null;
    public static String IPV4_ANYADDR = null;
    public static String IPV6_LONG_ANY_ADDRESS = null;
    public static String IPV6_LONG_LOCALHOST = null;
    public static String IPV6_SHORT_ANY_ADDRESS = null;
    public static String IPV6_SHORT_LOCALHOST = null;
    public static String LOCALHOST_IPV4 = null;
    public static String LOCALHOST_NAME = null;
    public static String PRIVATE_CLASS_A_PREFIX = null;
    public static String PRIVATE_CLASS_B_PREFIX = null;
    public static String PRIVATE_CLASS_C_PREFIX = null;
    public static String toAddressString(InetAddress p0){ return null; }
    public static String toAddressString(SocketAddress p0){ return null; }
    public static boolean isCarrierGradeNatIPv4Address(String p0){ return false; }
    public static boolean isEquivalentHostName(String p0, String p1, boolean p2){ return false; }
    public static boolean isIPv4Address(String p0){ return false; }
    public static boolean isIPv4LoopbackAddress(String p0){ return false; }
    public static boolean isIPv6Address(String p0){ return false; }
    public static boolean isIPv6LoopbackAddress(String p0){ return false; }
    public static boolean isLoopback(InetAddress p0){ return false; }
    public static boolean isLoopback(String p0){ return false; }
    public static boolean isLoopbackAlias(String p0, String p1){ return false; }
    public static boolean isPrivateIPv4Address(String p0){ return false; }
    public static boolean isValidHostAddress(InetAddress p0){ return false; }
    public static boolean isValidIPv4AddressComponent(CharSequence p0){ return false; }
    public static boolean isWildcardAddress(String p0){ return false; }
    public static int IPV6_MAX_HEX_DIGITS_PER_GROUP = 0;
    public static int IPV6_MAX_HEX_GROUPS = 0;
    public static int toAddressPort(SocketAddress p0){ return 0; }
}
