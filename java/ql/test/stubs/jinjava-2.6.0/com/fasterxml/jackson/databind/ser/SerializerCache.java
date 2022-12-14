// Generated automatically from com.fasterxml.jackson.databind.ser.SerializerCache for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.impl.ReadOnlyClassToSerializerMap;

public class SerializerCache
{
    public JsonSerializer<Object> typedValueSerializer(Class<? extends Object> p0){ return null; }
    public JsonSerializer<Object> typedValueSerializer(JavaType p0){ return null; }
    public JsonSerializer<Object> untypedValueSerializer(Class<? extends Object> p0){ return null; }
    public JsonSerializer<Object> untypedValueSerializer(JavaType p0){ return null; }
    public ReadOnlyClassToSerializerMap getReadOnlyLookupMap(){ return null; }
    public SerializerCache(){}
    public int size(){ return 0; }
    public void addAndResolveNonTypedSerializer(Class<? extends Object> p0, JavaType p1, JsonSerializer<Object> p2, SerializerProvider p3){}
    public void addAndResolveNonTypedSerializer(Class<? extends Object> p0, JsonSerializer<Object> p1, SerializerProvider p2){}
    public void addAndResolveNonTypedSerializer(JavaType p0, JsonSerializer<Object> p1, SerializerProvider p2){}
    public void addTypedSerializer(Class<? extends Object> p0, JsonSerializer<Object> p1){}
    public void addTypedSerializer(JavaType p0, JsonSerializer<Object> p1){}
    public void flush(){}
}
