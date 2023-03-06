// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.PropertySerializerMap for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl;

import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;

abstract public class PropertySerializerMap
{
    public PropertySerializerMap(){}
    public abstract JsonSerializer<Object> serializerFor(Class<? extends Object> p0);
    public abstract PropertySerializerMap newWith(Class<? extends Object> p0, JsonSerializer<Object> p1);
    public final PropertySerializerMap.SerializerAndMapResult findAndAddPrimarySerializer(Class<? extends Object> p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddPrimarySerializer(JavaType p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddSecondarySerializer(Class<? extends Object> p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddSecondarySerializer(JavaType p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddSerializer(Class<? extends Object> p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public final PropertySerializerMap.SerializerAndMapResult findAndAddSerializer(JavaType p0, SerializerProvider p1, BeanProperty p2){ return null; }
    public static PropertySerializerMap emptyMap(){ return null; }
    static public class SerializerAndMapResult
    {
        protected SerializerAndMapResult() {}
        public SerializerAndMapResult(JsonSerializer<Object> p0, PropertySerializerMap p1){}
        public final JsonSerializer<Object> serializer = null;
        public final PropertySerializerMap map = null;
    }
}
