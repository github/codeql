// Generated automatically from okhttp3.Dns for testing purposes

package okhttp3;

import java.net.InetAddress;
import java.util.List;

public interface Dns
{
    List<InetAddress> lookup(String p0);
    static Dns SYSTEM = null;
    static Dns.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
    }
}
