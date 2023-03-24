// Generated automatically from com.fasterxml.jackson.databind.ser.impl.PropertySerializerMap for testing purposes

package com.fasterxml.jackson.databind.ser.impl;

import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

abstract public class PropertySerializerMap
{
    protected PropertySerializerMap() {}
    protected PropertySerializerMap(PropertySerializerMap p0){}
    protected PropertySerializerMap(boolean p0){}
    protected final boolean _resetWhenFull = false;
    public abstract JsonSerializer<Object> serializerFor(Class<? extends Object> p0);
    public abstract PropertySerializerMap newWith(Class<? extends Object> p0, JsonSerializer<Object> p1);
    public final PropertySerializerMap.SerializerAndMapResult addSerializer(Class<? extends Object> p0, JsonSerializer<Object> p1){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult addSerializer(JavaType p0, JsonSerializer<Object> p1){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddKeySerializer(Class<? extends Object> p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddPrimarySerializer(Class<? extends Object> p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddPrimarySerializer(JavaType p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddRootValueSerializer(Class<? extends Object> p0, SerializerProvider p1){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddRootValueSerializer(JavaType p0, SerializerProvider p1){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddSecondarySerializer(Class<? extends Object> p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddSecondarySerializer(JavaType p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public static PropertySerializerMap emptyForProperties(){ return null; }
    public static PropertySerializerMap emptyForRootValues(){ return null; }
    public static PropertySerializerMap emptyMap(){ return null; }
    static public class SerializerAndMapResult
    {
        protected SerializerAndMapResult() {}
        public SerializerAndMapResult(JsonSerializer<Object> p0, PropertySerializerMap p1){}
        public final JsonSerializer<Object> serializer = null;
        public final PropertySerializerMap map = null;
    }
}
