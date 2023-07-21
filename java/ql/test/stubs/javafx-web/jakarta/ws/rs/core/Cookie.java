// Generated automatically from jakarta.ws.rs.core.Cookie for testing purposes

package jakarta.ws.rs.core;


public class Cookie
{
    protected Cookie() {}
    abstract static public class AbstractCookieBuilder<T extends Cookie.AbstractCookieBuilder<T>>
    {
        protected AbstractCookieBuilder() {}
        public AbstractCookieBuilder(String p0){}
        public T domain(String p0){ return null; }
        public T path(String p0){ return null; }
        public T value(String p0){ return null; }
        public T version(int p0){ return null; }
        public abstract Cookie build();
    }
    protected Cookie(Cookie.AbstractCookieBuilder<? extends Object> p0){}
    public Cookie(String p0, String p1){}
    public Cookie(String p0, String p1, String p2, String p3){}
    public Cookie(String p0, String p1, String p2, String p3, int p4){}
    public String getDomain(){ return null; }
    public String getName(){ return null; }
    public String getPath(){ return null; }
    public String getValue(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int getVersion(){ return 0; }
    public int hashCode(){ return 0; }
    public static Cookie valueOf(String p0){ return null; }
    public static int DEFAULT_VERSION = 0;
}
