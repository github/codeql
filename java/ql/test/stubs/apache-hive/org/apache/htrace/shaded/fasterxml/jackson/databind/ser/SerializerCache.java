// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.SerializerCache for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.ReadOnlyClassToSerializerMap;

public class SerializerCache
{
    public JsonSerializer<Object> typedValueSerializer(Class<? extends Object> p0){ return null; }
    public JsonSerializer<Object> typedValueSerializer(JavaType p0){ return null; }
    public JsonSerializer<Object> untypedValueSerializer(Class<? extends Object> p0){ return null; }
    public JsonSerializer<Object> untypedValueSerializer(JavaType p0){ return null; }
    public ReadOnlyClassToSerializerMap getReadOnlyLookupMap(){ return null; }
    public SerializerCache(){}
    public int size(){ return 0; }
    public void addAndResolveNonTypedSerializer(Class<? extends Object> p0, JsonSerializer<Object> p1, SerializerProvider p2){}
    public void addAndResolveNonTypedSerializer(JavaType p0, JsonSerializer<Object> p1, SerializerProvider p2){}
    public void addTypedSerializer(Class<? extends Object> p0, JsonSerializer<Object> p1){}
    public void addTypedSerializer(JavaType p0, JsonSerializer<Object> p1){}
    public void flush(){}
    static public class TypeKey
    {
        protected TypeKey() {}
        protected Class<? extends Object> _class = null;
        protected JavaType _type = null;
        protected boolean _isTyped = false;
        protected int _hashCode = 0;
        public TypeKey(Class<? extends Object> p0, boolean p1){}
        public TypeKey(JavaType p0, boolean p1){}
        public final String toString(){ return null; }
        public final boolean equals(Object p0){ return false; }
        public final int hashCode(){ return 0; }
        public void resetTyped(Class<? extends Object> p0){}
        public void resetTyped(JavaType p0){}
        public void resetUntyped(Class<? extends Object> p0){}
        public void resetUntyped(JavaType p0){}
    }
}
