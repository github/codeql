// Generated automatically from android.util.Property for testing purposes

package android.util;


abstract public class Property<T, V>
{
    protected Property() {}
    public Class<V> getType(){ return null; }
    public Property(Class<V> p0, String p1){}
    public String getName(){ return null; }
    public abstract V get(T p0);
    public boolean isReadOnly(){ return false; }
    public static <T, V> Property<T, V> of(Class<T> p0, Class<V> p1, String p2){ return null; }
    public void set(T p0, V p1){}
}
