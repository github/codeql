// Generated automatically from jakarta.ws.rs.core.NewCookie for testing purposes

package jakarta.ws.rs.core;

import jakarta.ws.rs.core.Cookie;

public class NewCookie extends Cookie
{
    protected NewCookie() {}
    abstract static public class AbstractNewCookieBuilder<T extends NewCookie.AbstractNewCookieBuilder<T>> extends Cookie.AbstractCookieBuilder<NewCookie.AbstractNewCookieBuilder<T>>
    {
        protected AbstractNewCookieBuilder() {}
        public AbstractNewCookieBuilder(Cookie p0){}
        public AbstractNewCookieBuilder(String p0){}
        public T comment(String p0){ return null; }
        public T expiry(java.util.Date p0){ return null; }
        public T httpOnly(boolean p0){ return null; }
        public T maxAge(int p0){ return null; }
        public T sameSite(NewCookie.SameSite p0){ return null; }
        public T secure(boolean p0){ return null; }
        public abstract NewCookie build();
    }
    protected NewCookie(NewCookie.AbstractNewCookieBuilder<? extends Object> p0){}
    public Cookie toCookie(){ return null; }
    public NewCookie(Cookie p0){}
    public NewCookie(Cookie p0, String p1, int p2, boolean p3){}
    public NewCookie(Cookie p0, String p1, int p2, java.util.Date p3, boolean p4, boolean p5){}
    public NewCookie(Cookie p0, String p1, int p2, java.util.Date p3, boolean p4, boolean p5, NewCookie.SameSite p6){}
    public NewCookie(String p0, String p1){}
    public NewCookie(String p0, String p1, String p2, String p3, String p4, int p5, boolean p6){}
    public NewCookie(String p0, String p1, String p2, String p3, String p4, int p5, boolean p6, boolean p7){}
    public NewCookie(String p0, String p1, String p2, String p3, int p4, String p5, int p6, boolean p7){}
    public NewCookie(String p0, String p1, String p2, String p3, int p4, String p5, int p6, java.util.Date p7, boolean p8, boolean p9){}
    public NewCookie(String p0, String p1, String p2, String p3, int p4, String p5, int p6, java.util.Date p7, boolean p8, boolean p9, NewCookie.SameSite p10){}
    public NewCookie.SameSite getSameSite(){ return null; }
    public String getComment(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isHttpOnly(){ return false; }
    public boolean isSecure(){ return false; }
    public int getMaxAge(){ return 0; }
    public int hashCode(){ return 0; }
    public java.util.Date getExpiry(){ return null; }
    public static NewCookie valueOf(String p0){ return null; }
    public static int DEFAULT_MAX_AGE = 0;
    static public enum SameSite
    {
        LAX, NONE, STRICT;
        private SameSite() {}
    }
}
