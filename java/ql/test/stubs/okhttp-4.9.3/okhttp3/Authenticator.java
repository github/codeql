// Generated automatically from okhttp3.Authenticator for testing purposes

package okhttp3;

import okhttp3.Request;
import okhttp3.Response;
import okhttp3.Route;

public interface Authenticator
{
    Request authenticate(Route p0, Response p1);
    static Authenticator JAVA_NET_AUTHENTICATOR = null;
    static Authenticator NONE = null;
    static Authenticator.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
    }
}
