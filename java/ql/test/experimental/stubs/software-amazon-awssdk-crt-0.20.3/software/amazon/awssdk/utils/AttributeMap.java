// Generated automatically from software.amazon.awssdk.utils.AttributeMap for testing purposes

package software.amazon.awssdk.utils;

import java.util.Map;
import software.amazon.awssdk.utils.SdkAutoCloseable;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AttributeMap implements SdkAutoCloseable, ToCopyableBuilder<AttributeMap.Builder, AttributeMap>
{
    protected AttributeMap() {}
    abstract static public class Key<T>
    {
        protected Key() {}
        protected Key(AttributeMap.Key.UnsafeValueType p0){}
        protected Key(java.lang.Class<T> p0){}
        public final T convertValue(Object p0){ return null; }
        public static class UnsafeValueType
        {
            protected UnsafeValueType() {}
            public UnsafeValueType(Class<? extends Object> p0){}
        }
    }
    public <T> T get(AttributeMap.Key<T> p0){ return null; }
    public <T> boolean containsKey(AttributeMap.Key<T> p0){ return false; }
    public AttributeMap copy(){ return null; }
    public AttributeMap merge(AttributeMap p0){ return null; }
    public AttributeMap.Builder toBuilder(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static AttributeMap empty(){ return null; }
    public static AttributeMap.Builder builder(){ return null; }
    public void close(){}
    static public class Builder implements CopyableBuilder<AttributeMap.Builder, AttributeMap>
    {
        protected Builder() {}
        public <T> AttributeMap.Builder put(AttributeMap.Key<T> p0, T p1){ return null; }
        public <T> T get(AttributeMap.Key<T> p0){ return null; }
        public AttributeMap build(){ return null; }
        public AttributeMap.Builder putAll(Map<? extends AttributeMap.Key<? extends Object>, ? extends Object> p0){ return null; }
    }
}
