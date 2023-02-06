// Generated automatically from okhttp3.CookieJar for testing purposes

package okhttp3;

import java.util.List;
import okhttp3.Cookie;
import okhttp3.HttpUrl;

public interface CookieJar
{
    List<Cookie> loadForRequest(HttpUrl p0);
    static CookieJar NO_COOKIES = null;
    static CookieJar.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
    }
    void saveFromResponse(HttpUrl p0, List<Cookie> p1);
}
